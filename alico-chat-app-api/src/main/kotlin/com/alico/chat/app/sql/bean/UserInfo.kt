package com.alico.chat.app.sql.bean

import com.baomidou.mybatisplus.annotation.TableField
import com.baomidou.mybatisplus.annotation.TableId
import com.baomidou.mybatisplus.annotation.TableName
import lombok.Data

@Data
@TableName(value = "oc_user_info")
data class UserInfo(
    @TableId
    var userId: Int = 0,
    var birthday: String = "",
    var wechat: String = "",
    var qq: String = "",
    var height: String = "",
    var weight: String = "",
    @TableField(value = "`describe`")
    var describe: String = "",
    var professionId: Int = 0,
    var profession: String = "",
    var liveCity: String = "",
    var liveCityId: String = "",
    var actClasName: String = "",
    var actClasId: String = "",
    var pass: Int = 0,
    var objectName: String = "",
    var objectId: String = "",
    var hideContact: Int = 0,
    var activeContact: Int = 0,
    var inviteCode: String = "",
    var device: Int = 0,
    var label: Int = 0,
) {

}