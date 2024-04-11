package net.lab1024.sa.admin.module.business.user

import cn.hutool.json.JSONArray
import com.baomidou.mybatisplus.annotation.IdType
import com.baomidou.mybatisplus.annotation.TableField
import com.baomidou.mybatisplus.annotation.TableId
import com.baomidou.mybatisplus.annotation.TableName
import lombok.Data
import net.lab1024.smartdb.annotation.TableAlias

@Data
@TableAlias(value = "oc_user_info")
data class UserInfoDB(
    @TableId
    var userId: Int = 0,
    var birthday: String = "",
    var wechat: String = "",
    var qq: String = "",
    var height: String = "",
    var weight: String = "",
    @TableField(value = "`describe`")
    var describe: String = "",
    var professionId: Int = 0,
    var profession: String = "",
    var liveCity: String = "",
    var liveCityId: String = "",
    var actClasName: String = "",
    var actClasId: String = "",
    var pass: Int = 0,
    var objectName: String = "",
    var objectId: String = "",
    var hideContact: Int = 0,
    var activeContact: Int = 0,
    var inviteCode: String = "",
    var device: Int = 0,
    var label: Int = 0,
) {

}