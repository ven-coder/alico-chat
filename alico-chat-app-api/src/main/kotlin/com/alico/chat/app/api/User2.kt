package com.alico.chat.app.api

import cn.hutool.json.JSONArray
import cn.hutool.json.JSONObject
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper
import com.baomidou.mybatisplus.extension.plugins.pagination.Page
import com.alico.chat.app.api.AliSts.Companion.addAliOssDomain
import com.alico.chat.app.common.JWTUtil
import com.alico.chat.app.response.BaseResponse
import com.alico.chat.app.response.ResponseCode
import com.alico.chat.app.sql.bean.*
import com.alico.chat.app.sql.bean.Album
import com.alico.chat.app.sql.bean.User
import com.alico.chat.app.sql.mapper.*
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.web.bind.annotation.*
import java.text.SimpleDateFormat
import java.time.LocalDate
import java.time.LocalDateTime
import java.time.Period
import java.time.ZoneId
import java.time.format.DateTimeFormatter
import java.util.*

@RestController
@RequestMapping("v2")
class User2 {

    @Autowired
    lateinit var userLikeMapper: UserLikeMapper

    @Autowired
    lateinit var userMapper: UserMapper

    @Autowired
    lateinit var albumMapper: AlbumMapper

    @Autowired
    lateinit var realRecordMapper: RealRecordMapper

    @Autowired
    lateinit var userInfoMapper: UserInfoMapper

    @Autowired
    lateinit var userRelationMapper: UserRelationMapper

    @GetMapping("/chat/userInfo/{id}")
    fun getChatUserInfo(@PathVariable id: String): BaseResponse<JSONObject> {
        userMapper.selectById(id)?.let {
            return BaseResponse<JSONObject>().apply {
                data = JSONObject().apply {
                    set("nickname", it.nickname)
                    set("avatar", it.avatar.addAliOssDomain())
                }
            }
        }
        return BaseResponse(code = com.alico.chat.app.response.ResponseCode.FAIL, message = "error")
    }

    @PostMapping("/realApprove")
    fun postRealApprove(
        @RequestParam("face_img") faceImg: String,
        @RequestParam("real_img") realImg: String
    ): BaseResponse<JSONObject> {
        val securityUser = JWTUtil.getSecurityUser()
        realRecordMapper.selectById(securityUser?.user?.userId)?.let {
            it.faceImg = faceImg
            it.realImg = realImg
            realRecordMapper.updateById(it)
        } ?: let {
            realRecordMapper.insert(
                RealRecord(
                    faceImg = faceImg,
                    realImg = realImg,
                    userId = securityUser?.user?.userId ?: 0
                )
            )
            albumMapper.insert(
                Album(
                    userId = securityUser?.user?.userId ?: 0,
                    image = realImg,
                    mediaType = 0,
                    weight = 0,
                    isBurn = 0,
                    matchSocre = 0.0,
                    isFee = 0,
                    label = 1,
                    audit = 1,
                )
            )
        }
        userMapper.updateById(securityUser?.user?.apply { real = 1 })
        return BaseResponse<JSONObject>()
    }

    fun getZodiacSign(date: String): String {
        val sdf = SimpleDateFormat("yyyy-MM-dd", Locale.getDefault())
        val parsedDate = sdf.parse(date)
        val calendar = Calendar.getInstance()
        calendar.time = parsedDate ?: Date()

        val month = calendar.get(Calendar.MONTH) + 1 // Calendar.MONTH 返回的是0到11之间的值，所以要加1
        val day = calendar.get(Calendar.DAY_OF_MONTH)

        return when (month) {
            1 -> if (day < 20) "Capricorn" else "Aquarius"
            2 -> if (day < 19) "Aquarius" else "Pisces"
            3 -> if (day < 21) "Pisces" else "Aries"
            4 -> if (day < 20) "Aries" else "Taurus"
            5 -> if (day < 21) "Taurus" else "Gemini"
            6 -> if (day < 21) "Gemini" else "Cancer"
            7 -> if (day < 23) "Cancer" else "Leo"
            8 -> if (day < 23) "Leo" else "Virgo"
            9 -> if (day < 23) "Virgo" else "Libra"
            10 -> if (day < 23) "Libra" else "Scorpio"
            11 -> if (day < 22) "Scorpio" else "Sagittarius"
            else -> if (day < 22) "Sagittarius" else "Capricorn"
        }
    }

    @GetMapping("/userInfo")
    fun getUserInfo(): BaseResponse<JSONObject> {
        val customUser = JWTUtil.getSecurityUser()
        val selectList = albumMapper.selectList(QueryWrapper<Album>().eq("user_id", customUser?.user?.userId))
        val userInfo = userInfoMapper.selectById(customUser?.user?.userId)
        return BaseResponse<JSONObject>().apply {
            data = JSONObject(customUser?.user).apply {
                set("avatar", customUser?.user?.avatar?.addAliOssDomain())
                var realStatus = -1
                realRecordMapper.selectOne(
                    QueryWrapper<RealRecord>().eq("user_id", customUser?.user?.userId),
                    false
                )?.let {
                    realStatus = if (it.realImg.isEmpty()) {
                        4
                    } else {
                        1
                    }
                }
                set("realStatus", realStatus)
                var goddessStatus = -1
                val albumGoddess = albumMapper.selectList(
                    QueryWrapper<Album>()
                        .eq("user_id", customUser?.user?.userId)
                        .eq("label", 2)
                )
                albumGoddess.forEach {
                    if (it.audit == 1) {
                        goddessStatus = it.audit
                    }
                    if (goddessStatus != 1 && it.audit == 0) {
                        goddessStatus = 0
                    }
                    if (goddessStatus != 0 && goddessStatus != 1 && it.audit == 2) {
                        goddessStatus = 2
                    }
                }
                if (albumGoddess.isNotEmpty() && realStatus == 4) {
                    goddessStatus = 4
                }
                set("goddessStatus", goddessStatus)
                set("albums", JSONArray().apply {
                    selectList.forEach {
                        add(JSONObject(it).apply {
                            set("image", it.image.addAliOssDomain())
                            set("isBurn", it.isBurn)
                            set("isFee", it.isFee)
                        })
                    }
                })
                set("constellation", getZodiacSign(userInfo.birthday))
                set("profession", userInfo.profession)
                set("liveCity", userInfo.liveCity)

                set("age", calculateAge(userInfo.birthday))
            }
        }
    }

