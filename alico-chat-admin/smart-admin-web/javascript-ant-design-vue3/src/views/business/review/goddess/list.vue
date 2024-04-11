<template>
  <context-holder/>
  <a-spin :spinning="loading">
    <a-table :columns="columns" :data-source="listData">

      <template #bodyCell="{ column, record }">
        <template v-if="column.key === 'realImage'">
          <a-image :src="record.realImg" :height="80"/>
        </template>
        <template v-if="column.key === 'goddessImage'">
          <a-image :src="record.image" :height="80"/>
        </template>
        <template v-if="column.key==='action'">

          <a-popconfirm
              title="是否确定通过对方女神认证申请？"
              ok-text="确定"
              @confirm="optionGoddess(record.pictureId,1)">
            <a-button type="primary">通过

            </a-button>
          </a-popconfirm>

          <a-popconfirm title="是否拒绝对方的女神认证申请？" @confirm="optionGoddess(record.pictureId,2)">
            <template #icon>
              <question-circle-outlined style="color: red"/>
            </template>
            <a-button type="primary" danger style="margin-left: 10px">拒绝</a-button>

          </a-popconfirm>
        </template>
      </template>
    </a-table>
  </a-spin>
</template>


<script setup>
import {getRequest, postRequest} from "/@/lib/axios.js";
import {smartSentry} from "/@/lib/smart-sentry.js";
import {onMounted, ref} from "vue";
import {QuestionCircleOutlined} from '@ant-design/icons-vue';
import {message} from 'ant-design-vue';

const [messageApi, contextHolder] = message.useMessage();

const columns = [
  {
    title: 'ID',
    dataIndex: 'userId',
    key: 'userId',
  },
  {
    title: '昵称',
    dataIndex: 'nickname',
    key: 'nickname',
  },
  {
    title: '真人照片',
    dataIndex: 'realImage',
    key: 'realImage',
  },
  {
    title: '女神照片',
    dataIndex: 'goddessImage',
    key: 'goddessImage',
  },
  {
    title: '上传时间',
    dataIndex: 'uploadTime',
    key: 'uploadTime',
  },
  {
    title: '操作',
    dataIndex: 'action',
    key: 'action',
  },
];

const listData = ref([])
const loading = ref(false)

onMounted(() => {
  queryList();
});
const tip = (message) => {
  messageApi.info(message);
};

async function optionGoddess(id, value) {
  try {
    loading.value = true
    let response = await postRequest("/optionGoddess", {"pictureId": id, "value": value});
    listData.value.forEach(function (item, index) {
      if (item.pictureId === id) {
        listData.value.splice(index, 1)
      }
    })
    tip(value === 1 ? '操作成功' : '已拒绝')
  } catch (e) {
    smartSentry.captureError(e);
  } finally {
    loading.value = false
  }
}

async function queryList() {
  try {
    const result = await getRequest("/goddessList",)
    listData.value = result.data.list
  } catch (err) {
    smartSentry.captureError(err);
  }
}
</script>