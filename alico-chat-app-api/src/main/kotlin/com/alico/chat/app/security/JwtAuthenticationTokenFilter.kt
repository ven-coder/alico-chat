package com.alico.chat.app.security

import com.alico.chat.app.common.JWTUtil
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken
import org.springframework.security.core.context.SecurityContextHolder
import org.springframework.security.core.userdetails.UserDetailsService
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource
import org.springframework.web.filter.OncePerRequestFilter
import javax.servlet.FilterChain
import javax.servlet.http.HttpServletRequest
import javax.servlet.http.HttpServletResponse

class JwtAuthenticationTokenFilter : OncePerRequestFilter() {
    @Autowired
    lateinit var userDetailsService: UserDetailsService
    override fun doFilterInternal(
        request: HttpServletRequest,
        response: HttpServletResponse,
        filterChain: FilterChain
    ) {

        //白名单直接通过
        if (WebSecurityConfig.WHITE_LIST.contains(request.servletPath)) {
            filterChain.doFilter(request, response)
            return
        }

        val token = JWTUtil.getToken(request)
        var userId = ""
        if (token.isNotEmpty() && JWTUtil.isValidToken(userId.run {
                userId = JWTUtil.getUserId(token) ?: ""
                userId
            }, token)) {
            val userDetails = userDetailsService.loadUserByUsername(userId)
            // 权限信息
            val authentication = UsernamePasswordAuthenticationToken(
                userDetails,
                null, userDetails.authorities
            )
            authentication.details = WebAuthenticationDetailsSource().buildDetails(request)
            SecurityContextHolder.getContext().authentication = authentication
        }

        filterChain.doFilter(request, response)
    }
}