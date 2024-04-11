<template>
  <a-table :columns="columns" :data-source="userList" :loading="loading">
    <template #bodyCell="{ column, record }">
      <template v-if="column.key === 'userId'">

      </template>

      <template v-else-if="column.key === 'avatar'">
        <a-image :src="record.avatar" :height="80" />
      </template>

      <template v-else-if="column.key === 'nickname'">
        <a @click="showDetail(record)">{{ record.nickname }}</a>
      </template>
      <template v-else-if="column.key === 'action'">
        <a-button type="primary" @click="openUserDetails(record)">查看</a-button>
      </template>
    </template>
  </a-table>
  <!--  抽屉-->
  <a-drawer
      width="1000"
      v-model:open="openDetail"
      class="custom-class"
      root-class-name="root-class-name"
      title="Basic Drawer"
      placement="right"
      @after-open-change="afterOpenChange"
  >
    <a-col>
      <div>
        <a-image :src="userData.avatar" :height="120"/>
      </div>
    </a-col>
    <a-col>
      <a-row>
        <a-col :span="6">
          <div style="height: 50px;align-items: center;display:flex;">
            ID：{{ userData.userId }}
          </div>
        </a-col>
        <a-col :span="6">
          <div style="height: 50px;align-items: center;display:flex;">
            昵称：{{ userData.nickname }}
          </div>
        </a-col>
        <a-col :span="6">
          <div style="height: 50px;align-items: center;display:flex;">
            性别：{{ gender }}
          </div>
        </a-col>
        <a-col :span="6">
          <div style="height: 50px;align-items: center;display:flex;">
            年龄：
          </div>
        </a-col>
      </a-row>
      <a-row>
        <a-col :span="6">
          <div style="height: 50px;align-items: center;display:flex;">
            邮箱：{{ userData.email }}
          </div>
        </a-col>
        <a-col :span="6">
          <div style="height: 50px;align-items: center;display:flex;">
            VIP：{{ userData.vip === 1 ? "是" : "否" }}
          </div>
        </a-col>
        <a-col :span="6">
          <div style="height: 50px;align-items: center;display:flex;">
            VIP到期时间：{{ vipExpireTime }}
          </div>
        </a-col>
        <a-col :span="6">
          <div style="height: 50px;align-items: center;display:flex;">

          </div>
        </a-col>
      </a-row>
      <a-row>
        <a-col :span="6">
          <div style="height: 50px;align-items: center;display:flex;">
            真人认证：
          </div>
        </a-col>
        <a-col :span="6">
          <div style="height: 50px;align-items: center;display:flex;">
            女神认证：
          </div>
        </a-col>
        <a-col :span="6">
          <div style="height: 50px;align-items: center;display:flex;">
            注册时间：{{ registerTime }}
          </div>
        </a-col>
      </a-row>
    </a-col>
  </a-drawer>
</template>

<script setup>
import {reactive, ref, onMounted} from 'vue';
import {smartSentry} from "/@/lib/smart-sentry.js";
import {getRequest, postRequest} from "/@/lib/axios.js";
import {useRouter} from "vue-router";
import {useUserStore} from "/@/store/modules/system/user.js";

let router = useRouter();
const store = useUserStore()

function openUserDetails(record) {
  let tagNav = store.tagNav;
  tagNav.forEach((data) => {
    if (data.menuTitle === "用户详情") {
      data.menuQuery = {userId: record.userId}
    }
  })
  router.push({path: '/user/user-details', query: {userId: record.userId}});
}

const columns = [
  {
    title: 'ID',
    dataIndex: 'userId',
    key: 'userId',
  },
  {
    title: '头像',
    dataIndex: 'avatar',
    key: 'avatar',
  },
  {
    title: '昵称',
    dataIndex: 'nickname',
    key: 'nickname',
  },
  {
    title: '操作',
    dataIndex: 'action',
    key: 'action',
  },
];

const loading = ref(false);
const userList = ref([]);
const openDetail = ref(false);
const userData = ref({});
const gender = ref("");
const vipExpireTime = ref("");
const registerTime = ref("");

onMounted(() => {
  queryUserList();
});

function formatTimestamp(timestamp) {
  if (timestamp === 0) {
    vipExpireTime.value = "-"
    return "-"
  }
  // 创建一个新的 Date 对象，并将时间戳乘以 1000 转换为毫秒
  let date = new Date(timestamp * 1000);

  // 获取年、月、日、小时、分钟、秒
  let year = date.getFullYear();
  let month = String(date.getMonth() + 1).padStart(2, '0');
  let day = String(date.getDate()).padStart(2, '0');
  let hours = String(date.getHours()).padStart(2, '0');
  let minutes = String(date.getMinutes()).padStart(2, '0');
  let seconds = String(date.getSeconds()).padStart(2, '0');
  return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;
}

function showDetail(user) {
  if (user.sex === 1) {
    gender.value = "男"
  } else if (user.sex === 2) {
    gender.value = "女"
  } else {
    gender.value = "未知"
  }
  vipExpireTime.value = formatTimestamp(user.vipExpireTime)
  registerTime.value = formatTimestamp(user.createAt)
  userData.value = user
  openDetail.value = true
}

//查询用户
async function queryUserList() {
  try {
    loading.value = true;
    const result = await getRequest("/userList",)
    userList.value = result.data.list
  } catch (err) {
    smartSentry.captureError(err);
  } finally {
    loading.value = false;
  }
}


</script>