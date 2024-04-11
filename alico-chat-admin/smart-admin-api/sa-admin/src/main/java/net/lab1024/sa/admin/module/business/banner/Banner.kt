package net.lab1024.sa.admin.module.business.banner

import cn.hutool.json.JSONArray
import cn.hutool.json.JSONObject
import net.lab1024.sa.base.common.annoation.NoNeedLogin
import net.lab1024.sa.base.common.code.ErrorCode
import net.lab1024.sa.base.common.domain.ResponseDTO
import net.lab1024.smartdb.SmartDb
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RestController
import javax.annotation.Resource

@RestController
class Banner {
    @Resource(name = "default")
    private lateinit var smartDb: SmartDb

    @GetMapping("/getBanners")
    fun getBanners(): ResponseDTO<JSONArray> {
        val queryList = smartDb.master.selectSqlBuilder()
            .select("*")
            .from(CarouselDB::class.java)
            .whereAnd("status=0")
            .queryList(CarouselDB::class.java)

        return ResponseDTO.ok(JSONArray().apply {
            queryList.forEach {
                add(JSONObject(it))
            }
        })
    }

    @PostMapping("/setBanner")
    fun setBanner(@RequestBody jsonObject: JSONObject): ResponseDTO<String>? {
        val id = jsonObject.getInt("id", -2)
        if (id == -2) return ResponseDTO.userErrorParam()
        val picture = jsonObject.getStr("picture", "")
        val url = jsonObject.getStr("url", "")
        if (id == -1) {
            smartDb.master.insertSqlBuilder()
                .table(CarouselDB::class.java)
                .insertEntity(CarouselDB(picture = picture, url = url))
                .execute()
        } else {
            val carouselDB = smartDb.master.selectSqlBuilder()
                .select("*")
                .whereAnd("id=$id")
                .from(CarouselDB::class.java)
                .queryFirst(CarouselDB::class.java)
            smartDb.master.updateSqlBuilder().apply {
                this.table(CarouselDB::class.java)
                whereAnd("id=$id")
                updateColumn("picture = \'$picture\'")
                updateColumn("url = \"$url\"")
            }.execute()
        }

        return ResponseDTO.ok<String>()
    }

    @PostMapping("/deleteBanner")
    fun deleteBanner(@RequestBody jsonObject: JSONObject): ResponseDTO<String>? {
        val id = jsonObject.getInt("id", -2)
        if (id == -2) return ResponseDTO.userErrorParam()

        smartDb.deleteSqlBuilder()
            .table(CarouselDB::class.java)
            .whereAnd("id=$id")
            .execute()

        return ResponseDTO.ok<String>()
    }

}