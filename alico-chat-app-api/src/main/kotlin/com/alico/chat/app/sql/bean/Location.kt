package com.alico.chat.app.sql.bean

import com.baomidou.mybatisplus.annotation.IdType
import com.baomidou.mybatisplus.annotation.TableId
import com.baomidou.mybatisplus.annotation.TableName
import lombok.Data

@Data
@TableName(value = "oc_location")
data class Location(
    @TableId(type = IdType.AUTO)
    var locationId: Int = 0,
    var parentId: Int = 0,
    var level: Int = 0,
    var cityCode: Int = 0,
    var status: Int = 0,
    var weight: Int = 0,
    var locationName: String = "",
) {

}