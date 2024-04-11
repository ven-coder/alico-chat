package com.alico.chat.app.api

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper
import com.alico.chat.app.api.AliSts.Companion.addAliOssDomain
import com.alico.chat.app.common.DefaultUserInfo
import com.alico.chat.app.common.JWTUtil
import com.alico.chat.app.response.BaseResponse
import com.alico.chat.app.response.ResponseCode
import com.alico.chat.app.sql.bean.User
import com.alico.chat.app.sql.mapper.UserMapper
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.core.env.Environment
import org.springframework.data.redis.core.StringRedisTemplate
import org.springframework.http.ResponseEntity
import org.springframework.mail.javamail.JavaMailSender
import org.springframework.mail.javamail.MimeMessageHelper
import org.springframework.web.bind.annotation.*
import java.security.SecureRandom
import java.util.concurrent.TimeUnit


@RestController
class Login2(private val environment: Environment) {

    @Autowired
    private var javaMailSender: JavaMailSender? = null

    @Autowired
    private lateinit var userMapper: UserMapper

    @Autowired
    private lateinit var redisTemplate: StringRedisTemplate

    private val secureRandom: SecureRandom = SecureRandom()
    var REDIS_KEY_PREFIX = "verification_code:"

    fun generateCode(length: Int): String {
        val code = StringBuilder()
        for (i in 0 until length) {
            val randomNumber: Int = secureRandom.nextInt(10) // 生成0到9的随机数字
            code.append(randomNumber)
        }
        return code.toString()
    }

    @PostMapping("/login/code")
    fun sendCode(@RequestParam email: String): ResponseEntity<BaseResponse<String>> {
        if (email.isEmpty()) {
            return ResponseEntity.ok(
                BaseResponse<String>(
                    code = com.alico.chat.app.response.ResponseCode.FAIL, message = "email is empty"
                )
            )
        }

        val users = userMapper.selectList(QueryWrapper<User>().eq("email", email))
        if (users.isNotEmpty()) {
            return ResponseEntity.ok().body(BaseResponse<String>(code = com.alico.chat.app.response.ResponseCode.FAIL, message = "$email existed"))
        }

        val generateCode = generateCode(6)
        val content = "<!DOCTYPE html>\n" +
                "<html lang=\"en\">\n" +
                "<head>\n" +
                "    <meta charset=\"UTF-8\">\n" +
                "    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n" +
                "    <title>Email Verification Code</title>\n" +
                "</head>\n" +
                "<body>\n" +
                "\n" +
                "    <p style=\"font-size: 16px; font-weight: bold;\">邮箱验证码</p>\n" +
                "\n" +
                "    <p>尊敬的用户，</p>\n" +
                "\n" +
                "    <p>感谢您使用我们的服务！为了确保您的账户安全，我们为您生成了以下验证码：</p>\n" +
                "\n" +
                "    <p style=\"font-size: 20px; font-weight: bold; color: #007BFF;\">验证码：$generateCode</p>\n" +
                "\n" +
                "    <p>请在页面上输入此验证码，完成身份验证。请注意，验证码仅在一定时间内有效。</p>\n" +
                "\n" +
                "    <p>如果您没有进行此操作，可能是有人误用了您的邮箱，请立即联系我们的客户服务团队。</p>\n" +
                "\n" +
                "    <p>谢谢您的配合！</p>\n" +
                "\n" +
                "    <p style=\"font-size: 14px;\">此致，<br>[你的公司/网站名称]</p>\n" +
                "\n" +
                "</body>\n" +
                "</html>\n"
        val mailUsername = environment.getProperty("spring.mail.username")
        javaMailSender?.let {
            try {
                val message = it.createMimeMessage().apply { setFrom(mailUsername) }
                val helper = MimeMessageHelper(message, true)
                helper.setTo(email)
                helper.setSubject("AlicoChat注册验证码")
                helper.setText(content, true) // 第二个参数为 true 表示内容为 HTML
                it.send(message)
            } catch (e: Throwable) {
                e.printStackTrace()
            }

        }
        // 存储验证码到 Redis，并设置有效期为5分钟
        val redisKey = REDIS_KEY_PREFIX + email
        redisTemplate.opsForValue()[redisKey, generateCode, 1] = TimeUnit.MINUTES
        return ResponseEntity.ok().body(BaseResponse<String>().apply { data = generateCode })
    }

    fun getCodeFromRedis(email: String): String? {
        val redisKey = REDIS_KEY_PREFIX + email
        return redisTemplate.opsForValue()[redisKey]
    }

    @PostMapping("/login")
    fun register(
        @RequestParam deviceId: String,
    ): ResponseEntity<BaseResponse<User>> {
        val user = userMapper.selectOne(QueryWrapper<User>().eq("device_id", deviceId), false)
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
            return ResponseEntity.ok().body(BaseResponse<User>(message = "login success").apply {
                data = it.apply {
                    avatar = avatar.addAliOssDomain()
                }
            })
        } ?: let {
            val user = User().apply {
                this.deviceId = deviceId
            }
            userMapper.insert(user)
            ResponseEntity.ok().body(BaseResponse<User>(message = "login success").apply {
                data = user.apply {
                    token = JWTUtil.generateUserIdToken(JWTUtil.CLAIM_TYPE_USER, user.userId.toString())
                }
            })
            return ResponseEntity.ok().body(BaseResponse<User>(message = "login success").apply {
                data = user.apply {
                    token = JWTUtil.generateUserIdToken(JWTUtil.CLAIM_TYPE_USER, user.userId.toString())
                    avatar = avatar.addAliOssDomain()
                }
            })
        }
    }


}