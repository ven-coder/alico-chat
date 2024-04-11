package com.alico.chat.app.sql.bean

import com.baomidou.mybatisplus.annotation.IdType
import com.baomidou.mybatisplus.annotation.TableId
import com.baomidou.mybatisplus.annotation.TableName
import lombok.Data

@Data
@TableName(value = "oc_msg_type")
data class SysMessageType(
    @TableId(type = IdType.AUTO)
    var msgTypeId: Int = 0,
    var name: String = "",
    var icon: String = "",
) {

}