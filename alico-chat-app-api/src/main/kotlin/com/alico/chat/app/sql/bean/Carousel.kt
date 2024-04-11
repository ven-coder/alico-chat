package com.alico.chat.app.sql.bean

import com.baomidou.mybatisplus.annotation.IdType
import com.baomidou.mybatisplus.annotation.TableId
import com.baomidou.mybatisplus.annotation.TableName
import lombok.Data

@Data
@TableName(value = "oc_carousel")
data class Carousel(
    @TableId(type = IdType.AUTO)
    var id: Int = 0,
    var picture: String = "",
    var url: String = "",
    var weight: Int = 0,
    var status: Int = 0,
) {

}