package com.alico.chat.app.sql.bean

import com.baomidou.mybatisplus.annotation.IdType
import com.baomidou.mybatisplus.annotation.TableField
import com.baomidou.mybatisplus.annotation.TableId
import com.baomidou.mybatisplus.annotation.TableName
import lombok.Data

@Data
@TableName(value = "oc_vip_package")
class VipPackage(
    @TableId(type = IdType.AUTO)
    var vipPackageId: Int = 0,
    var name: String = "",
    var discount: String = "",
    @TableField(value = "`describe`")
    var describe: String = "",
    var price: Double = 0.0,
    var day: Int = 0,
    var gold: Int = 0,
    var weight: Int = 0,
    var expireType: Int = 0,
    var recommend: Int = 0,
    var payCode: String = "",
    var device: Int = 0,
    var version: String = "",
    var status: Int = 0,
    var createAt: Long = 0L,
) {

}