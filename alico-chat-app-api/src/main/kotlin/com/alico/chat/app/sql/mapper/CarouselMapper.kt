package com.alico.chat.app.sql.mapper

import com.baomidou.mybatisplus.core.mapper.BaseMapper
import com.alico.chat.app.sql.bean.Carousel
import org.springframework.stereotype.Component

@Component
interface CarouselMapper : BaseMapper<Carousel> {
}