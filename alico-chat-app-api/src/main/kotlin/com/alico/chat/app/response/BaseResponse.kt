package com.alico.chat.app.response

class BaseResponse<T>(
    var code: Int = com.alico.chat.app.response.ResponseCode.SUCCESS,
    var message: String = ""
) {
    var data: T? = null
}