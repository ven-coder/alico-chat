package com.alico.chat.app.api

import cn.hutool.json.JSONArray
import cn.hutool.json.JSONObject
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper
import com.baomidou.mybatisplus.extension.plugins.pagination.Page
import com.alico.chat.app.api.AliSts.Companion.addAliOssDomain
import com.alico.chat.app.common.JWTUtil
import com.alico.chat.app.response.BaseResponse
import com.alico.chat.app.sql.bean.*
import com.alico.chat.app.sql.mapper.*
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.RestController
import java.time.Instant
import java.time.LocalDate
import java.time.LocalDateTime
import java.time.ZoneId
import java.time.format.DateTimeFormatter

@RestController
@RequestMapping("/v2")
class Blog2 {

    @Autowired
    lateinit var carouselMapper: CarouselMapper

    @Autowired
    lateinit var activityLabelMapper: ActivityLabelMapper

    @Autowired
    lateinit var activityMapper: ActivityMapper

    @Autowired
    lateinit var activityCommentMapper: ActivityCommentMapper

    @Autowired
    lateinit var activityLikeMapper: ActivityLikeMapper

    @Autowired
    lateinit var userMapper: UserMapper

    @Autowired
    lateinit var activitySignMapper: ActivitySignMapper

    @Autowired
    lateinit var locationMapper: LocationMapper

    @Autowired
    lateinit var desiredObjectMapper: DesiredObjectMapper

    /**
     * 个人动态
     */
    @GetMapping("/userBlog/{id}")
    fun getUserBlog(
        @PathVariable id: Long,
        @RequestParam limit: Long,
        @RequestParam page: Long,
        @RequestParam type: String
    ): BaseResponse<JSONObject> {

        val activities = activityMapper.selectPage(
            Page(page, limit),
            QueryWrapper<Activity>().apply {
                eq("user_id", id)
                orderByDesc("create_at")
            }
        )
        return getBlogs(activities.records, page, limit)
    }

    @PostMapping("/programSign")
    fun postProgramSign(
        @RequestParam("activity_id") activityId: Int,
        @RequestParam("image") image: String,
    ): BaseResponse<JSONObject> {

        val securityUser = JWTUtil.getSecurityUser()
        activitySignMapper.insert(
            ActivitySign(
                activityId = activityId,
                image = image,
                userId = securityUser?.user?.userId ?: 0
            )
        )

        return BaseResponse<JSONObject>()
    }

    @PostMapping("/pubBlog/activity")
    fun postActivity(
        @RequestParam("images[]") images: List<String>,
        @RequestParam("hopeBeaus[]") hopeBeaus: List<String>,
        @RequestParam(required = false) content: String?,
        @RequestParam activityTime: String,
        @RequestParam activityPeriod: String,
        @RequestParam cityId: String,
        @RequestParam labelCode: String,
        @RequestParam disableComment: Int,
        @RequestParam enableHide: Int,
        @RequestParam positionCity: String,
    ): BaseResponse<JSONObject> {
        val securityUser = JWTUtil.getSecurityUser()
        val location = locationMapper.selectById(cityId)
        val formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd")
        val date = LocalDate.parse(activityTime, formatter)

        val zoneId = ZoneId.systemDefault()
        val epochSecond = date.atStartOfDay(zoneId).toEpochSecond()

        val desiredObjectNames = arrayListOf<String>()
        desiredObjectMapper.selectList(QueryWrapper<DesiredObject>().`in`("object_classify_id", hopeBeaus)).forEach {
            desiredObjectNames.add(it.objectClassifyName)
        }
        activityMapper.insert(
            Activity(
                images = images.joinToString(separator = ","),
                objectClassifyId = hopeBeaus.joinToString(separator = ","),
                objectClassifyName = desiredObjectNames.joinToString(separator = ","),
                content = content ?: "",
                activityTime = epochSecond,
                dateRange = activityPeriod,
                locationId = cityId.toInt(),
                locationName = location.locationName,
                labelCode = labelCode,
                isComment = disableComment,
                isHidden = enableHide,
                userId = securityUser?.user?.userId ?: 0,
            )
        )
        return BaseResponse<JSONObject>()
    }

    @GetMapping("/blogLabel")
    fun getBlogLabel(): BaseResponse<JSONArray> {
        val activityLabels = activityLabelMapper.selectList(QueryWrapper())
        return BaseResponse<JSONArray>().apply {
            data = JSONArray().apply {
                activityLabels.forEach { add(JSONObject(it)) }
            }
        }
    }

