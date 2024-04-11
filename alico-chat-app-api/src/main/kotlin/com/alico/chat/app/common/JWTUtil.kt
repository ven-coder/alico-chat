package com.alico.chat.app.common

import com.auth0.jwt.JWT
import com.auth0.jwt.algorithms.Algorithm
import com.auth0.jwt.exceptions.JWTVerificationException
import com.alico.chat.app.redis.RedisUtil
import com.alico.chat.app.security.CustomUser
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken
import org.springframework.security.core.context.SecurityContextHolder
import java.util.*
import java.util.concurrent.TimeUnit
import javax.servlet.http.HttpServletRequest

object JWTUtil {
    const val CLAIM_USERNAME = "username"
    const val CLAIM_USER_ID = "USER_ID"
    const val CLAIM_TYPE = "TYPE"
    const val CLAIM_TYPE_USER = "CLAIM_TYPE_USER"
    const val AUTHORIZATION_HEADER = "Authorization"
    const val AUTHORIZATION_BEARER = "Bearer "

    //token过期时间，分
    const val TOKEN_EFFECTIVE_TIME = 60L * 24

    fun getSecurityUser(): CustomUser? {
        if (SecurityContextHolder.getContext().authentication is UsernamePasswordAuthenticationToken) {
            if (SecurityContextHolder.getContext().authentication.principal is CustomUser) {
                return SecurityContextHolder.getContext().authentication.principal as CustomUser
            }
        }
        return null
    }

    fun getToken(request: HttpServletRequest): String {
        return request.getHeader(AUTHORIZATION_HEADER)
            .replace(AUTHORIZATION_BEARER, "")
    }

    /**
     * 从令牌中解析用户名信息
     * @param token 令牌
     * @return 用户名
     */
    fun getUserId(token: String?): String? {
        return try {
            val decode = JWT.decode(token)
            decode.claims[CLAIM_USER_ID]?.asString()
        } catch (e: JWTVerificationException) {
            throw e
        }
    }

    /**
     * 生成令牌
     * @param tokenType 令牌类型
     * @param username 用户名
     * @param expires 过期时间
     * @return 令牌
     */
    fun generateToken(tokenType: String?, username: String?): String {
        tokenType ?: return ""
        username ?: return ""
        val token = JWT.create()
            .withClaim(CLAIM_TYPE, tokenType)
            .withClaim(CLAIM_USERNAME, username)
//            .withExpiresAt(DateUtil.addSeconds(expires))
            .withJWTId(UUID.randomUUID().toString())
            .sign(Algorithm.HMAC256("secret"))
        RedisUtil.redis.opsForValue()[getKeyToken(username), token, TOKEN_EFFECTIVE_TIME] = TimeUnit.MINUTES
        return token
    }

    fun generateUserIdToken(tokenType: String?, userId: String?): String {
        tokenType ?: return ""
        userId ?: return ""
        val token = JWT.create()
            .withClaim(CLAIM_TYPE, tokenType)
            .withClaim(CLAIM_USER_ID, userId)
//            .withExpiresAt(DateUtil.addSeconds(expires))
            .withJWTId(UUID.randomUUID().toString())
            .sign(Algorithm.HMAC256("secret"))
        RedisUtil.redis.opsForValue()[getKeyToken(userId), token, TOKEN_EFFECTIVE_TIME] = TimeUnit.MINUTES
        return token
    }

    fun getKeyToken(userId: String): String {
        return "token_$userId"
    }

    fun isValidToken(userId: String, token: String?): Boolean {
        token ?: return false
        val redisToken = RedisUtil.redis.opsForValue()[getKeyToken(userId)]
        if (token != redisToken) {
            return false
        }
        return true
    }
}