package com.alico.chat.app.sql.mapper

import com.baomidou.mybatisplus.core.mapper.BaseMapper
import com.alico.chat.app.sql.bean.ActivityLabel
import org.springframework.stereotype.Component

@Component
interface ActivityLabelMapper : BaseMapper<ActivityLabel> {
}