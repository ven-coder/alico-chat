package com.alico.chat.app.security

import cn.hutool.json.JSONObject
import org.springframework.http.HttpStatus
import org.springframework.security.core.AuthenticationException
import org.springframework.security.web.AuthenticationEntryPoint
import java.io.IOException
import javax.servlet.http.HttpServletRequest
import javax.servlet.http.HttpServletResponse

/**
 * 认证失败处理类
 *
 * @author william@StarImmortal
 * @date 2022/12/16
 */
class RestAuthenticationEntryPoint : AuthenticationEntryPoint {
    @Throws(IOException::class)
    override fun commence(
        request: HttpServletRequest, response: HttpServletResponse,
        authException: AuthenticationException
    ) {
        response.setHeader("Access-Control-Allow-Origin", "*")
        response.setHeader("Cache-Control", "no-cache")
        response.contentType = "application/json"
        response.characterEncoding = "UTF-8"
        response.status = HttpStatus.UNAUTHORIZED.value()
        response.writer.println(JSONObject().apply {
            putOpt("massage", "Unauthorized")
        }.toString())
        response.writer.flush()
    }
}