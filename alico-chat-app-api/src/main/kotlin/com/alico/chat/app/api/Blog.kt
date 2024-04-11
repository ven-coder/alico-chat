package com.alico.chat.app.api

import cn.hutool.json.JSONObject
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper
import com.alico.chat.app.common.JWTUtil
import com.alico.chat.app.response.BaseResponse
import com.alico.chat.app.sql.bean.*
import com.alico.chat.app.sql.mapper.*
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.PutMapping
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.RestController

@RestController
@RequestMapping("/v1")
class Blog {

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

    @PutMapping("/program/end")
    fun putProgramEnd(
        @RequestParam("activity_id") activityId: String
    ): BaseResponse<JSONObject> {
        activityMapper.selectById(activityId)?.let {
            activityMapper.updateById(it.apply { isFinish = 1 })
        }
        return BaseResponse<JSONObject>()
    }

    @PostMapping("/activityComment")
    fun postActivityComment(
        @RequestParam("activity_id") activityId: Int,
        @RequestParam("comment") comment: String,
        @RequestParam("commentType") commentType: Int,
    ): BaseResponse<JSONObject> {

        val securityUser = JWTUtil.getSecurityUser()
        val activity = activityMapper.selectById(activityId)
        val toUser = userMapper.selectById(activity.userId)
        val activityComment = com.alico.chat.app.sql.bean.ActivityComment(
            userId = securityUser?.user?.userId ?: 0,
            toUserId = activity.userId,
            activityId = activityId,
            activityType = activity.activityType,
            commentType = commentType,
            commentUserId = securityUser?.user?.userId ?: 0,
            comment = comment
        )
        activityCommentMapper.insert(activityComment)
        return BaseResponse<JSONObject>().apply {
            data = JSONObject().apply {
                set("document", JSONObject().apply {
                    set("user_id", activityComment.userId)
                    set("to_user_id", activityComment.toUserId)
                    set("activity_id", activityComment.activityId)
                    set("activity_type", activityComment.activityType)
                    set("comment_type", activityComment.commentType)
                    set("comment_user_id", activityComment.commentUserId)
                    set("comment", activityComment.comment)
                    set("username", securityUser?.user?.nickname ?: "")
                    set("toUsername", toUser.nickname)
                })
            }
        }
    }

    @PostMapping("/activityLike")
    fun postActivityLike(@RequestParam("activity_id") activityId: Int): BaseResponse<JSONObject> {
        val user = JWTUtil.getSecurityUser()?.user
        val likes = activityLikeMapper.selectOne(
            QueryWrapper<ActivityLike>().eq("activity_id", activityId).eq("user_id", user?.userId ?: 0), false
        )
        if (likes != null) {
            activityLikeMapper.deleteById(likes)
        } else {
            activityLikeMapper.insert(
                ActivityLike(
                    activityId = activityId,
                    userId = user?.userId ?: 0
                )
            )

        }
        return BaseResponse<JSONObject>()
    }

}