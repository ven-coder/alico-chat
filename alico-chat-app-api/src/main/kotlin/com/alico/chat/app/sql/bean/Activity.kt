package com.alico.chat.app.sql.bean

import com.baomidou.mybatisplus.annotation.IdType
import com.baomidou.mybatisplus.annotation.TableId
import com.baomidou.mybatisplus.annotation.TableName
import lombok.Data

@Data
@TableName(value = "oc_activity")
data class Activity(
    @TableId(type = IdType.AUTO)
    var activityId: Int = 0,
    var activityClassifyId: Int = 0,
    var activityClassifyName: String = "",
    var userId: Int = 0,
    var labelId: Int = 0,
    var labelCode: String = "",
    var labelName: String = "",
    var objectClassifyId: String = "",
    var objectClassifyName: String = "",
    var locationId: Int = 0,
    var locationName: String = "",
    var positionCity: String = "",
    var activityTime: Long = 0,
    var dateRange: String = "",
    var content: String = "",
    var images: String = "",
    var imagesCount: Int = 0,
    var isComment: Int = 0,
    var isHidden: Int = 0,
    var allowSex: Int = 0,
    var sex: Int = 0,
    var isFinish: Int = 0,

    var finishTime: Int = 0,
    var likeCount: Int = 0,
    var applyCount: Int = 0,
    var activityType: Int = 0,
    var operatorId: Int = 0,
    var audit: Int = 0,
    var note: String = "",
    var status: Int = 0,
    var isDeleted: Int = 0,
    var weight: Int = 0,
    var recommendAt: Int = 0,
    var deleteAt: Int = 0,
    var createAt: Long = System.currentTimeMillis()/1000,
) {

}