package com.alico.chat.app.security

import com.fasterxml.jackson.databind.ObjectMapper
import org.springframework.security.core.Authentication
import org.springframework.security.web.authentication.AuthenticationSuccessHandler
import java.io.IOException
import javax.servlet.ServletException
import javax.servlet.http.HttpServletRequest
import javax.servlet.http.HttpServletResponse


class MyAuthenticationSuccessHandler: AuthenticationSuccessHandler {
    @Throws(IOException::class, ServletException::class)
    override fun onAuthenticationSuccess(
        request: HttpServletRequest,
        response: HttpServletResponse,
        authentication: Authentication
    ) {
        val result: MutableMap<String, Any> = HashMap()
        result["code"] = 200
        result["message"] = "登录成功"
        response.contentType = "application/json;charset=UTF-8"
        val json: String = ObjectMapper().writeValueAsString(result)
        response.writer.println(json)
    }

}