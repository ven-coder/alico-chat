package com.alico.chat.app.api

import cn.hutool.json.JSONObject
import com.alico.chat.app.common.JWTUtil
import com.alico.chat.app.response.BaseResponse
import com.alico.chat.app.sql.bean.Album
import com.alico.chat.app.sql.mapper.AlbumMapper
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.RestController

@RestController
@RequestMapping("v2")
class Album2 {

    @Autowired
    lateinit var albumMapper: AlbumMapper

    @PostMapping("/goddessApprove")
    fun postGoddessApprove(@RequestParam("goddess_img") goddessImg: String): BaseResponse<JSONObject> {
        val securityUser = JWTUtil.getSecurityUser()
        albumMapper.insert(
            Album(
                userId = securityUser?.user?.userId ?: 0,
                image = goddessImg,
                mediaType = 0,
                weight = 0,
                isBurn = 0,
                matchSocre = 0.0,
                isFee = 0,
                label = 2,
                audit = 0,
            )
        )
        return BaseResponse<JSONObject>(message = "upload success")
    }

    @PostMapping("/album/video")
    fun postAlbumVideo(
        @RequestParam("attachment[]") attachment: String,
        @RequestParam("match_score[]") matchScore: Double,
        @RequestParam("burn[]") burn: Int,
    ): BaseResponse<JSONObject> {
        val securityUser = JWTUtil.getSecurityUser()
        albumMapper.insert(
            Album(
                userId = securityUser?.user?.userId ?: 0,
                image = attachment,
                mediaType = 1,
                weight = 0,
                isBurn = burn,
                matchSocre = matchScore,
                isFee = 0,
                label = 0,
                audit = 1,
            )
        )

        return BaseResponse<JSONObject>()
    }

    @PostMapping("/album")
    fun setAlbum(
        @RequestParam("attachment[]") attachment: List<String>,
        @RequestParam("match_score[]") matchScore: List<Double>,
        @RequestParam("burn[]") burn: List<Int>,
    ): BaseResponse<JSONObject> {
        val securityUser = JWTUtil.getSecurityUser()
        attachment.forEachIndexed { index, s ->
            val ms = matchScore[index]
            val br = burn[index]
            albumMapper.insert(
                Album(
                    userId = securityUser?.user?.userId ?: 0,
                    image = s,
                    mediaType = 0,
                    weight = 0,
                    isBurn = br,
                    matchSocre = ms,
                    isFee = 0,
                    label = 0,
                    audit = 1,
                )
            )
        }

        return BaseResponse<JSONObject>()
    }
}