    @PostMapping("/pubBlog/talk")
    fun postTalk(
        @RequestParam("images[]") images: List<String>,
        @RequestParam content: String,
        @RequestParam disableComment: Int,
        @RequestParam enableHide: Int,
        @RequestParam positionCity: String,
    ): BaseResponse<JSONObject> {
        activityMapper.insert(
            Activity(
                content = content,
                images = images.joinToString(separator = ",") { it },
                activityType = 1,
                labelCode = "DEFAULT",
                userId = JWTUtil.getSecurityUser()?.user?.userId ?: 0,
            )
        )
        return BaseResponse()
    }

    @GetMapping("/blogArticle/{id}")
    fun getBlogArticle(@PathVariable id: Long): BaseResponse<JSONObject> {

        val activity = activityMapper.selectById(id)
        val customUser = JWTUtil.getSecurityUser()

        return BaseResponse<JSONObject>().apply {
            data = JSONObject(activity).apply {
                val user = userMapper.selectById(activity.userId)
                set("avatar", user.avatar.addAliOssDomain())
                set("nickname", user.nickname)
                set("sex", user.sex)
                set("vip", user.vip)
                set("real", user.real)
                // 将时间戳转换为 LocalDateTime 对象
                val dateTime = LocalDateTime.ofInstant(
                    Instant.ofEpochSecond(activity.createAt),
                    ZoneId.systemDefault()
                )

                // 定义日期时间格式
                val formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm")
                // 格式化日期时间
                val formattedDateTime = dateTime.format(formatter)
                set("createAt", formattedDateTime)
                set("images", JSONArray().apply {
                    activity.images.split(",").forEach {
                        if (it.isEmpty()) return@forEach
                        add(it.addAliOssDomain())
                    }
                })

                set(
                    "liked",
                    activityLikeMapper.selectList(
                        QueryWrapper<ActivityLike>().eq(
                            "activity_id",
                            activity.activityId
                        ).eq("user_id", customUser?.user?.userId)
                    ).isNotEmpty()
                )

                set(
                    "likeCount",
                    activityLikeMapper.selectCount(
                        QueryWrapper<ActivityLike>().eq(
                            "activity_id",
                            activity.activityId
                        )
                    )
                )

                set(
                    "signed",
                    activitySignMapper.selectList(
                        QueryWrapper<ActivitySign>().eq(
                            "activity_id",
                            activity.activityId
                        ).eq("user_id", customUser?.user?.userId)
                    ).isNotEmpty()
                )

                set("signs", JSONArray())
                set("likes", JSONArray().apply {
                    activityLikeMapper.selectList(
                        QueryWrapper<ActivityLike>().eq(
                            "activity_id",
                            activity.activityId
                        )
                    )?.forEach {
                        add(JSONObject(it))
                    }
                })
                activityCommentMapper.selectList(
                    QueryWrapper<com.alico.chat.app.sql.bean.ActivityComment>().eq(
                        "activity_id",
                        activity.activityId
                    ).orderByDesc("created_at")
                ).let {
                    set("comments", JSONArray().apply {
                        it.forEach {
                            val commentUser = userMapper.selectById(it.userId)
                            val commentToUser = userMapper.selectById(it.toUserId)
                            add(JSONObject(it).apply {
                                set("username", commentUser.nickname)
                                set("toUsername", commentToUser.nickname)
                                set("commentUserInfo", JSONObject(commentUser.apply {
                                    avatar = avatar.addAliOssDomain()
                                }))
                            })
                        }
                    })
                    set("commentCount", it?.size)
                }


            }
        }
    }

    @GetMapping("/blog")
    fun getBlogList(
        @RequestParam sort: String,
        @RequestParam(defaultValue = "0") sex: Int,
        @RequestParam page: Long,
        @RequestParam limit: Long,
        @RequestParam(defaultValue = "") city: String,
        @RequestParam online: String,
        @RequestParam(defaultValue = "") label: String,
    ): BaseResponse<JSONObject> {
        val activities = activityMapper.selectPage(
            Page(page, limit),
            QueryWrapper<Activity>().apply {
                if (sex != 0) eq("sex", sex)
                if (city.isNotEmpty() && city != "0") eq("position_city", city)
                if (label.isNotEmpty() && label != "DEFAULT") eq("label_code", label)
                orderByDesc("create_at")
            }
        )
        return getBlogs(activities.records, page, limit)
    }

