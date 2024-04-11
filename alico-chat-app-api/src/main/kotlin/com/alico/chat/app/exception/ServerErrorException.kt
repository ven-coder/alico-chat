package com.alico.chat.app.exception

import org.springframework.http.HttpStatus

/**
 * 服务器异常
 *
 * @author william@StarImmortal
 * @date 2021/09/21
 */
class ServerErrorException(code: Int?) : HttpException() {
    init {
        this.code = code!!
        httpStatusCode = HttpStatus.INTERNAL_SERVER_ERROR.value()
    }
}