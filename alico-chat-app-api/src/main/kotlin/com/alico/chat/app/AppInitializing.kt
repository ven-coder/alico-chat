package com.alico.chat.app

import com.alico.chat.app.api.AliSts
import com.alico.chat.app.common.RCHelper
import org.springframework.beans.factory.InitializingBean
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.core.env.Environment
import org.springframework.stereotype.Component

@Component
class AppInitializing : InitializingBean {
    @Autowired
    lateinit var environment: Environment
    override fun afterPropertiesSet() {
        val ossDomain = environment.getProperty("spring.cloud.alicloud.oss.domain") ?: ""
        AliSts.domain = ossDomain

        val rcAppKey = environment.getProperty("rongcloud.app-key") ?: ""
        val rcAppSecret = environment.getProperty("rongcloud.app-secret") ?: ""
        RCHelper.appKey = rcAppKey
        RCHelper.appSecret = rcAppSecret

    }
}