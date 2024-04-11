package net.lab1024.sa.base

import net.lab1024.sa.base.common.constant.AliOss
import net.lab1024.sa.base.common.controller.AliSts
import org.springframework.beans.factory.InitializingBean
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.core.env.Environment
import org.springframework.stereotype.Component

@Component
class AppInitializing : InitializingBean {
    @Autowired
    lateinit var environment: Environment
    override fun afterPropertiesSet() {
        val ossDomain = environment.getProperty("file.storage.cloud.url-prefix") ?: ""
        AliOss.FILE_DOMAIN = ossDomain

    }
}