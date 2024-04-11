package net.lab1024.sa.admin.module.business.user

import cn.hutool.json.JSONArray
import com.baomidou.mybatisplus.annotation.IdType
import com.baomidou.mybatisplus.annotation.TableField
import com.baomidou.mybatisplus.annotation.TableId
import com.baomidou.mybatisplus.annotation.TableName
import lombok.Data
import net.lab1024.smartdb.annotation.TableAlias

@Data
@TableAlias(value = "oc_arc_soft_real_record")
data class RealRecordDB(
    @TableId(type = IdType.AUTO)
    var id: Int = 0,
    var userId: Int = 0,
    var faceImg: String = "",
    var realImg: String = "",
    var matchScore: Int = 0,
    var createdAt: Long = System.currentTimeMillis()/1000,
) {

}