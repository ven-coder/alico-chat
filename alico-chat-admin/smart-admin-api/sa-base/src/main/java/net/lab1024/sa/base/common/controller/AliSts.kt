package net.lab1024.sa.base.common.controller

import cn.hutool.json.JSONObject
import com.aliyun.sts20150401.Client
import com.aliyun.sts20150401.models.AssumeRoleRequest
import com.aliyun.tea.TeaException
import com.aliyun.teaopenapi.models.Config
import com.aliyun.teautil.models.RuntimeOptions
import org.springframework.beans.factory.annotation.Value
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController


@RestController
class AliSts {

    @Value("\${file.storage.cloud.access-key}")
    lateinit var accessKeyId: String

    @Value("\${file.storage.cloud.secret-key}")
    lateinit var accessKeySecret: String

    @Value("\${file.storage.cloud.bucket-name}")
    lateinit var bucketName: String

    @Value("\${file.storage.cloud.sts-endpoint}")
    lateinit var stsEndpoint: String


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
                        "                \"oss:PutObject\",\n" +
                        "                \"oss:GetObject\"\n" +
                        "            ],\n" +
                        "            \"Resource\": [\n" +
                        "                \"acs:oss:*:*:$bucketName\",\n" +
                        "                \"acs:oss:*:*:$bucketName/*\"\n" +
                        "            ]\n" +
                        "        }\n" +
                        "    ]\n" +
                        "}"
            )
            .setRoleArn("acs:ram::1951907383108262:role/ramosstest")
            .setRoleSessionName("RamOssTest")
        val runtime = RuntimeOptions()
        try {
            // 复制代码运行请自行打印 API 的返回值
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
//        config.endpoint = "sts.cn-guangzhou.aliyuncs.com"
        config.endpoint = stsEndpoint
        return Client(config)
    }
}