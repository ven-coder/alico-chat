<script setup>

import {onBeforeMount, onBeforeUpdate, onMounted, ref} from "vue";
import {onBeforeRouteUpdate, useRoute} from 'vue-router';
import {smartSentry} from "/@/lib/smart-sentry.js";
import {getRequest, postRequest} from "/@/lib/axios.js";
import {IMAGE_PLACEHOLDER} from "/@/constants/business/image-const.js";
import {message} from "ant-design-vue";
import OSS from "ali-oss";


const [messageApi, contextHolder] = message.useMessage();
const showEditModal = ref(false)
const editValue = ref()
const editTitle = ref()
const editLoading = ref(false)

const editVipValue = ref(false)
const vipExpire = ref()

const editReal = ref(false)

const editGoddess = ref(false)

const editDescribe = ref("")

const editAvatar = ref("")
const avatarList = ref([]);

const editGold = ref("")

let editVipExpire = 0
let editType = 0

const EDIT_TYPE_NICKNAME = 1
const EDIT_TYPE_VIP = 2
const EDIT_TYPE_REAL = 3
const EDIT_TYPE_GODDESS = 4
const EDIT_TYPE_DESCRIBE = 5
const EDIT_TYPE_AVATAR = 6
const EDIT_TYPE_GOLD = 7

const route = useRoute();
const data = ref({
  avatar: "",
  info: {},
  realAuth: {},
  goddessAlbumList: [],
  albumList: [],
  wallet: {}
})


onMounted(() => {
  initOSS()
  getUser()
})

let oss;

async function initOSS() {
  const info = await getRequest('/aliSts/signature');
  oss = new OSS({
    // yourRegion填写Bucket所在地域。以华东1（杭州）为例，Region填写为oss-cn-hangzhou。
    region: 'oss-cn-guangzhou',
    // 从STS服务获取的临时访问密钥（AccessKey ID和AccessKey Secret）。
    accessKeyId: info.AccessKeyId,
    accessKeySecret: info.AccessKeySecret,
    // 从STS服务获取的安全令牌（SecurityToken）。
    stsToken: info.SecurityToken,
    refreshSTSToken: async () => {
      // 向您搭建的STS服务获取临时访问凭证。
      const info = await getRequest('/aliSts/signature');
      return {
        accessKeyId: info.AccessKeyId,
        accessKeySecret: info.AccessKeySecret,
        stsToken: info.SecurityToken
      }
    },
    // 刷新临时访问凭证的时间间隔，单位为毫秒。
    refreshSTSTokenInterval: 300000,
    // 填写Bucket名称。
    bucket: 'matchmagic',
    secure: true,
  });
}

async function uploadFile(event) {
  try {
    // object表示上传到OSS的文件名称。
    // file表示浏览器中需要上传的文件，支持HTML5 file和Blob类型。
    const result = await oss.put("admin/banner/" + event.file.name, event.file)
    avatarList.value = []
    editAvatar.value = result.url
  } catch (e) {
    smartSentry.captureError(e)
  }
}

const changeVipTime = (value, dateString) => {
  let millisecond = value.valueOf() / 1000;
  editVipExpire = millisecond
}

function timestampToDateTime(timestamp) {
  // 创建一个Date对象并将时间戳乘以1000以转换为毫秒
  var date = new Date(timestamp * 1000);

  // 获取年、月、日、小时、分钟和秒
  var year = date.getFullYear();
  var month = ('0' + (date.getMonth() + 1)).slice(-2);
  var day = ('0' + date.getDate()).slice(-2);
  var hours = ('0' + date.getHours()).slice(-2);
  var minutes = ('0' + date.getMinutes()).slice(-2);
  var seconds = ('0' + date.getSeconds()).slice(-2);

  // 构建日期时间字符串
  var dateTimeString = year + '-' + month + '-' + day + ' ' + hours + ':' + minutes + ':' + seconds;

  return dateTimeString;
}

