package com.alico.chat.app.sql.bean

import com.baomidou.mybatisplus.annotation.IdType
import com.baomidou.mybatisplus.annotation.TableId
import com.baomidou.mybatisplus.annotation.TableName
import lombok.Data

@Data
@TableName(value = "oc_gold_package")
data class GoldPackage(
    @TableId(type = IdType.AUTO)
    var goldPackageId: Int = 0,
    var goldNum: Int = 0,
    var price: Double = 0.0,
    var originalPrice: Double = 0.0,
    var payCode: String = "",
    var weight: Int = 0,
    var status: Int = 0,
    var device: Int = 0,
) {

}