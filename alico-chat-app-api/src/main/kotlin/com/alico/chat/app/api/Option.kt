package com.alico.chat.app.api

import cn.hutool.json.JSONArray
import cn.hutool.json.JSONObject
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper
import com.alico.chat.app.response.BaseResponse
import com.alico.chat.app.sql.bean.*
import com.alico.chat.app.sql.mapper.*
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

@RestController
@RequestMapping("/v1")
class Option {

    @Autowired
    lateinit var desiredObject: DesiredObjectMapper

    @Autowired
    private lateinit var locationMapper: LocationMapper

    @GetMapping("/option/desiredObject")
    fun getOptionDesiredObject(): BaseResponse<JSONArray> {
        val desiredObjects = desiredObject.selectList(QueryWrapper())
        return BaseResponse<JSONArray>().apply {
            data = JSONArray().apply {
                desiredObjects.forEach { add(JSONObject(it)) }
            }
        }
    }

    @GetMapping("/option/location")
    fun getLocation(): BaseResponse<JSONArray> {
        val locations = locationMapper.selectList(QueryWrapper<Location>())

        val locationOption = JSONArray()
        val locations0 = locations.filter {
            if (it.level == 0) return@filter true
            return@filter false
        }

        locations0.forEach { location0 ->
            locationOption.add(JSONObject(location0).apply {
                locations.forEach { location1 ->
                    if (location1.parentId == location0.locationId) {
                        getJSONArray("_child")?.add(JSONObject(location1)) ?: let {
                            set("_child", JSONArray().apply {
                                add(JSONObject(location1))
                            })
                        }
                    }
                }
            })
        }
        return BaseResponse<JSONArray>().apply {
            data = locationOption
        }
    }


}