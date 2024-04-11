package com.alico.chat.app

import org.mybatis.spring.annotation.MapperScan
import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication

@SpringBootApplication
@MapperScan("com.alico.chat.app.sql.mapper")
class Application

fun main(args: Array<String>) {
    runApplication<Application>(*args)
}