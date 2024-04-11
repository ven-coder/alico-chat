package com.alico.chat.app.api

import cn.hutool.json.JSONException
import cn.hutool.json.JSONObject
import com.aliyun.oss.ClientConfiguration
import com.aliyun.oss.OSSClient
import com.aliyun.oss.common.auth.DefaultCredentialProvider
import com.aliyun.oss.common.utils.BinaryUtil
import com.aliyun.oss.model.MatchMode
import com.aliyun.oss.model.PolicyConditions
import com.aliyun.sts20150401.Client
import com.aliyun.sts20150401.models.AssumeRoleRequest
import com.aliyun.tea.TeaException
import com.aliyun.teaopenapi.models.Config
import com.aliyun.teautil.models.RuntimeOptions
import com.alico.chat.app.response.BaseResponse
import org.springframework.beans.factory.annotation.Value
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController
import java.io.UnsupportedEncodingException
import java.lang.System
import java.util.*


@RestController
@RequestMapping("/v1")
class AliSts {
    companion object {

        var domain: String = ""
        fun String.addAliOssDomain(): String {
            if (startsWith("http")) return this
            return "$domain${if (startsWith("/")) "" else "/"}$this"
        }
    }

    @Value("\${spring.cloud.alicloud.access-key}")
    var accessKeyId: String = ""

    @Value("\${spring.cloud.alicloud.secret-key}")
    var accessKeySecret: String = ""

    @Value("\${spring.cloud.alicloud.oss.endpoint}")
    var endpoint: String = ""

    @Value("\${spring.cloud.alicloud.oss.bucket}")
    var bucket: String = ""

    @Value("\${spring.cloud.alicloud.oss.domain}")
    var domain: String = ""
        set(value) {
            Companion.domain = value
            field = value
        }

    @GetMapping("/getOssPolicy")
    @Throws(UnsupportedEncodingException::class, JSONException::class)
    fun getPolicy(): BaseResponse<JSONObject> {
        // callbackUrl为 上传回调服务器的URL，请将下面的IP和Port配置为您自己的真实信息。
        // String callbackUrl = "http://88.88.88.88:8888";
        val dir = "" // 用户上传文件时指定的前缀,如果是 / 则自动检测为文件夹。

        val jsonObject = JSONObject()

        val expireTime: Long = 5
        val expireEndTime = System.currentTimeMillis() + expireTime * 1000 * 60 //过期时间 分钟
        val expiration = Date(expireEndTime)
        // PostObject请求最大可支持的文件大小为5 GB，即CONTENT_LENGTH_RANGE为5*1024*1024*1024。
        val policyConds: PolicyConditions = PolicyConditions()
        policyConds.addConditionItem("bucket", bucket)
        policyConds.addConditionItem(PolicyConditions.COND_CONTENT_LENGTH_RANGE, 0, 1024 * 1024 * 50)
        policyConds.addConditionItem(MatchMode.StartWith, PolicyConditions.COND_KEY, dir)
        val ossClient = OSSClient(endpoint, DefaultCredentialProvider(accessKeyId, accessKeySecret), ClientConfiguration())
        val postPolicy: String = ossClient.generatePostPolicy(expiration, policyConds)
        val binaryData = postPolicy.toByteArray(charset("utf-8"))
        val encodedPolicy: String = BinaryUtil.toBase64String(binaryData)
        val postSignature: String = ossClient.calculatePostSignature(postPolicy)

        jsonObject.set("accessKeyId", accessKeyId)
        jsonObject.set("policy", encodedPolicy)
        jsonObject.set("signature", postSignature)
        jsonObject.set("dir", dir)
        jsonObject.set("host", domain)
        jsonObject.set("callback", "")
        jsonObject.set("expire", (expireEndTime / 1000).toString())
        return BaseResponse<JSONObject>().apply {
            data = jsonObject
        }
    }

    @GetMapping("/aliSts/signature")
    fun getAliStsSignature(): JSONObject {
        val client = createClient(accessKeyId, accessKeySecret)
        val assumeRoleRequest = AssumeRoleRequest()
            .setPolicy(
                "{\n" +
                        "    \"Version\": \"1\",\n" +
                        "    \"Statement\": [\n" +
                        "        {\n" +
                        "            \"Effect\": \"Allow\",\n" +
                        "            \"Action\": [\n" +
                        "                \"oss:PutObject\"\n" +
                        "            ],\n" +
                        "            \"Resource\": [\n" +
                        "                \"acs:oss:*:*:$bucket\",\n" +
                        "                \"acs:oss:*:*:$bucket/*\"\n" +
                        "            ]\n" +
                        "        }\n" +
                        "    ]\n" +
                        "}"
            )
            .setRoleArn("acs:ram::1951907383108262:role/ramosstest")
            .setRoleSessionName("RamOssTest")
        val runtime = RuntimeOptions()
        try {
            val response = client.assumeRoleWithOptions(assumeRoleRequest, runtime)
            java.lang.System.out.println(response.toString())
            return JSONObject().apply {
                set("StatusCode", response.statusCode)
                set("AccessKeyId", response.body.credentials.accessKeyId)
                set("AccessKeySecret", response.body.credentials.accessKeySecret)
                set("SecurityToken", response.body.credentials.securityToken)
                set("Expiration", response.body.credentials.expiration)
            }
        } catch (error: TeaException) {
            // 错误 message
            java.lang.System.out.println(error.message)
            // 诊断地址
            java.lang.System.out.println(error.getData()["Recommend"])
        } catch (_error: java.lang.Exception) {
            val error = TeaException(_error.message, _error)
            // 错误 message
            java.lang.System.out.println(error.message)
            // 诊断地址
            java.lang.System.out.println(error.getData()["Recommend"])
        }
        return JSONObject()
    }

    /**
     * 使用AK&SK初始化账号Client
     * @param accessKeyId
     * @param accessKeySecret
     * @return Client
     * @throws Exception
     */
    @Throws(Exception::class)
    fun createClient(accessKeyId: String?, accessKeySecret: String?): Client {
        val config = Config() // 必填，您的 AccessKey ID
            .setAccessKeyId(accessKeyId) // 必填，您的 AccessKey Secret
            .setAccessKeySecret(accessKeySecret)
        // Endpoint 请参考 https://api.aliyun.com/product/Sts
        config.endpoint = "sts.cn-guangzhou.aliyuncs.com"
        return Client(config)
    }
}