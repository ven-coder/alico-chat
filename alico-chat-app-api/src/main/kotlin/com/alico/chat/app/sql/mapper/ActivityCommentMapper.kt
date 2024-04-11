package com.alico.chat.app.sql.mapper

import com.baomidou.mybatisplus.core.mapper.BaseMapper
import com.alico.chat.app.sql.bean.ActivityComment
import org.springframework.stereotype.Component

@Component
interface ActivityCommentMapper : BaseMapper<com.alico.chat.app.sql.bean.ActivityComment> {
}