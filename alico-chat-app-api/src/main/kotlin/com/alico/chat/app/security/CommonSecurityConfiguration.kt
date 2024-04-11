package com.alico.chat.app.security

import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.springframework.security.authentication.AuthenticationManager
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder
import org.springframework.security.crypto.password.PasswordEncoder

/**
 * Spring Security 通用配置项（解决循环依赖）
 *
 * @author william@StarImmortal
 * @date 2022/12/16
 */
@Configuration
class CommonSecurityConfiguration {
    /**
     * 强散列哈希加密实现
     */
    @Bean
    fun passwordEncoder(): PasswordEncoder {
        return BCryptPasswordEncoder()
    }

    /**
     * 认证管理器
     * @param authenticationConfiguration AuthenticationConfiguration
     * @return AuthenticationManager
     */
    @Bean
    @Throws(Exception::class)
    fun authenticationManager(authenticationConfiguration: AuthenticationConfiguration): AuthenticationManager {
        return authenticationConfiguration.getAuthenticationManager()
    }

    /**
     * JWT登录授权过滤器
     * @return JwtAuthenticationTokenFilter
     */
    @Bean
    fun jwtAuthenticationTokenFilter(): JwtAuthenticationTokenFilter {
        return JwtAuthenticationTokenFilter()
    }

    /**
     * 认证失败处理类
     * @return RestAuthenticationEntryPoint
     */
    @Bean
    fun restAuthenticationEntryPoint(): RestAuthenticationEntryPoint {
        return RestAuthenticationEntryPoint()
    }

    /**
     * 自定义无权访问处理类
     * @return RestAccessDeniedHandler
     */
    @Bean
    fun restAccessDeniedHandler(): RestAccessDeniedHandler {
        return RestAccessDeniedHandler()
    }

    /**
     * 退出登录成功处理器
     * @return LogoutSuccessHandler
     */
//    @Bean
//    fun logoutSuccessHandler(): LogoutSuccessHandler {
//        return LogoutSuccessHandler()
//    }
}