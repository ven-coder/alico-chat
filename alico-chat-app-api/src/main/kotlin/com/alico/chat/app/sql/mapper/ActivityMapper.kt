package com.alico.chat.app.sql.mapper

import com.baomidou.mybatisplus.core.mapper.BaseMapper
import com.alico.chat.app.sql.bean.Activity
import org.springframework.stereotype.Component

@Component
interface ActivityMapper : BaseMapper<Activity> {
}