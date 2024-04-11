package com.alico.chat.app.security

import org.springframework.security.core.GrantedAuthority
import org.springframework.security.core.userdetails.User

class CustomUser(
    val user: com.alico.chat.app.sql.bean.User,
    username: String?,
    password: String?,
    authorities: MutableCollection<out GrantedAuthority>?
) :
    User(username, password, authorities) {

}