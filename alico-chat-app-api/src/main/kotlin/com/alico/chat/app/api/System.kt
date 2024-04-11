package com.alico.chat.app.api

import cn.hutool.json.JSONArray
import cn.hutool.json.JSONObject
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper
import com.alico.chat.app.common.JWTUtil
import com.alico.chat.app.response.BaseResponse
import com.alico.chat.app.sql.bean.SysMessageType
import com.alico.chat.app.sql.bean.SystemMessage
import com.alico.chat.app.sql.mapper.SysMessageMapper
import com.alico.chat.app.sql.mapper.SysMessageTypeMapper
import com.alico.chat.app.sql.mapper.UserMapper
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("v1")
class System {

    @Autowired
    lateinit var userMapper: UserMapper

    @Autowired
    lateinit var sysMessageMapper: SysMessageMapper

    @Autowired
    lateinit var sysMessageTypeMapper: SysMessageTypeMapper

    @GetMapping("/sysMessage")
    fun getSysMessage(): BaseResponse<JSONArray> {
        return BaseResponse<JSONArray>().apply {
            data = JSONArray().apply {
                val messageTypes = sysMessageTypeMapper.selectList(QueryWrapper<SysMessageType>())
                messageTypes.forEach {
                    add(JSONObject(it).apply {
                        val customUser = JWTUtil.getSecurityUser()
                        val selectList = sysMessageMapper.selectList(
                            QueryWrapper<SystemMessage>()
                                .eq("user_id", customUser?.user?.userId)
                                .eq("msg_type_id", it.msgTypeId)
                                .orderByDesc("updated_at")
                                .last("LIMIT 1")
                        )
                        set("lastMsg", selectList.firstOrNull()?.msgTitle?:"")
                        set("lastTime", selectList.firstOrNull()?.msgTime?:"")
                        set("hasUnread", selectList.firstOrNull()?.read?:"")
                        set("hasMsg", 0)
                    })
                }
            }
        }
    }
}