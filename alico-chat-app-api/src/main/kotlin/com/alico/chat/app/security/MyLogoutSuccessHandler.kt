package com.alico.chat.app.security

import com.fasterxml.jackson.databind.ObjectMapper
import org.springframework.security.core.Authentication
import org.springframework.security.web.authentication.logout.LogoutSuccessHandler
import java.io.IOException
import javax.servlet.ServletException
import javax.servlet.http.HttpServletRequest
import javax.servlet.http.HttpServletResponse


class MyLogoutSuccessHandler:LogoutSuccessHandler {
    @Throws(IOException::class, ServletException::class)
    override fun onLogoutSuccess(
        request: HttpServletRequest?,
        response: HttpServletResponse,
        authentication: Authentication?
    ) {
        val result: MutableMap<String, Any?> = HashMap()
        result["code"] = 200
        result["message"] = "注销成功"
        result["data"] = null
        response.contentType = "application/json;charset=UTF-8"
        val s: String = ObjectMapper().writeValueAsString(result)
        response.writer.println(s)
    }

}