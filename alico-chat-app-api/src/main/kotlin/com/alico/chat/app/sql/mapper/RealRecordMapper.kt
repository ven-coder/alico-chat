package com.alico.chat.app.sql.mapper

import com.baomidou.mybatisplus.core.mapper.BaseMapper
import com.alico.chat.app.sql.bean.RealRecord
import org.springframework.stereotype.Component

@Component
interface RealRecordMapper : BaseMapper<RealRecord> {
}