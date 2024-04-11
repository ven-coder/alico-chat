package com.alico.chat.app.api

import cn.hutool.json.JSONArray
import cn.hutool.json.JSONObject
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper
import com.alico.chat.app.common.JWTUtil
import com.alico.chat.app.response.BaseResponse
import com.alico.chat.app.sql.bean.Location
import com.alico.chat.app.sql.bean.Profession
import com.alico.chat.app.sql.mapper.LocationMapper
import com.alico.chat.app.sql.mapper.ProfessionMapper
import com.alico.chat.app.sql.mapper.UserInfoMapper
import com.alico.chat.app.sql.mapper.UserMapper
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController
import javax.servlet.http.HttpServletRequest

@RestController
@RequestMapping("/v1")
class UserEdit {
    @Autowired
    private lateinit var userMapper: UserMapper

    @Autowired
    private lateinit var locationMapper: LocationMapper

    @Autowired
    private lateinit var professionMapper: ProfessionMapper

    @Autowired
    private lateinit var userInfoMapper: UserInfoMapper

    @GetMapping("/user/editUser")
    fun getEditUser(request: HttpServletRequest): BaseResponse<JSONObject> {
        val customUser = JWTUtil.getSecurityUser()
        val userInfo = userInfoMapper.selectById(customUser?.user?.userId)
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

        val professionOption = JSONArray()
        val professions = professionMapper.selectList(QueryWrapper<Profession>())
        val professions0 = professions.filter {
            if (it.parentId == 0) return@filter true
            return@filter false
        }

        professions0.forEach { profession0 ->
            professionOption.add(JSONObject(profession0).apply {
                professions.forEach { profession1 ->
                    if (profession1.parentId == profession0.professionId) {
                        getJSONArray("_child")?.add(JSONObject(profession1)) ?: let {
                            set("_child", JSONArray().apply {
                                add(JSONObject(profession1))
                            })
                        }
                    }
                }
            })
        }


        return BaseResponse<JSONObject>().apply {
            data = JSONObject(customUser?.user).apply {
                set("locationOption", locationOption)
                set("professionOption", professionOption)
                set("liveCity", JSONArray().apply {

                    userInfo?.let {
                        it.liveCity.split(",").forEach {
                            add(it)
                        }
                    }

                })
                set("birthday", userInfo?.birthday?:"")
                set("profession", userInfo?.profession?:"")
                set("professionId", userInfo?.professionId?:"")
                set("height", userInfo?.height?:"")
                set("weight", userInfo?.weight?:"")
                set("describe", userInfo?.describe?:"")
            }
        }
    }
}