    fun getBlogs(activities: List<Activity>, page: Long, limit: Long): BaseResponse<JSONObject> {
        val customUser = JWTUtil.getSecurityUser()
        return BaseResponse<JSONObject>().apply {
            val jsonObject = JSONObject().apply {
                set("list", JSONArray().apply {
                    activities.forEach { activity ->
                        val user = userMapper.selectById(activity.userId) ?: return@forEach
                        add(JSONObject(activity).apply {
                            set("avatar", user.avatar.addAliOssDomain())
                            set("nickname", user.nickname)
                            set("sex", user.sex)
                            // 将时间戳转换为 LocalDateTime 对象
                            val dateTime = LocalDateTime.ofInstant(
                                Instant.ofEpochSecond(activity.createAt),
                                ZoneId.systemDefault()
                            )

                            // 定义日期时间格式
                            val formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm")
                            // 格式化日期时间
                            val formattedDateTime = dateTime.format(formatter)
                            set("createAt", formattedDateTime)
                            set("images", JSONArray().apply {
                                activity.images.split(",").forEach {
                                    if (it.isEmpty()) return@forEach
                                    add(it.addAliOssDomain())
                                }
                            })

                            set(
                                "liked",
                                activityLikeMapper.selectList(
                                    QueryWrapper<ActivityLike>().eq(
                                        "activity_id",
                                        activity.activityId
                                    ).eq("user_id", customUser?.user?.userId)
                                ).isNotEmpty()
                            )

                            set(
                                "likeCount",
                                activityLikeMapper.selectCount(
                                    QueryWrapper<ActivityLike>().eq(
                                        "activity_id",
                                        activity.activityId
                                    )
                                )
                            )

                            set(
                                "signed",
                                activitySignMapper.selectList(
                                    QueryWrapper<ActivitySign>().eq(
                                        "activity_id",
                                        activity.activityId
                                    ).eq("user_id", customUser?.user?.userId)
                                ).isNotEmpty()
                            )
                            set("isFinish", activity.isFinish)
                            set("likes", JSONArray().apply {
                                activityLikeMapper.selectList(
                                    QueryWrapper<ActivityLike>().eq(
                                        "activity_id",
                                        activity.activityId
                                    )
                                )?.forEach {
                                    add(JSONObject(it))
                                }
                            })
                            activityCommentMapper.selectList(
                                QueryWrapper<com.alico.chat.app.sql.bean.ActivityComment>().eq(
                                    "activity_id",
                                    activity.activityId
                                )
                            )?.let {
                                set("comments", JSONArray().apply {
                                    it.forEach {
                                        add(JSONObject(it).apply {
                                            userMapper.selectById(it.userId)?.let {
                                                set("username", it.nickname)
                                            }
                                        })
                                    }
                                })
                                set("commentCount", it.size)
                            }


                            set("activityTime", "${timestampToFormattedDate(activity.activityTime)} ${activity.dateRange}")

                            set("hopeBeauNames", JSONArray().apply {
                                activity.objectClassifyName.split(",").forEach { add(it) }
                            })
                        })
                    }
                })
                set("page", page)
                set("limit", limit)
            }
            data = jsonObject
        }
    }

    fun timestampToFormattedDate(timestampSeconds: Long): String {
        val dateTime = LocalDateTime.ofInstant(
            Instant.ofEpochSecond(timestampSeconds),
            ZoneId.systemDefault()
        )
        val formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd")
        return dateTime.format(formatter)
    }

    @GetMapping("/blogLabelAndSlide")
    fun getBlogLabelAndSlide(): BaseResponse<JSONObject> {
        val carousels = carouselMapper.selectList(QueryWrapper<Carousel>().eq("status", 0))
        val activityLabels = activityLabelMapper.selectList(QueryWrapper<ActivityLabel>().eq("label_status", 0))
        return BaseResponse<JSONObject>().apply {
            data = JSONObject().apply {
                set("slide", JSONArray().apply {
                    carousels.forEach {
                        add(JSONObject(it))
                    }
                })
                set("label", JSONArray().apply {
                    activityLabels.forEach {
                        add(JSONObject(it))
                    }
                })
            }
        }
    }

}