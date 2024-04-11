package com.alico.chat.app.api

import cn.hutool.json.JSONObject
import com.alico.chat.app.common.JWTUtil
import com.alico.chat.app.response.BaseResponse
import com.alico.chat.app.sql.bean.UserRelation
import com.alico.chat.app.sql.mapper.UserRelationMapper
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.RestController
import java.time.*

@RestController
@RequestMapping("v1")
class Transaction {
    @Autowired
    lateinit var userRelationMapper: UserRelationMapper

    @PostMapping("/openContact/privilege")
    fun postOpenContactPrivilege(@RequestParam("user_id") userId: Int): BaseResponse<JSONObject> {
        val securityUser = JWTUtil.getSecurityUser()
        // 获取当前系统时区
        val zoneId = ZoneId.systemDefault()
        // 获取当前时间
        val currentTime = LocalDateTime.now(zoneId)
        // 将时间设置为当天的 23:59:59
        val endOfDay = currentTime.withHour(23).withMinute(59).withSecond(59).withNano(0)
        // 将 LocalDateTime 转换为时间戳秒数
        val timestamp = endOfDay.atZone(zoneId).toEpochSecond()
        userRelationMapper.insert(
            UserRelation(
                userId = securityUser?.user?.userId ?: 0,
                targetUserId = userId,
                type = 3,
                channel = 1,
                expireTime = timestamp
            )
        )
        return BaseResponse<JSONObject>()
    }
}