async function getUser() {
  try {
    let userId = route.query.userId
    let response = await getRequest("/getUser/" + userId)
    let responseData = response.data
    if (response.data.sex === 1) {
      response.data.sex = "男"
    } else if (response.data.sex === 2) {
      response.data.sex = "女"
    } else {
      response.data.sex = "-"
    }
    if (responseData.vip === 1) {
      responseData.vip = "是"
    } else {
      responseData.vip = "否"
    }

    responseData.createAt = timestampToDateTime(responseData.createAt)

    if (responseData.real === 1) {
      responseData.real = "是"
    } else {
      responseData.real = "否"
    }

    if (responseData.goddess === 1) {
      responseData.goddess = "是"
    } else {
      responseData.goddess = "否"
    }

    if (responseData.vipExpireTime > 0) {
      responseData.vipExpireTime = timestampToDateTime(responseData.vipExpireTime)
    } else {
      responseData.vipExpireTime = '-'
    }

    data.value = responseData

  } catch (e) {
    smartSentry.captureError(e)
  }
}

function switchShowEditModal(type, value) {

  switch (type) {
    case EDIT_TYPE_NICKNAME:
      editTitle.value = "修改昵称"
      break
    case EDIT_TYPE_VIP:
      editTitle.value = "修改VIP"
      editVipValue.value = value === "是";
      break

    case EDIT_TYPE_REAL:
      editTitle.value = "修改真人"
      editReal.value = value === "是";
      break
    case EDIT_TYPE_GODDESS:
      editTitle.value = "修改女神"
      editGoddess.value = value === "是";
      break
    case EDIT_TYPE_DESCRIBE:
      editTitle.value = "修改简介"
      editDescribe.value = data.value.info.describe;
      break
    case EDIT_TYPE_AVATAR:
      editTitle.value = "修改头像"
      editAvatar.value = data.value.avatar;
      break
    case EDIT_TYPE_GOLD:
      editTitle.value = "修改金币"
      editGold.value = value;
      break
  }
  editType = type
  editValue.value = value
  showEditModal.value = !showEditModal.value
}

async function submitEdit() {
  try {
    editLoading.value = true
    let editParams = {}
    switch (editType) {
      case EDIT_TYPE_NICKNAME:
        editParams = {nickname: editValue.value, userId: data.value.userId}
        break
      case EDIT_TYPE_VIP:
        if (editVipExpire === 0 && editVipValue.value) {
          messageApi.info("请选择VIP到期时间")
          return
        }
        editParams = {vip: editVipValue.value ? 1 : 0, vipExpire: editVipExpire, userId: data.value.userId}
        break
      case EDIT_TYPE_REAL:
        editParams = {userId: data.value.userId, real: editReal.value ? 1 : 0}
        break
      case EDIT_TYPE_GODDESS:
        editParams = {userId: data.value.userId, goddess: editGoddess.value ? 1 : 0}
        break
      case EDIT_TYPE_DESCRIBE:
        editParams = {userId: data.value.userId, describe: editDescribe.value}
        break
      case EDIT_TYPE_AVATAR:
        editParams = {userId: data.value.userId, avatar: editAvatar.value}
        break
      case EDIT_TYPE_GOLD:
        editParams = {userId: data.value.userId, gold: editGold.value}
        break
    }
    let response = await postRequest("/editUserInfo", editParams)
    editVipExpire = 0
    messageApi.info("修改成功")
    showEditModal.value = false
    await getUser()
  } catch (e) {
    smartSentry.captureError(e)
  } finally {
    editLoading.value = false
  }
}

</script>

