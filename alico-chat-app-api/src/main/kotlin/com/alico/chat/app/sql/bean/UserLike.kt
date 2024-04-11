package com.alico.chat.app.sql.bean

import com.baomidou.mybatisplus.annotation.IdType
import com.baomidou.mybatisplus.annotation.TableId
import com.baomidou.mybatisplus.annotation.TableName
import lombok.Data

@Data
@TableName(value = "oc_like_user")
data class UserLike(
    @TableId(type = IdType.AUTO)
    var id: Int = 0,
    var userId: Int = 0,
    var likeUserId: Int = 0,
) {

}