package com.alico.chat.app.sql.bean

import com.baomidou.mybatisplus.annotation.IdType
import com.baomidou.mybatisplus.annotation.TableField
import com.baomidou.mybatisplus.annotation.TableId
import com.baomidou.mybatisplus.annotation.TableName
import lombok.Data

@Data
@TableName(value = "oc_sys_message")
data class SystemMessage(
    @TableId(type = IdType.AUTO)
    var id: Int = 0,
    var msgType: String = "",
    var msgTypeId: Int = 0,
    var msgTitle: String = "",
    var userId: Int = 0,
    var rySendUserId: String = "",
    var toUserId: Int = 0,
    var ryRecvUserId: Int = 0,
    var msgTime: Int = 0,
    var body: String = "",
    @TableField(value = "`read`")
    var read: Int = 0,
) {

}