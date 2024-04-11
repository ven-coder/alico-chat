package com.alico.chat.app.common

import cn.hutool.json.JSONObject
import okhttp3.FormBody
import okhttp3.Request
import java.security.MessageDigest

object RCHelper {
    lateinit var appKey: String
    lateinit var appSecret: String
    fun generateRandomString(length: Int): String {
        val allowedChars = ('A'..'Z') + ('a'..'z') + ('0'..'9')
        return (1..length)
            .map { allowedChars.random() }
            .joinToString("")
    }

    fun calculateSHA1(input: String): String {
        val bytes = input.toByteArray()
        val digest = MessageDigest.getInstance("SHA-1")
        val hashedBytes = digest.digest(bytes)
        return hashedBytes.joinToString("") { "%02x".format(it) }
    }

    fun getToken(userId: String): String? {
        val secret = appSecret
        val timestamp = System.currentTimeMillis().toString()
        val nonce = generateRandomString(18)
        val combinedString = secret + nonce + timestamp
        val signature = calculateSHA1(combinedString)
        val request = Request.Builder()
            .url("https://api.rong-api.com/user/getToken.json")
            .header("RC-App-Key", appKey)
            .header("RC-Nonce", nonce)
            .header("RC-Timestamp", timestamp)
            .header("RC-Signature", signature)
            .post(
                FormBody.Builder()
                    .add("userId", userId)
                    .add("name", userId)
                    .add("portraitUri", "")
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
                            val token = getStr("token")
                            return token
                        }
                    }
                }
            }
        } catch (e: Throwable) {
            e.printStackTrace()
        }
        return null
    }
}