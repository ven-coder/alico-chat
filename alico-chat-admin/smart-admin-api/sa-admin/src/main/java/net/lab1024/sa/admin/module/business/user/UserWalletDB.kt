package net.lab1024.sa.admin.module.business.user

import cn.hutool.json.JSONArray
import com.baomidou.mybatisplus.annotation.IdType
import com.baomidou.mybatisplus.annotation.TableField
import com.baomidou.mybatisplus.annotation.TableId
import com.baomidou.mybatisplus.annotation.TableName
import lombok.Data
import net.lab1024.smartdb.annotation.TableAlias

@Data
@TableAlias(value = "oc_user_wallet")
data class UserWalletDB(
    @TableId(type = IdType.AUTO)
    var userId: Int = 0,
    var money: Double = 0.0,
    var gold: Int = 0,
    var payPwd: String = "",
    var realname: String = "",
    var payAccount: String = "",
) {

}