package net.lab1024.sa.admin.module.business.oa.notice;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.util.JSONPObject;
import net.lab1024.sa.base.common.code.ErrorCode;
import net.lab1024.sa.base.common.domain.ResponseDTO;
import okhttp3.*;
import org.json.JSONObject;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import java.io.IOException;
import java.util.Map;

import static net.lab1024.sa.base.common.code.SystemErrorCode.SYSTEM_ERROR;

@RestController
public class AdminBridge {

    @PostMapping("/admin/bridge")
    public ResponseDTO<Object> bridge(@RequestBody Map<String, Object> jsonObject) {
        try {
            OkHttpClient okHttpClient = new OkHttpClient.Builder().build();
            ObjectMapper objectMapper = new ObjectMapper();
            String json = objectMapper.writeValueAsString(jsonObject);
            Request request = new Request.Builder().url("http://localhost:8080/admin/bridge")
                    .post(okhttp3.RequestBody.create(json, MediaType.parse("application/json")))
                    .build();
            Response response = okHttpClient.newCall(request).execute();
            ResponseBody body = response.body();
            if (response.isSuccessful() && body != null) {
                json = body.string();
                JSONObject job = new JSONObject(json);
                Object data = job.opt("data");
                Map<String, Object> map = objectMapper.readValue(data.toString(), new TypeReference<Map<String, Object>>() {
                });
                return ResponseDTO.ok(map);
            }
        } catch (Throwable e) {
            e.printStackTrace();
        }
        return ResponseDTO.error(SYSTEM_ERROR);
    }

}
