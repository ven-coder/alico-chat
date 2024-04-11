package com.alico.chat.app.security

import com.fasterxml.jackson.databind.ObjectMapper
import org.springframework.security.core.AuthenticationException
import org.springframework.security.web.authentication.AuthenticationFailureHandler
import java.io.IOException
import javax.servlet.ServletException
import javax.servlet.http.HttpServletRequest
import javax.servlet.http.HttpServletResponse


class MyAuthenticationFailureHandler : AuthenticationFailureHandler {
    @Throws(IOException::class, ServletException::class)
    override fun onAuthenticationFailure(
        request: HttpServletRequest,
        response: HttpServletResponse,
        exception: AuthenticationException
    ) {
        val result: MutableMap<String, Any?> = HashMap()
        result["code"] = 500
        result["message"] = exception.message
        result["data"] = null
        response.contentType = "application/json;charset=UTF-8"
        val s: String = ObjectMapper().writeValueAsString(result)
        response.writer.println(s)
    }

}