package com.alico.chat.app.security

import org.springframework.beans.factory.annotation.Autowired
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.springframework.security.config.annotation.method.configuration.EnableGlobalMethodSecurity
import org.springframework.security.config.annotation.web.builders.HttpSecurity
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity
import org.springframework.security.config.http.SessionCreationPolicy
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder
import org.springframework.security.web.SecurityFilterChain
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter
import java.security.SecureRandom
import java.util.*


@Configuration
@EnableWebSecurity
@EnableGlobalMethodSecurity(prePostEnabled = true)
class WebSecurityConfig {
    companion object {

        val WHITE_LIST = arrayOf(
            "/v2/register/email",
            "/v2/register",
            "/v2/login",
            "/admin/bridge",
            "/login",
            "/v1/getExitsUserList",
            "/user/checkOnline.json",
            "/v2/loginByUserId",
        )

        fun generateSalt(): String {
            val secureRandom = SecureRandom()
            val salt = ByteArray(16)
            secureRandom.nextBytes(salt)
            return Base64.getEncoder().encodeToString(salt)
        }

        fun hashPassword(password: String, salt: String): String {
            val encoder = BCryptPasswordEncoder()
            return encoder.encode(password + salt)
        }
    }

    @Autowired
    lateinit var jwtAuthenticationTokenFilter: JwtAuthenticationTokenFilter

    @Autowired
    lateinit var restAuthenticationEntryPoint: RestAuthenticationEntryPoint

    @Autowired
    lateinit var restAccessDeniedHandler: RestAccessDeniedHandler

    @Bean
    @Throws(java.lang.Exception::class)
    fun securityFilterChain(http: HttpSecurity): SecurityFilterChain {

        http.authorizeRequests() // 静态资源放行
            .antMatchers(*WHITE_LIST)
            .permitAll() // 除上面外的所有请求全部需要鉴权认证
            .anyRequest()
            .authenticated()
            .and() // CSRF禁用
            .csrf()
            .disable() // 禁用HTTP响应标头
            .headers()
            .cacheControl()
            .disable()
            .and() // 基于JWT令牌，无需Session
            .sessionManagement()
            .sessionCreationPolicy(SessionCreationPolicy.STATELESS)
            .and() // 认证与授权失败处理类
            .exceptionHandling()
            .authenticationEntryPoint(restAuthenticationEntryPoint)
            .accessDeniedHandler(restAccessDeniedHandler)
            .and()
            // 拦截器
            .addFilterBefore(jwtAuthenticationTokenFilter, UsernamePasswordAuthenticationFilter::class.java)
            // 退出登录
//            .logout()
//            .logoutUrl("/user/logout")
//            .addLogoutHandler(logoutHandler)
//            .logoutSuccessHandler(logoutSuccessHandler)
//            .and()
            // 跨域
            .cors()
            .and()
            .headers()
            .frameOptions()
            .disable()

        return http.build()
    }
}