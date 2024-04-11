<template>
  <context-holder/>
  <a-button type="primary" style="margin-bottom: 10px" @click="addBanner">添加</a-button>

  <a-table :columns="columns" :data-source="dataList">

    <template #bodyCell="{ column, record }">

      <template v-if="column.key === 'picture'">
        <a-image :src="record.picture" :height="100"/>
      </template>

      <template v-if="column.key === 'url'">
        <a>{{ record.url }}</a>
      </template>
      <template v-if="column.key === 'action'">
        <a-button type="primary" style="margin-left: 0px" @click="switchOpenDrawer(record)">编辑
        </a-button>
        <a-popconfirm title="确定删除？" @confirm="deleteBanner(record)">
          <template #icon>
            <question-circle-outlined style="color: red"/>
          </template>
          <a-button type="primary" danger style="margin-left: 10px" :loading="deleteLoading">删除</a-button>
        </a-popconfirm>
      </template>

    </template>

  </a-table>
  <a-drawer
      width="500"
      v-model:open="openDrawer"
      class="custom-class"
      root-class-name="root-class-name"
      :title="drawerTitle"
      placement="right"
      @after-open-change="afterOpenChange"
  >

    <a-col>
      <a-row style="margin-bottom: 10px">
        <span>图片：</span>
      </a-row>
      <a-row style="margin-bottom: 10px">
        <a-upload
            v-model:file-list="fileList"
            name="file"
            :custom-request="uploadFile"
            :headers="headers"
            @change="uploadHandleChange"
        >
          <a-button>
            <upload-outlined/>
            Click to Upload
          </a-button>
        </a-upload>
      </a-row>
      <a-row style="margin-bottom: 0px">
        <a-image :src="currentData.picture" :width="250"/>
      </a-row>
      <a-divider/>

    </a-col>

    <a-row style="margin-bottom: 10px">
      <span>跳转链接：</span>
    </a-row>
    <a-input :placeholder="currentData.url" v-model:value="currentData.url" style="margin-bottom: 30px"/>
    <a-popconfirm title="确定提交？" @confirm="submit">
      <a-button type="primary" :loading="loading">提交</a-button>
    </a-popconfirm>


  </a-drawer>

</template>

<script setup>
import {onMounted, ref} from "vue";
import {getRequest, postRequest} from "/@/lib/axios.js";
import {smartSentry} from "/@/lib/smart-sentry.js";
import OSS from "ali-oss";
import {message} from "ant-design-vue";

const [messageApi, contextHolder] = message.useMessage();
const dataList = ref([])
const openDrawer = ref(false)
const currentData = ref({picture: "", url: ""})
const loading = ref(false)
const deleteLoading = ref(false)
const drawerTitle = ref("")

function addBanner() {
  currentData.value = {picture: "", url: "", id: -1}
  drawerTitle.value = "添加轮播图"
  openDrawer.value = true
}

function switchOpenDrawer(data) {
  drawerTitle.value = "编辑轮播图"
  openDrawer.value = !openDrawer.value
  currentData.value = data
}

async function getList() {
  try {
    var response = await getRequest("/getBanners")
    dataList.value = response.data
  } catch (e) {
    smartSentry.captureError(e)
  }
}

async function uploadFile(event) {
  try {
    // object表示上传到OSS的文件名称。
    // file表示浏览器中需要上传的文件，支持HTML5 file和Blob类型。
    const result = await oss.put("admin/banner/" + event.file.name, event.file)
    fileList.value = []
    currentData.value.picture = result.url
  } catch (e) {
    console.error('error: %j', e);
  }
}

function uploadHandleChange(value) {
  console.log(value)
}

async function submit() {
  try {
    loading.value = true
    let response = await postRequest("/setBanner", {
      picture: currentData.value.picture,
      url: currentData.value.url,
      id: currentData.value.id
    })
    messageApi.info('提交成功')
    openDrawer.value = false
    if (currentData.value.id === -1) {
      dataList.value.unshift(currentData.value)
    }
  } catch (e) {
    smartSentry.captureError(e)
  } finally {
    loading.value = false
  }
}

async function deleteBanner(data) {
  try {
    deleteLoading.value = true
    let response = await postRequest("/deleteBanner", {id: data.id})
    messageApi.info("已删除")
    delete dataList.value[dataList.value.indexOf(data)]
  } catch (e) {
    smartSentry.captureError(e)
  } finally {
    deleteLoading.value = false
  }
}

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

onMounted(() => {
  initOSS()
  getList()
})
const columns = [
  {
    title: '图片',
    dataIndex: 'picture',
    key: 'picture',
  },
  {
    title: '跳转链接',
    dataIndex: 'url',
    key: 'url',
  }, {
    title: '操作',
    dataIndex: 'action',
    key: 'action',
  },
];

const fileList = ref([]);
</script>
