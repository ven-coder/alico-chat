package com.alico.chat.app.sql.bean

import com.baomidou.mybatisplus.annotation.IdType
import com.baomidou.mybatisplus.annotation.TableId
import com.baomidou.mybatisplus.annotation.TableName
import lombok.Data

@Data
@TableName(value = "oc_user_relation")
data class UserRelation(
    @TableId(type = IdType.AUTO)
    var id: Int = 0,
    var userId: Int = 0,
    var targetUserId: Int = 0,
    var type: Int = 0,
    var channel: Int = 0,
    var expireTime: Long = 0,
    var createAt: Long = System.currentTimeMillis() / 1000,
) {

}