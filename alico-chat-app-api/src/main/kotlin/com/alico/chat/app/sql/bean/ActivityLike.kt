package com.alico.chat.app.sql.bean

import com.baomidou.mybatisplus.annotation.IdType
import com.baomidou.mybatisplus.annotation.TableId
import com.baomidou.mybatisplus.annotation.TableName
import lombok.Data

@Data
@TableName(value = "oc_activity_like")
data class ActivityLike(
    @TableId(type = IdType.AUTO)
    var id: Int = 0,
    var activityId: Int = 0,
    var userId: Int = 0,
) {

}