package com.alico.chat.app.api

import cn.hutool.json.JSONObject
import com.alico.chat.app.common.JWTUtil
import com.alico.chat.app.common.OkhttpWrapper
import com.alico.chat.app.common.RCHelper
import com.alico.chat.app.response.BaseResponse
import com.alico.chat.app.response.ResponseCode
import okhttp3.FormBody
import okhttp3.Request
import org.springframework.beans.factory.annotation.Value
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.RestController
import java.lang.System
import java.util.concurrent.ConcurrentHashMap

@RestController
class RongClond {

    @Value("\${rongcloud.app-key}")
    lateinit var appKey: String

    @Value("\${rongcloud.app-secret}")
    lateinit var appSecret: String

    val onlineStatusCaches = ConcurrentHashMap<String, OnlineStatus>()

    @GetMapping("/rongclond/token")
    fun getRongclondToken(): BaseResponse<String> {
        val customUser = JWTUtil.getSecurityUser()
        val rcToken = RCHelper.getToken(customUser?.user?.userId?.toString() ?: "")
        return BaseResponse<String>().apply {
            data = rcToken
        }
    }

    @GetMapping("/user/checkOnline.json")
    fun checkUserOnline(@RequestParam userId: String): BaseResponse<JSONObject> {

        val onlineStatus = onlineStatusCaches[userId]
        if (onlineStatus != null && System.currentTimeMillis() - onlineStatus.fetchTime < 60 * 1000) {
            return BaseResponse<JSONObject>().apply {
                data = JSONObject().apply {
                    set("userId", userId)
                    set("rcOnline", onlineStatus.rcOnline)
                }
            }
        }

        val timestamp = System.currentTimeMillis().toString()
        val nonce = RCHelper.generateRandomString(18)
        val combinedString = appSecret + nonce + timestamp
        val signature = RCHelper.calculateSHA1(combinedString)
        val request = Request.Builder()
            .url("https://api.rong-api.com/user/checkOnline.json")
            .header("RC-App-Key", appKey)
            .header("RC-Nonce", nonce)
            .header("RC-Timestamp", timestamp)
            .header("RC-Signature", signature)
            .post(
                FormBody.Builder()
                    .add("userId", userId)
                    .build()
            ).build()
        val call = com.alico.chat.app.common.OkhttpWrapper.getClient().newCall(request)
        try {
            val response = call.execute()
            if (response.isSuccessful) {
                response.body?.string()?.let {
                    JSONObject(it).apply {
                        val code = getInt("code")
                        if (code == 200) {
                            val status = getStr("status")
                            onlineStatusCaches[userId] = OnlineStatus().apply {
                                this.rcOnline = status
                                fetchTime = System.currentTimeMillis()
                            }
                            return BaseResponse<JSONObject>().apply {
                                data = JSONObject().apply {
                                    set("userId", userId)
                                    set("rcOnline", status)
                                }
                            }
                        }
                    }
                }
            }
        } catch (e: Throwable) {
            e.printStackTrace()
        }
        return BaseResponse(code = com.alico.chat.app.response.ResponseCode.FAIL)
    }

    class OnlineStatus {
        var rcOnline: String = ""
        var fetchTime = 0L
    }
}