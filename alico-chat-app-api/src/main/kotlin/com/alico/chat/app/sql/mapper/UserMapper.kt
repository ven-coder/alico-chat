package com.alico.chat.app.sql.mapper

import com.baomidou.mybatisplus.core.mapper.BaseMapper
import com.alico.chat.app.sql.bean.User
import org.springframework.stereotype.Component

@Component
public interface UserMapper : BaseMapper<User> {
}