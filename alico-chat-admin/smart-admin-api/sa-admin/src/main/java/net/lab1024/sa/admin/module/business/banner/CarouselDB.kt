package net.lab1024.sa.admin.module.business.banner

import com.baomidou.mybatisplus.annotation.IdType
import com.baomidou.mybatisplus.annotation.TableId
import lombok.Data
import net.lab1024.smartdb.annotation.TableAlias

@Data
@TableAlias(value = "oc_carousel")
data class CarouselDB(
    @TableId(type = IdType.AUTO)
    var id: Int = 0,
    var picture: String = "",
    var url: String = "",
    var weight: Int = 0,
    var status: Int = 0,
) {

}