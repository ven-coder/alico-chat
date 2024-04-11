package net.lab1024.sa.admin.module.business.review.goddess

import cn.hutool.json.JSONArray
import cn.hutool.json.JSONObject
import net.lab1024.sa.admin.module.business.user.UserDB
import net.lab1024.sa.base.common.annoation.NoNeedLogin
import net.lab1024.sa.base.common.constant.AliOss.addAliOssDomain
import net.lab1024.sa.base.common.domain.ResponseDTO
import net.lab1024.smartdb.SmartDb
import org.springframework.web.bind.annotation.GetMapping
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
class Goddess {

    @Resource(name = "default")
    private lateinit var smartDb: SmartDb

    @PostMapping("/optionGoddess")
    fun optionGoddess(@RequestBody jsonObject: JSONObject): ResponseDTO<String>? {
        smartDb.master.updateSqlBuilder()
            .table(AlbumDB::class.java)
            .updateColumn("audit = ${jsonObject.getInt("value")}")
            .whereAnd("picture_id = ${jsonObject.getInt("pictureId")}")
            .execute()

        val albumDB = smartDb.master.selectSqlBuilder().select("*")
            .from(AlbumDB::class.java)
            .whereAnd("picture_id = ${jsonObject.getInt("pictureId")}")
            .queryFirst(AlbumDB::class.java)
        albumDB?.let {
            smartDb.master.updateSqlBuilder().table(UserDB::class.java)
                .updateColumn("goddess = 1")
                .whereAnd("user_id = ${it.userId}")
                .execute()
        }
        return ResponseDTO.ok<String>()
    }

    //    @NoNeedLogin
    @GetMapping("/goddessList")
    fun getGoddessList(): ResponseDTO<JSONObject>? {

        val albumList = smartDb.master.selectSqlBuilder()
            .select("*")
            .from(AlbumDB::class.java)
            .whereAnd("audit = 0")
            .whereAnd("label = 2")
            .queryList(AlbumDB::class.java)
        val userids = albumList.distinctBy { it.userId }
        val userDBS = smartDb.master.selectSqlBuilder()
            .select("*")
            .from(UserDB::class.java).apply {
                userids.forEach {
                    whereOr("user_id = ${it.userId}")
                }
            }.queryList(UserDB::class.java)

        val realRecordDBS = smartDb.master.selectSqlBuilder()
            .select("*")
            .from(RealRecordDB::class.java).apply {
                userids.forEach {
                    whereOr("user_id = ${it.userId}")
                }
            }
            .queryList(RealRecordDB::class.java)

        return ResponseDTO.ok(JSONObject().apply {
            set("list", JSONArray().apply {
                albumList.forEach { album ->
                    add(JSONObject(album).apply {
                        userDBS.forEach { user ->
                            if (user.userId == album.userId) {
                                set("nickname", user.nickname)
                            }

                        }
                        realRecordDBS.forEach {
                            if (it.userId == album.userId) {
                                set("realImg", it.realImg.addAliOssDomain())
                            }
                        }
                        set("image", album.image.addAliOssDomain())
                        set("uploadTime", getTime(album.createAt))
                    })
                }
            })
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