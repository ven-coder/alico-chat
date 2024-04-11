package com.alico.chat.app.sql.bean

import com.baomidou.mybatisplus.annotation.IdType
import com.baomidou.mybatisplus.annotation.TableId
import com.baomidou.mybatisplus.annotation.TableName
import lombok.Data

@Data
@TableName(value = "oc_activity_sign")
data class ActivitySign(
    @TableId(type = IdType.AUTO)
    var id: Int = 0,
    var userId: Int = 0,
    var activityId: Int = 0,
    var image: String = "",
    var createAt: Long = System.currentTimeMillis() / 1000,
) {

}