package com.alico.chat.app.sql.bean

import com.baomidou.mybatisplus.annotation.IdType
import com.baomidou.mybatisplus.annotation.TableId
import com.baomidou.mybatisplus.annotation.TableName
import lombok.Data

@Data
@TableName(value = "oc_desired_object")
data class DesiredObject(
    @TableId(type = IdType.AUTO)
    var objectClassifyId: Int = 0,
    var objectClassifyName: String = "",
    var status: Int = 0,
    var weight: Int = 0,
) {

}