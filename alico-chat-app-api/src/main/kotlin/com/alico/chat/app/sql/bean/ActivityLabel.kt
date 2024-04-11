package com.alico.chat.app.sql.bean

import com.baomidou.mybatisplus.annotation.IdType
import com.baomidou.mybatisplus.annotation.TableId
import com.baomidou.mybatisplus.annotation.TableName
import lombok.Data

@Data
@TableName(value = "oc_activity_label")
data class ActivityLabel(
    @TableId(type = IdType.AUTO)
    var labelId: Int = 0,
    var labelCode: String = "",
    var labelName: String = "",
    var labelIcon: String = "",
    var labelWeight: Int = 0,
    var labelStatus: Int = 0,
) {

}