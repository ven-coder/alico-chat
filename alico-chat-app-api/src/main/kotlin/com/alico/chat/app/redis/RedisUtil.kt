package com.alico.chat.app.redis

import org.springframework.data.redis.core.StringRedisTemplate
import org.springframework.stereotype.Component

@Component
object RedisUtil {

    lateinit var redis: StringRedisTemplate

}