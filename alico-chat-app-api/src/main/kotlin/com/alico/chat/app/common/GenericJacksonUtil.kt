package com.alico.chat.app.common

import com.alico.chat.app.exception.ServerErrorException
import com.fasterxml.jackson.core.JsonProcessingException
import com.fasterxml.jackson.core.type.TypeReference
import com.fasterxml.jackson.databind.ObjectMapper
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Component

/**
 * Jackson工具类
 *
 * @author william@StarImmortal
 * @date 2022/02/19
 */
@Component
class GenericJacksonUtil {
    @Autowired
    fun setObjectMapper(objectMapper: ObjectMapper?) {
        Companion.objectMapper = objectMapper
    }

    companion object {
        var objectMapper: ObjectMapper? = null
        fun <T> objectToJson(`object`: T): String {
            return try {
                assert(objectMapper != null)
                objectMapper!!.writeValueAsString(`object`)
            } catch (e: JsonProcessingException) {
                e.printStackTrace()
                throw ServerErrorException(9999)
            }
        }

        fun <T> jsonToObject(s: String?, valueType: Class<T>?): T? {
            return if (s == null) {
                null
            } else try {
                objectMapper!!.readValue(s, valueType)
            } catch (e: JsonProcessingException) {
                e.printStackTrace()
                throw ServerErrorException(9999)
            }
        }

        fun <T> jsonToObject(s: String?, typeReference: TypeReference<T>?): T? {
            return if (s == null) {
                null
            } else try {
                assert(objectMapper != null)
                objectMapper!!.readValue(s, typeReference)
            } catch (e: JsonProcessingException) {
                e.printStackTrace()
                throw ServerErrorException(9999)
            }
        }

        fun <T> jsonToList(s: String?): List<T>? {
            return if (s == null) {
                null
            } else try {
                assert(objectMapper != null)
                objectMapper!!.readValue(s, object : TypeReference<List<T>?>() {})
            } catch (e: JsonProcessingException) {
                e.printStackTrace()
                throw ServerErrorException(9999)
            }
        }
    }
}