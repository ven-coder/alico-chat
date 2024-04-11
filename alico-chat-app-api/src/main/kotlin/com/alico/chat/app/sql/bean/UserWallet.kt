package com.alico.chat.app.sql.bean

import com.baomidou.mybatisplus.annotation.IdType
import com.baomidou.mybatisplus.annotation.TableId
import com.baomidou.mybatisplus.annotation.TableName
import lombok.Data

@Data
@TableName(value = "oc_user_wallet")
data class UserWallet(
    @TableId(type = IdType.AUTO)
    var userId: Int = 0,
    var money: Double = 0.0,
    var gold: Int = 0,
    var payPwd: String = "",
    var realname: String = "",
    var payAccount: String = "",
) {

}