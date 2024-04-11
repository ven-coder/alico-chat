package com.alico.chat.app.sql.bean

import com.baomidou.mybatisplus.annotation.IdType
import com.baomidou.mybatisplus.annotation.TableId
import com.baomidou.mybatisplus.annotation.TableName
import lombok.Data

@Data
@TableName(value = "oc_activity_comment")
data class ActivityComment(
    @TableId(type = IdType.AUTO)
    var id: Int = 0,
    var userId: Int = 0,
    var toUserId: Int = 0,
    var activityId: Int = 0,
    var activityType: Int = 0,
    var commentType: Int = 0,
    var commentUserId: Int = 0,
    var comment: String = "",
    var createdAt: Long = System.currentTimeMillis() / 1000,
) {

}