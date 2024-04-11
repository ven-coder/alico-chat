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

@RestController
@RequestMapping("v1")
class User {

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

    @GetMapping("/getExitsUserList")
    fun getExitsUserList(
        @RequestParam(defaultValue = "1") page: Long,
    ): BaseResponse<JSONObject> {
        val userPage = userMapper.selectPage(Page(page, 20), QueryWrapper<User>().orderByDesc("create_at"))
        return BaseResponse<JSONObject>().apply {
            data = JSONObject().apply {
                set("list", JSONArray().apply {
                    userPage.records.forEach {
                        it.avatar = it.avatar.addAliOssDomain()
                        add(JSONObject(it))
                    }
                })
                set("page", page)
                set("limit", 20)
            }
        }
    }

    @GetMapping("/getUserInfo")
    fun getUserInfo(@RequestParam userId: String): BaseResponse<JSONObject> {
        var userInfo = userInfoMapper.selectById(userId)
        if (userInfo == null) {
            val customUser = JWTUtil.getSecurityUser()
            userInfo = UserInfo(userId = customUser?.user?.userId ?: 0)
            userInfoMapper.insert(userInfo)
        }

        return BaseResponse<JSONObject>().apply {
            data = JSONObject(userInfo)
        }
    }

    @PostMapping("/people/like")
    fun postPeopleLike(@RequestParam("user_id") userId: Int): BaseResponse<JSONObject> {
        val securityUser = JWTUtil.getSecurityUser()
        userLikeMapper.selectOne(QueryWrapper<UserLike>().eq("like_user_id", userId), false)?.let {
            userLikeMapper.deleteById(it.id)
            return BaseResponse<JSONObject>().apply {
                data = JSONObject().apply {
                    set("action", 0)
                }
            }
        } ?: let {
            userLikeMapper.insert(UserLike(userId = securityUser?.user?.userId ?: 0, likeUserId = userId))
            return BaseResponse<JSONObject>().apply {
                data = JSONObject().apply {
                    set("action", 1)
                }
            }
        }

    }

    @GetMapping("/chat/userInfo/{id}")
    fun getChatUserInfo(@PathVariable id: String): BaseResponse<JSONObject> {

        val albums = albumMapper.selectList(QueryWrapper<Album>().eq("user_id", id))
        val userInfo = userInfoMapper.selectById(id)

        userMapper.selectById(id)?.let {
            it.avatar = it.avatar.addAliOssDomain()
            return BaseResponse<JSONObject>().apply {
                val data = JSONObject(it).apply {
                    set("albums", JSONArray().apply {
                        albums.forEach {
                            it.image = it.image.addAliOssDomain()
                            add(JSONObject(it))
                        }
                    })
                    set("info", JSONObject(userInfo))
                }
                this.data = data
            }
        }
        return BaseResponse(code = com.alico.chat.app.response.ResponseCode.FAIL, message = "error")
    }

    @GetMapping("/isFollow")
    fun isLike(@RequestParam targetId: String): BaseResponse<JSONObject> {
        val customUser = JWTUtil.getSecurityUser()

        val liked = userLikeMapper.selectCount(QueryWrapper<UserLike>().eq("user_id", customUser?.user?.userId).eq("like_user_id", targetId))

        return BaseResponse<JSONObject>().apply {
            data = JSONObject().apply {
                set("value", liked > 0)
            }
        }
    }


}