    fun calculateAge(birthDate: String): Int {
        if (birthDate.isEmpty()) return 0
        // 当前日期
        val currentDate = LocalDate.now()

        // 指定的生日
        val birthday = LocalDate.parse(birthDate, DateTimeFormatter.ISO_LOCAL_DATE)

        return Period.between(birthday, currentDate).years
    }

    @GetMapping("/person/{id}")
    fun getUserDetail(@PathVariable id: Long): BaseResponse<JSONObject> {

        val user = userMapper.selectById(id)
        val customUser = JWTUtil.getSecurityUser()
        val userInfo = userInfoMapper.selectById(id)
        return BaseResponse<JSONObject>().apply {
            data = JSONObject(customUser?.user).apply {
                set("remainKey", 0)
                if (customUser?.user?.vip == 1L) {
                    // 获取当前日期的起始时间和结束时间
                    val startOfDay = LocalDateTime.now().withHour(0).withMinute(0).withSecond(0).withNano(0)
                    val endOfDay = LocalDateTime.now().withHour(23).withMinute(59).withSecond(59).withNano(999999999)

                    // 将 LocalDateTime 转换为时间戳（秒）
                    val startTimestamp = startOfDay.atZone(ZoneId.systemDefault()).toEpochSecond()
                    val endTimestamp = endOfDay.atZone(ZoneId.systemDefault()).toEpochSecond()

                    val selectCount = userRelationMapper.selectCount(
                        QueryWrapper<UserRelation>()
                            .eq("user_id", customUser.user.userId)
                            .eq("target_user_id", id)
                            .eq("type", 3)
                            .eq("channel", 1)
                            .between("create_at", startTimestamp, endTimestamp)
                    )
                    set("remainKey", 10 - selectCount)
                }

                set(
                    "unLockChatByMoney", userRelationMapper.selectCount(
                        QueryWrapper<UserRelation>()
                            .eq("user_id", customUser?.user?.userId)
                            .eq("target_user_id", id)
                            .eq("type", 3)
                            .eq("channel", 1)
                    ) > 0
                )
                set("target", JSONObject(user).apply {
                    set("online", user.online == 1L)
                    set("avatar", user.avatar.addAliOssDomain())
                    set("lastOnline", "Online")
                    set("onlineTimeHide", 0)
                    set("distanceHide", 0)
                    set("distance", "0km")
                    set("age", calculateAge(userInfo.birthday))
                    set("city", userInfo.liveCity)
                    set("constellation", "")
                    set("profession", userInfo.profession)
                    set("describe", userInfo.describe)
                    set("height", "${userInfo.height}cm")
                    set("weight", "${userInfo.weight}kg")
                    set("birthday", userInfo.birthday)
                    set("ryUserId", userInfo.userId.toString())
                    set("album", JSONArray().apply {
                        albumMapper.selectList(QueryWrapper<Album>().eq("user_id", id))?.forEach {
                            add(JSONObject(it).apply {
                                set("image", it.image.addAliOssDomain())
                            })
                        }
                    })
                })
            }
        }
    }

    @GetMapping("/userTribe")
    fun getUserTribe(
        @RequestParam(defaultValue = "0") sex: Int,
        @RequestParam(defaultValue = "-1") city: Int,
        @RequestParam(defaultValue = "0") online: Int,
        @RequestParam(defaultValue = "-1") option: Int,
        @RequestParam(defaultValue = "1") page: Long,
        @RequestParam(defaultValue = "20") limit: Long,
        @RequestParam(defaultValue = "") keyword: String,
    ): BaseResponse<JSONObject> {
        val securityUser = JWTUtil.getSecurityUser()
        val userPage = userMapper.selectPage(Page(page, limit), QueryWrapper<User>().orderByDesc("create_at"))
        return BaseResponse<JSONObject>().apply {
            data = JSONObject().apply {
                set("list", JSONArray().apply {
                    if (userPage.records.isNotEmpty()) {
                        val userIds = arrayListOf<Int>()
                        userPage.records.forEach { userIds.add(it.userId) }
                        val userLikes = userLikeMapper.selectList(QueryWrapper<UserLike>().`in`("like_user_id", userIds))
                        val userInfos = userInfoMapper.selectList(QueryWrapper<UserInfo>().`in`("user_id", userIds))
                        userPage.records.forEach { targetUser ->
                            add(JSONObject(targetUser).apply {
                                set("avatar", targetUser.avatar.addAliOssDomain())
                                set("likeTarget", false)
                                userLikes.forEach {
                                    if (it.likeUserId == targetUser.userId && it.userId == (securityUser?.user?.userId ?: 0)) set("likeTarget", true)
                                }
                                set("age", 0)
                                userInfos.forEach {
                                    if (it.userId == targetUser.userId) set("age", calculateAge(it.birthday))
                                }
                            })

                        }
                    }
                })

                set("page", page)
                set("limit", limit)
            }
        }
    }
}