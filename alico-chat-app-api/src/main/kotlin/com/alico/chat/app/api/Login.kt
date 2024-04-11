package com.alico.chat.app.api

import cn.hutool.json.JSONObject
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper
import com.alico.chat.app.api.AliSts.Companion.addAliOssDomain
import com.alico.chat.app.common.DefaultUserInfo
import com.alico.chat.app.common.JWTUtil
import com.alico.chat.app.common.RCHelper
import com.alico.chat.app.response.BaseResponse
import com.alico.chat.app.response.ResponseCode
import com.alico.chat.app.sql.bean.User
import com.alico.chat.app.sql.mapper.UserMapper
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.security.authentication.AuthenticationManager
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken
import org.springframework.web.bind.annotation.*


@RestController
@RequestMapping("/v2")
class Login {

    @Autowired
    lateinit var authenticationManager: AuthenticationManager

    @Autowired
    private lateinit var userMapper: UserMapper

    @PostMapping("/loginByUserId")
    fun loginByUserId(
        @RequestParam userId: String,
    ): BaseResponse<User> {
        val user = userMapper.selectOne(QueryWrapper<User>().eq("user_id", userId), false)
        user?.let {

            if (it.nickname.isEmpty()) {
                it.nickname = DefaultUserInfo.generateRandomNickname()
                userMapper.updateById(it)
            }
            if (it.avatar.isEmpty()) {
                it.avatar = DefaultUserInfo.getRandomMaleAvatar();
                userMapper.updateById(it)
            }

            it.token = JWTUtil.generateUserIdToken(JWTUtil.CLAIM_TYPE_USER, user.userId.toString())
            return BaseResponse<User>(message = "login success").apply {
                data = it.apply {
                    avatar = avatar.addAliOssDomain()
                }
            }
        }
        return BaseResponse(code = com.alico.chat.app.response.ResponseCode.FAIL)
    }

    @PostMapping("/login")
    fun login(
        @RequestParam password: String,
        @RequestParam deviceId: String,
        @RequestParam email: String,
    ): BaseResponse<JSONObject>? {
        val user = userMapper.selectOne(QueryWrapper<User>().eq("email", email))
        user ?: let { return BaseResponse(code = com.alico.chat.app.response.ResponseCode.FAIL, message = "user not exist") }
        authenticationManager
            .authenticate(UsernamePasswordAuthenticationToken(email, password + user.salt))
        val rcToken = RCHelper.getToken(user.userId.toString())
        return BaseResponse<JSONObject>().apply {
            data = JSONObject(user.apply {
                token = JWTUtil.generateToken(JWTUtil.CLAIM_TYPE_USER, user.email)
            }).apply {
                set("ryToken", rcToken)
                set("ryUserId", user.userId.toString())
                set("avatar", user.avatar.addAliOssDomain())
                when (user.status) {
                    -1 -> {
                        if (user.sex == 0) {
                            set("regProgress", "unknown")
                        } else if (user.avatar.isEmpty()) {
                            set("regProgress", "genderSelected")
                        } else if (user.nickname.isEmpty()) {
                            set("regProgress", "uploadedAvatar")
                        } else {
                            set("status", 0)
                        }
                    }
                }
            }
        }
    }
}