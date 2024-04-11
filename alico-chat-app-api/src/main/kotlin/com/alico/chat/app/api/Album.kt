package com.alico.chat.app.api

import cn.hutool.json.JSONArray
import cn.hutool.json.JSONObject
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper
import com.alico.chat.app.api.AliSts.Companion.addAliOssDomain
import com.alico.chat.app.common.JWTUtil
import com.alico.chat.app.response.BaseResponse
import com.alico.chat.app.response.ResponseCode
import com.alico.chat.app.sql.bean.Album
import com.alico.chat.app.sql.mapper.AlbumMapper
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.web.bind.annotation.DeleteMapping
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PutMapping
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.RestController

@RestController
@RequestMapping("v1")
class Album {

    @Autowired
    lateinit var albumMapper: AlbumMapper

    @GetMapping("/getAlbums")
    fun getAlbums(): BaseResponse<JSONArray> {
        val customUser = JWTUtil.getSecurityUser()
        val albums = albumMapper.selectList(QueryWrapper<Album>().eq("user_id", customUser?.user?.userId))
        return BaseResponse<JSONArray>().apply {
            data = JSONArray().apply {
                albums.forEach {
                    it.image = it.image.addAliOssDomain()
                    add(JSONObject(it))
                }
            }
        }
    }

    @PutMapping("/albumFee")
    fun putAlbumFee(@RequestParam("picture_id") pictureId: Int): BaseResponse<JSONObject> {
        albumMapper.selectById(pictureId)?.let {
            it.isFee = 1
            albumMapper.updateById(it)
        }
        return BaseResponse<JSONObject>()
    }

    @PutMapping("/albumBurn")
    fun putAlbumBurn(@RequestParam burn: Int, @RequestParam("picture_id") pictureId: Int): BaseResponse<JSONObject> {
        albumMapper.selectById(pictureId)?.let {
            it.isBurn = burn
            albumMapper.updateById(it)
            return BaseResponse()
        }
        return BaseResponse<JSONObject>(code = com.alico.chat.app.response.ResponseCode.FAIL)
    }

    @DeleteMapping("/album")
    fun setAlbum(
        @RequestParam("picture_id") pictureId: Long,
    ): BaseResponse<JSONObject> {
        val securityUser = JWTUtil.getSecurityUser()
        albumMapper.deleteById(pictureId)
        return BaseResponse<JSONObject>()
    }
}