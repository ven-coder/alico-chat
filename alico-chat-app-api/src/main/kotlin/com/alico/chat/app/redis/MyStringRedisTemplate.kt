package com.alico.chat.app.redis

import org.springframework.beans.factory.InitializingBean
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.data.redis.core.StringRedisTemplate
import org.springframework.stereotype.Component

@Component
class MyStringRedisTemplate : InitializingBean {

    @Autowired
    lateinit var redis: StringRedisTemplate
    override fun afterPropertiesSet() {
        RedisUtil.redis = redis
        redis.afterPropertiesSet()
    }

}