package com.alico.chat.app.common

import okhttp3.OkHttpClient

object OkhttpWrapper {
    private var httpClient: OkHttpClient? = null

    private fun create(): OkHttpClient {
        return OkHttpClient.Builder().build()
    }

    @Synchronized
    fun getClient(): OkHttpClient {
        com.alico.chat.app.common.OkhttpWrapper.httpClient?.let {
            return it
        } ?: let {
            val okHttpClient = com.alico.chat.app.common.OkhttpWrapper.create()
            com.alico.chat.app.common.OkhttpWrapper.httpClient = okHttpClient
            return okHttpClient
        }
    }

}