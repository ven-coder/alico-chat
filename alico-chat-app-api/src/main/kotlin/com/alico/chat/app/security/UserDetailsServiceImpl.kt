package com.alico.chat.app.security

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper
import com.alico.chat.app.sql.bean.User
import com.alico.chat.app.sql.mapper.UserMapper
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.security.core.GrantedAuthority
import org.springframework.security.core.userdetails.UserDetails
import org.springframework.security.core.userdetails.UserDetailsService
import org.springframework.stereotype.Service

@Service
class UserDetailsServiceImpl : UserDetailsService {
    @Autowired
    private lateinit var userMapper: UserMapper

    override fun loadUserByUsername(userId: String?): UserDetails {
        val user = userMapper.selectOne(QueryWrapper<User>().eq("user_id", userId))
        return CustomUser(
            user,
            userId,
            user.password,
            arrayListOf<GrantedAuthority>().apply {
                add(GrantedAuthority { "user" })
            })
    }
}