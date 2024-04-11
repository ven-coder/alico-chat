package com.alico.chat.app.sql.mapper

import com.baomidou.mybatisplus.core.mapper.BaseMapper
import com.alico.chat.app.sql.bean.Profession
import org.springframework.stereotype.Component

@Component
interface ProfessionMapper : BaseMapper<Profession> {
}