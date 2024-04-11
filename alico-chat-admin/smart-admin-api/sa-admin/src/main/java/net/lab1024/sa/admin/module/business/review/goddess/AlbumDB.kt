package net.lab1024.sa.admin.module.business.review.goddess

import com.baomidou.mybatisplus.annotation.IdType
import com.baomidou.mybatisplus.annotation.TableId
import lombok.Data
import net.lab1024.smartdb.annotation.TableAlias

@Data
@TableAlias(value = "oc_album")
data class AlbumDB(
    @TableId(type = IdType.AUTO)
    var pictureId: Int = 0,
    var userId: Int = 0,
    var image: String = "",
    var mediaType: Int = 0,
    var weight: Int = 0,
    var isBurn: Int = 0,
    var isFee: Int = 0,
    var label: Int = 0,
    var audit: Int = 0,
    var note: String = "",
    var matchSocre: Double = 0.0,
    var createAt: Long = System.currentTimeMillis() / 1000,
) {

}