<template>
  <context-holder/>
  <div>
    <a-row>

      <a-col :span="12">
        <a-card style="height: 800px">
          <span>头像</span>
          <a-button type="text" danger @click="switchShowEditModal(EDIT_TYPE_AVATAR,data.avatar)">修改</a-button>
          <br/>
          <div v-if="data.avatar.startsWith('http')">
            <a-image
                :src="data.avatar"
                :height="120"/>
          </div>

          <a-row>
            <a-col :span="12">
              <div style="height: 50px;align-items: center;display:flex;">昵称：{{ data.nickname }}
                <a-button type="text" danger @click="switchShowEditModal(EDIT_TYPE_NICKNAME,data.nickname)">修改
                </a-button>
              </div>

            </a-col>
            <a-col :span="12">
              <div style="height: 50px;align-items: center;display:flex;">ID：{{ data.userId }}</div>
            </a-col>

          </a-row>
          <a-row>
            <a-col :span="12">
              <div style="height: 50px;align-items: center;display:flex;">性别：{{ data.sex }}</div>
            </a-col>
            <a-col :span="12">
              <div style="height: 50px;align-items: center;display:flex;">邮箱：{{ data.email }}</div>
            </a-col>

          </a-row>
          <a-row>
            <a-col :span="12">
              <div style="height: 50px;align-items: center;display:flex;">会员：{{ data.vip }}
                <a-button type="text" danger @click="switchShowEditModal(EDIT_TYPE_VIP,data.vip)">修改</a-button>
              </div>
            </a-col>
            <a-col :span="12">
              <div style="height: 50px;align-items: center;display:flex;">会员到期时间：{{ data.vipExpireTime }}</div>
            </a-col>


          </a-row>
          <a-row>
            <a-col :span="12">
              <div style="height: 50px;align-items: center;display:flex;">真人认证：{{ data.real }}
                <a-button type="text" danger @click="switchShowEditModal(EDIT_TYPE_REAL,data.real)">修改</a-button>
              </div>
            </a-col>
            <a-col :span="12">
              <div style="height: 50px;align-items: center;display:flex;">女神认证：{{ data.goddess }}
                <a-button type="text" danger @click="switchShowEditModal(EDIT_TYPE_GODDESS,data.goddess)">修改
                </a-button>
              </div>
            </a-col>

          </a-row>
          <a-row>
            <a-col :span="12">
              <div style="height: 50px;align-items: center;display:flex;">生日：{{ data.info.birthday }}</div>
            </a-col>

            <a-col :span="12">
              <div style="height: 50px;align-items: center;display:flex;">职业：{{ data.info.profession }}</div>
            </a-col>

          </a-row>
          <a-row>
            <a-col :span="12">
              <div style="height: 50px;align-items: center;display:flex;">身高：{{ data.info.height }}</div>
            </a-col>
            <a-col :span="12">
              <div style="height: 50px;align-items: center;display:flex;">体重：{{ data.info.weight }}</div>
            </a-col>

          </a-row>
          <a-row>
            <a-col :span="12">
              <div style="height: 50px;align-items: center;display:flex;">金币：{{ data.wallet.gold }}
                <a-button type="text" danger @click="switchShowEditModal(EDIT_TYPE_GOLD,data.wallet.gold)">修改
                </a-button>
              </div>

            </a-col>
            <a-col :span="12">
              <div style="height: 50px;align-items: center;display:flex;">注册时间：{{ data.createAt }}</div>
            </a-col>
          </a-row>
          <a-row>
            <a-col :span="24">
              <div style="white-space: normal;">
                个人简介：
                <a-button type="text" danger @click="switchShowEditModal(EDIT_TYPE_DESCRIBE,data.info.describe)">修改
                </a-button>
                <p style="word-break: break-all;word-wrap: break-word;">
                  {{ data.info.describe }}

                </p>

              </div>
            </a-col>
          </a-row>


        </a-card>
      </a-col>

      <a-col :span="12">
        <a-card style="height: 800px">

          <a-row>
            <a-col :span="12">
              真人上传照片：
              <br/>
              <a-image
                  :src="data.realAuth.faceImg"
                  :height="120"
                  :placeholder="true"
                  :style="{visibility: data.realAuth.faceImg?'visible':'hidden',width:data.realAuth.faceImg?'auto':0}"/>
            </a-col>
            <a-col :span="12">
              真人拍照照片：
              <br/>
              <a-image
                  :src="data.realAuth.realImg"
                  :height="120"
                  :style="{visibility: data.realAuth.realImg?'visible':'hidden',width:data.realAuth.realImg?'auto':0}"/>
            </a-col>

          </a-row>
          <a-row>
            <a-col :span="24">
              女神照片：
              <br/>
              <a-list :grid="{ column: 5, columns:1}" :data-source="data.goddessAlbumList">
                <template #renderItem="{ item }">
                  <div style="background-color: rgba(255,255,255,0)">
                    <div class="container">
                      <a-image :src="item.image" class="img-container"/>
                    </div>
                  </div>
                </template>
              </a-list>
              <a-button v-if="data.goddessAlbumList.length>5">更多</a-button>
            </a-col>
          </a-row>
          <a-row>
            <a-col :span="24">
              相册：
              <br/>
              <a-list :grid="{ column: 5, columns:1,}" :data-source="data.albumList">
                <template #renderItem="{ item }">
                  <div class="container">
                    <a-image :src="item.image" class="img-container"/>
                  </div>
                </template>
              </a-list>
              <a-button v-if="data.albumList.length>5">更多</a-button>
            </a-col>
          </a-row>

        </a-card>
      </a-col>
    </a-row>

    <a-modal v-model:open="showEditModal" :title="editTitle" @ok="submitEdit" :confirmLoading="editLoading">
      <div v-if="editType===EDIT_TYPE_NICKNAME">
        <a-input v-model:value="editValue"/>
      </div>
      <div v-else-if="editType===EDIT_TYPE_VIP">
        VIP：
        <a-radio-group v-model:value="editVipValue">
          <a-radio :value="true">是</a-radio>
          <a-radio :value="false">否</a-radio>
        </a-radio-group>
        <div :style="{visibility:editVipValue?'visible':'hidden'}">
          到期时间：
          <a-date-picker v-model:value="vipExpire" :showTime="true" @change="changeVipTime"/>
        </div>

      </div>

      <div v-else-if="editType===EDIT_TYPE_REAL">
        真人：
        <a-radio-group v-model:value="editReal">
          <a-radio :value="true">是</a-radio>
          <a-radio :value="false">否</a-radio>
        </a-radio-group>
      </div>

      <div v-else-if="editType===EDIT_TYPE_GODDESS">
        女生：
        <a-radio-group v-model:value="editGoddess">
          <a-radio :value="true">是</a-radio>
          <a-radio :value="false">否</a-radio>
        </a-radio-group>
      </div>
      <div v-else-if="editType===EDIT_TYPE_DESCRIBE">
        <a-textarea v-model:value="editDescribe" style="resize: none;height: 150px" :row="3"
                    :maxlength="250"/>
      </div>
      <div v-else-if="editType===EDIT_TYPE_AVATAR">
        <a-image :src="editAvatar" :height="120"/>
        <br/>
        <a-upload
            v-model:file-list="avatarList"
            name="file"
            :custom-request="uploadFile"
        >
          <a-button>
            <upload-outlined/>
            Click to Upload
          </a-button>
        </a-upload>
      </div>
      <div v-else-if="editType===EDIT_TYPE_GOLD">
        <a-input-number v-model:value="editGold"/>
      </div>
    </a-modal>
  </div>

</template>

<style scoped lang="less">
.container {
  overflow: hidden; /* 隐藏超出容器的部分 */
  position: relative; /* 设置相对定位，用于绝对定位子元素 */
  margin-right: 5px;
  height: 120px;
}

.img-container {
  position: absolute; /* 绝对定位，以容器为相对基准 */
  top: 50%; /* 向下偏移50% */
  left: 50%; /* 向右偏移50% */
  transform: translate(-50%, -50%); /* 将图片向左上方偏移自身宽度和高度的一半，使其居中 */
  max-width: none; /* 清除图片默认的最大宽度 */
  max-height: none; /* 清除图片默认的最大高度 */
  width: auto; /* 使图片宽度自适应容器 */
  height: auto; /* 使图片高度自适应容器 */
}
</style>