package com.alico.chat.app.api

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper
import com.alico.chat.app.common.JWTUtil
import com.alico.chat.app.response.BaseResponse
import com.alico.chat.app.response.ResponseCode
import com.alico.chat.app.sql.bean.Location
import com.alico.chat.app.sql.bean.UserInfo
import com.alico.chat.app.sql.mapper.LocationMapper
import com.alico.chat.app.sql.mapper.ProfessionMapper
import com.alico.chat.app.sql.mapper.UserInfoMapper
import com.alico.chat.app.sql.mapper.UserMapper
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.web.bind.annotation.PutMapping
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.RestController
import javax.servlet.http.HttpServletRequest

@RestController
@RequestMapping("/v2")
class UserEdit2 {
    @Autowired
    private lateinit var userMapper: UserMapper

    @Autowired
    private lateinit var userInfoMapper: UserInfoMapper

    @Autowired
    private lateinit var professionMapper: ProfessionMapper

    @Autowired
    private lateinit var locationMapper: LocationMapper

    @PutMapping("/profile")
    fun setProfile(
        @RequestParam(required = false, defaultValue = "") nickname: String,
        @RequestParam("city[]", required = false, defaultValue = "") city: List<String>,
        @RequestParam(required = false, defaultValue = "") birthday: String,
        @RequestParam(required = false, defaultValue = "") wechat: String,
        @RequestParam(required = false, defaultValue = "") qq: String,
        @RequestParam(required = false, defaultValue = "") height: String,
        @RequestParam(required = false, defaultValue = "") describe: String,
        @RequestParam(required = false, defaultValue = "0") profession: Int,
        @RequestParam(required = false, defaultValue = "0") hide_contact: String,
        @RequestParam(required = false, defaultValue = "") weight: String,
    ): BaseResponse<String> {
        if (nickname.isEmpty()) return BaseResponse(code = com.alico.chat.app.response.ResponseCode.FAIL)
        JWTUtil.getSecurityUser()?.let { user ->
            user.user.nickname = nickname
            userMapper.updateById(user.user)
            val professionInfo = professionMapper.selectById(profession)
            val locationQueryWrapper = QueryWrapper<Location>()
            city.forEach {
                locationQueryWrapper.eq("location_id", it).or()
            }

            val liveCity = StringBuilder()
            if (city.isNotEmpty()){
                locationMapper.selectList(locationQueryWrapper)?.forEach {
                    if (liveCity.isNotEmpty()) liveCity.append(",")
                    liveCity.append(it.locationName)
                }
            }
            userInfoMapper.selectOne(QueryWrapper<UserInfo>().eq("user_id", user.user.userId))?.let {
                it.liveCityId = city.joinToString(separator = ",")
                it.liveCity = liveCity.toString()
                it.birthday = birthday
                it.wechat = wechat
                it.qq = qq
                it.height = height
                it.describe = describe
                it.professionId = profession
                it.profession = professionInfo?.professionName ?: ""
                it.hideContact = hide_contact.toInt()
                it.weight = weight
                userInfoMapper.updateById(it)
            } ?: let {
                UserInfo().let {
                    it.userId = user.user.userId
                    it.liveCityId = city.joinToString(separator = ",")
                    it.birthday = birthday
                    it.wechat = wechat
                    it.qq = qq
                    it.height = height
                    it.describe = describe
                    it.professionId = profession
                    it.profession = professionInfo?.professionName ?: ""
                    it.hideContact = hide_contact.toInt()
                    it.weight = weight
                    userInfoMapper.insert(it)
                }
            }
            JWTUtil.getSecurityUser()?.user?.let {
                it.status = 0
                userMapper.updateById(it)
            }
        }
        return BaseResponse<String>(message = "update success")
    }

    @PutMapping("/avatar")
    fun setAvatar(
        request: HttpServletRequest,
        @RequestParam sex: String,
        @RequestParam avatar: String
    ): BaseResponse<String> {
        JWTUtil.getSecurityUser()?.let {
            it.user.avatar = avatar
            userMapper.updateById(it.user)
        }
        return BaseResponse<String>(message = "set avatar success")
    }

    @PutMapping("/gender")
    fun setGender(request: HttpServletRequest, @RequestParam sex: String): BaseResponse<String> {
        JWTUtil.getSecurityUser()?.let {
            it.user.sex = sex.toInt()
            userMapper.updateById(it.user)
        }
        return BaseResponse<String>(message = "set sex success")
    }
}