package com.alico.chat.app.exception

import com.alico.chat.app.response.Code
import lombok.Getter
import org.springframework.http.HttpStatus

/**
 * Http异常
 *
 * @author william@StarImmortal
 * @date 2021/09/21
 */
@Getter
open class HttpException : RuntimeException {
    /**
     * 错误码
     */
    @JvmField
    protected var code: Int = Code.INTERNAL_SERVER_ERROR.code

    /**
     * HTTP状态码
     */
    @JvmField
    protected var httpStatusCode = HttpStatus.INTERNAL_SERVER_ERROR.value()

    /**
     * 是否默认消息
     */
    protected var defaultMessage = true

    constructor() : super(Code.INTERNAL_SERVER_ERROR.description)
    constructor(message: String?) : super(message) {
        defaultMessage = false
    }

    constructor(code: Int) : super(Code.INTERNAL_SERVER_ERROR.description) {
        this.code = code
    }

    constructor(code: Int, httpStatusCode: Int) : super(Code.INTERNAL_SERVER_ERROR.description) {
        this.code = code
        this.httpStatusCode = httpStatusCode
    }

    constructor(code: Int, message: String?) : super(message) {
        this.code = code
        defaultMessage = false
    }

    constructor(code: Int, message: String?, httpStatusCode: Int) : super(message) {
        this.code = code
        this.httpStatusCode = httpStatusCode
        defaultMessage = false
    }

    constructor(cause: Throwable?, code: Int) : super(cause) {
        this.code = code
    }

    constructor(cause: Throwable?, code: Int, httpStatusCode: Int) : super(cause) {
        this.code = code
        this.httpStatusCode = httpStatusCode
    }

    constructor(message: String?, cause: Throwable?) : super(message, cause) {
        defaultMessage = false
    }

    fun doFillInStackTrace(): Throwable {
        return super.fillInStackTrace()
    }
}