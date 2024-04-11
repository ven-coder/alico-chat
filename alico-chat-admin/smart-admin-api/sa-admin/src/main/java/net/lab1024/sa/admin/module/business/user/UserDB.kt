package net.lab1024.sa.admin.module.business.user

import cn.hutool.core.annotation.PropIgnore
import com.baomidou.mybatisplus.annotation.IdType
import com.baomidou.mybatisplus.annotation.TableField
import com.baomidou.mybatisplus.annotation.TableId
import com.baomidou.mybatisplus.annotation.TableName
import com.fasterxml.jackson.annotation.JsonIgnore
import lombok.Data
import net.lab1024.smartdb.annotation.ColumnAlias
import net.lab1024.smartdb.annotation.TableAlias

@Data
@TableAlias("oc_user")
data class UserDB(
    @TableId(type = IdType.AUTO)
    var userId: Int = 0,
    var mobile: String = "",
    var email: String = "",
    var avatar: String = "",
    var nickname: String = "",
    var sex: Int = 0,
    var albumCount: Long = 0,
    var online: Long = 0,
    var lastOnline: Long = 0,
    var vip: Long = 0,
    var vipExpireTime: Long = 0,
    var listHide: Long = 0,
    @ColumnAlias(value = "`real`")
    var real: Int = 0,
    var isConsumers: Long = 0,
    var goddess: Long = 0,
    var status: Int = -1,
    var isRobot: Int = 0,
    var isShield: Int = 0,
    var createAt: Long = System.currentTimeMillis() / 1000,
    var updateAt: Long = 0,
    @TableField(exist = false)
    var ryKey: String = "",
    @TableField(exist = false)
    var ryToken: String = "",
    @TableField(exist = false)
    var ryUserId: String = "",
    @TableField(exist = false)
    var refreshToken: String = "",
    @TableField(exist = false)
    var token: String = "",
    @TableField(exist = false)
    var registerTime: String = "",
    @TableField(exist = false)
    var vipExpireTimeStr: String = "",
) {
    @JsonIgnore
    @PropIgnore
    var password: String = ""

    @JsonIgnore
    @PropIgnore
    var salt: String = ""
}