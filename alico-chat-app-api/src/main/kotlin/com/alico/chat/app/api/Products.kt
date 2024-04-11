package com.alico.chat.app.api

import cn.hutool.json.JSONArray
import cn.hutool.json.JSONObject
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper
import com.alico.chat.app.api.AliSts.Companion.addAliOssDomain
import com.alico.chat.app.common.JWTUtil
import com.alico.chat.app.response.BaseResponse
import com.alico.chat.app.response.ResponseCode
import com.alico.chat.app.sql.bean.GoldPackage
import com.alico.chat.app.sql.bean.UserWallet
import com.alico.chat.app.sql.bean.VipPackage
import com.alico.chat.app.sql.mapper.GoldPackageMapper
import com.alico.chat.app.sql.mapper.UserWalletMapper
import com.alico.chat.app.sql.mapper.VipPackageMapper
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RestController
import javax.servlet.http.HttpServletRequest

@RestController
class Products {
    @Autowired
    lateinit var vipPackageMapper: VipPackageMapper

    @Autowired
    lateinit var userWalletMapper: UserWalletMapper

    @Autowired
    lateinit var goldPackageMapper: GoldPackageMapper

    @GetMapping("/v2/member")
    fun member(request: HttpServletRequest): BaseResponse<JSONObject> {
        val agent = request.getHeader("X-Agent")
        val vipPackages = vipPackageMapper.selectList(
            QueryWrapper<VipPackage>()
                .eq("status", 0)
                .eq("device", if (agent == "android") "0" else "1")
        )
        return BaseResponse<JSONObject>().apply {
            data = JSONObject().apply {
                val securityUser = JWTUtil.getSecurityUser()
                securityUser?.let {
                    set("nickname", it.user.nickname)
                    set("vip", it.user.vip)
                    set("avatar", it.user.avatar.addAliOssDomain())
                    set("vipExpireTime", it.user.vipExpireTime)
                }

                set("vipPackage", JSONArray().apply {
                    vipPackages.forEach { add(JSONObject(it)) }
                })
            }
        }
    }

    @GetMapping("/v1/wallet")
    fun wallet(): BaseResponse<JSONObject> {
        JWTUtil.getSecurityUser()?.let {
            userWalletMapper.selectById(it.user.userId)?.let {
                return BaseResponse<JSONObject>().apply {
                    data = JSONObject(it)
                }
            }
            UserWallet(userId = it.user.userId).let {
                userWalletMapper.insert(it)
                return BaseResponse<JSONObject>().apply { data = JSONObject(it) }
            }
        }
        return BaseResponse<JSONObject>(code = com.alico.chat.app.response.ResponseCode.FAIL, message = "no found")
    }

    @GetMapping("/v1/goldPackage")
    fun goldPackage(request: HttpServletRequest): BaseResponse<JSONArray> {
        val agent = request.getHeader("X-Agent")
        val goldPackages = goldPackageMapper.selectList(
            QueryWrapper<GoldPackage>()
                .eq("status", 0)
                .eq("device", if (agent == "android") 0 else 1)
        )

        return BaseResponse<JSONArray>().apply {
            data = JSONArray().apply {
                goldPackages.forEach {
                    add(JSONObject(it))
                }
            }
        }
    }

}