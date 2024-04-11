package com.alico.chat.app.sql.bean

import com.baomidou.mybatisplus.annotation.IdType
import com.baomidou.mybatisplus.annotation.TableId
import com.baomidou.mybatisplus.annotation.TableName
import lombok.Data

@Data
@TableName(value = "oc_profession")
data class Profession(
    @TableId(type = IdType.AUTO)
    var professionId: Int = 0,
    var professionName: String = "",
    var parentId: Int = 0,
    var weight: Int = 0,
    var status: Int = 0,
) {

}