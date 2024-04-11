package com.alico.chat.app.security

import cn.hutool.json.JSONObject
import org.springframework.http.HttpStatus
import org.springframework.security.access.AccessDeniedException
import org.springframework.security.web.access.AccessDeniedHandler
import java.io.IOException
import javax.servlet.http.HttpServletRequest
import javax.servlet.http.HttpServletResponse

/**
 * 自定义无权访问处理类
 *
 * @author william@StarImmortal
 * @date 2022/12/16
 */
class RestAccessDeniedHandler : AccessDeniedHandler {
    @Throws(IOException::class)
    override fun handle(
        request: HttpServletRequest, response: HttpServletResponse,
        accessDeniedException: AccessDeniedException
    ) {
        response.setHeader("Access-Control-Allow-Origin", "*")
        response.setHeader("Cache-Control", "no-cache")
        response.setContentType("application/json")
        response.setCharacterEncoding("UTF-8")
        response.setStatus(HttpStatus.FORBIDDEN.value())
        response.getWriter()
            .println(
                JSONObject().apply {
                    putOpt("massage", "Forbidden")
                }.toString()
            )
        response.getWriter().flush()
    }
}