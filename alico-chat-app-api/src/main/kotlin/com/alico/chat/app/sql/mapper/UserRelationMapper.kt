package com.alico.chat.app.sql.mapper

import com.baomidou.mybatisplus.core.mapper.BaseMapper
import com.alico.chat.app.sql.bean.UserRelation
import org.springframework.stereotype.Component

@Component
interface UserRelationMapper : BaseMapper<UserRelation> {
}