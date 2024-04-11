package net.lab1024.sa.admin.module.business.user

import cn.hutool.json.JSONArray
import cn.hutool.json.JSONObject
import net.lab1024.sa.admin.module.business.review.goddess.AlbumDB
import net.lab1024.sa.base.common.annoation.NoNeedLogin
import net.lab1024.sa.base.common.code.ErrorCode
import net.lab1024.sa.base.common.code.UserErrorCode
import net.lab1024.sa.base.common.constant.AliOss.addAliOssDomain
import net.lab1024.sa.base.common.domain.ResponseDTO
import net.lab1024.smartdb.SmartDb
import org.checkerframework.common.reflection.qual.GetConstructor
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.RestController
import java.time.Instant
import java.time.LocalDateTime
import java.time.ZoneId
import java.time.format.DateTimeFormatter
import javax.annotation.Resource

@RestController
class User {
    @Resource(name = "default")
    private lateinit var smartDb: SmartDb


    @PostMapping("/editUserInfo")
    fun postEditUserInfo(@RequestBody params: JSONObject): ResponseDTO<String>? {
        val userId = params.getInt("userId", -1)
        if (userId == -1) return ResponseDTO.userErrorParam<String>()
        val userDB = smartDb.master.selectSqlBuilder()
            .select("*")
            .from(UserDB::class.java)
            .whereAnd("user_id='$userId'")
            .queryFirst(UserDB::class.java) ?: return ResponseDTO.error(UserErrorCode.DATA_NOT_EXIST)
        val nickname = params.getStr("nickname", "")

        val vip = params.getInt("vip", -1)
        val vipExpire = params.getLong("vipExpire", -1)

        val real = params.getInt("real", -1)

        val goddess = params.getInt("goddess", -1)
        val avatar = params.getStr("avatar", "")

        smartDb.master.updateSqlBuilder()
            .table(UserDB::class.java)
            .whereAnd("user_id='$userId'").apply {
                if (nickname.isNotEmpty()) {
                    updateColumn("nickname='$nickname'")
                    execute()
                }

                if (vip != -1) {
                    updateColumn("vip=$vip")
                    updateColumn("vip_expire_time=$vipExpire")
                    execute()
                }

                if (real != -1) {
                    updateColumn("`real`=$real")
                    execute()
                }

                if (goddess != -1) {
                    updateColumn("goddess=$goddess")
                    execute()
                }

                if (avatar.isNotEmpty()) {
                    updateColumn("avatar='$avatar'")
                    execute()
                }

            }

        val describe = params.getStr("describe", "")
        smartDb.master.updateSqlBuilder()
            .table(UserInfoDB::class.java)
            .whereAnd("user_id='$userId'").apply {
                if (describe.isNotEmpty()) {
                    updateColumn("`describe`='$describe'")
                    execute()
                }
            }

        val gold = params.getInt("gold", -1)
        smartDb.master.updateSqlBuilder()
            .table(UserWalletDB::class.java)
            .whereAnd("user_id='$userId'").apply {
                if (gold != -1) {
                    updateColumn("gold='$gold'")
                    execute()
                }
            }

        return ResponseDTO.ok()
    }

    @GetMapping("/getUser/{userId}")
    fun getUser(@PathVariable userId: Int): ResponseDTO<JSONObject>? {
        val userDB = smartDb.master.selectSqlBuilder()
            .select("*")
            .from(UserDB::class.java)
            .whereAnd("user_id=$userId")
            .queryFirst(UserDB::class.java)
        val userInfoDB = smartDb.master.selectSqlBuilder()
            .select("*")
            .from(UserInfoDB::class.java)
            .whereAnd("user_id=$userId")
            .queryFirst(UserInfoDB::class.java)
        val realRecordDB = smartDb.master.selectSqlBuilder()
            .select("*")
            .from(RealRecordDB::class.java)
            .whereAnd("user_id=$userId")
            .queryFirst(RealRecordDB::class.java)
        val goddessAlbumList = smartDb.master.selectSqlBuilder().select("*")
            .from(AlbumDB::class.java)
            .whereAnd("user_id = $userId")
            .whereAnd("label = 2")
            .whereAnd("audit = 1")
            .queryList(AlbumDB::class.java)

        val albumList = smartDb.master.selectSqlBuilder().select("*")
            .from(AlbumDB::class.java)
            .whereAnd("user_id = $userId")
            .whereAnd("audit = 1")
            .queryList(AlbumDB::class.java)

        var userWalletDB = smartDb.master.selectSqlBuilder()
            .select("*")
            .from(UserWalletDB::class.java)
            .whereAnd("user_id=$userId")
            .queryFirst(UserWalletDB::class.java)

        if (userWalletDB == null) {
            userWalletDB = UserWalletDB(userId = userId)
            smartDb.master.insertSqlBuilder()
                .table(UserWalletDB::class.java)
                .insertEntity(userWalletDB)
                .execute()
        }

        return ResponseDTO.ok<JSONObject>(JSONObject(userDB).apply {
            set("avatar", userDB.avatar.addAliOssDomain())
            set("info", JSONObject(userInfoDB))
            set("realAuth", JSONObject(realRecordDB).apply {
                set("faceImg", realRecordDB?.faceImg?.addAliOssDomain())
                set("realImg", realRecordDB?.realImg?.addAliOssDomain())
            })
            set("goddessAlbumList", JSONArray().apply {
                goddessAlbumList.forEach {
                    add(JSONObject(it).apply {
                        set("image", it.image.addAliOssDomain())
                    })
                }
            })
            set("albumList", JSONArray().apply {
                albumList.forEach {
                    add(JSONObject(it).apply {
                        set("image", it.image.addAliOssDomain())
                    })
                }
            })
            set("wallet", JSONObject(userWalletDB))
        })
    }

    @GetMapping("/userList")
    fun getUserList(@RequestParam(required = false) page: Int?): ResponseDTO<UserList>? {
        val list: List<UserDB> = smartDb.master.selectSqlBuilder()
            .select("*")
            .from(UserDB::class.java)
            .orderby("create_at DESC")
            .queryList(UserDB::class.java)
        list.forEach {
            it.avatar = it.avatar.addAliOssDomain()
        }

        return ResponseDTO.ok(UserList().apply {
            this.list = list
        })
    }

    private fun getTime(createAt: Long): String {
        val zoneId = ZoneId.systemDefault()
        val dateTime = LocalDateTime.ofInstant(
            Instant.ofEpochSecond(createAt),
            zoneId
        )
        val formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")
        val formattedDateTime = dateTime.format(formatter)
        return formattedDateTime
    }
}