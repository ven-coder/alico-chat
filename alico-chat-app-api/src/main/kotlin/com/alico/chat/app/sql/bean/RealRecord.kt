package com.alico.chat.app.sql.bean

import com.baomidou.mybatisplus.annotation.IdType
import com.baomidou.mybatisplus.annotation.TableId
import com.baomidou.mybatisplus.annotation.TableName
import lombok.Data

@Data
@TableName(value = "oc_arc_soft_real_record")
data class RealRecord(
    @TableId(type = IdType.AUTO)
    var id: Int = 0,
    var userId: Int = 0,
    var faceImg: String = "",
    var realImg: String = "",
    var matchScore: Int = 0,
    var createdAt: Long = System.currentTimeMillis()/1000,
) {

}