<script setup>

import zhuoda from "/@/assets/images/1024lab/ven.jpg";
import xiaozhen from "/@/assets/images/1024lab/ven_group.jpg";
</script>

<template>
<!--  <br />-->
<!--  <div class="app-qr-box">-->
<!--    <div class="app-qr">-->
<!--      <img :src="zhuoda" style="width: 100px;height: 100px"/>-->
<!--      <span class="qr-desc strong"> AlicoChat开源作者微信号</span>-->
<!--      <span class="qr-desc">Ven：x39598</span>-->
<!--    </div>-->
<!--    <div class="app-qr">-->
<!--      <img :src="xiaozhen" width="100px" height="100px"/>-->
<!--      <span class="qr-desc strong"> 加入AlicoChat开源交流群 </span>-->
<!--      <span class="qr-desc"> 赚钱、代码、生活 </span>-->
<!--    </div>-->
<!--  </div>-->
  <div style="display: flex;flex-direction: column;align-content: center;height: 100%;">
    <a-row style="margin-bottom: 80px;margin-top: 100px">
      <a-col :span="24">
        <div
            style="align-content: center;justify-content: center;justify-items: center;align-items: center;display: flex">
          <span style="font-size: 35px">AlicoChat泛娱乐社交开源后台</span>
        </div>
      </a-col>
    </a-row>
    <a-row>
      <a-col :span="24">
        <div
            style="align-content: center;justify-content: center;justify-items: center;align-items: center;display: flex">
          <img :src="xiaozhen" style="width: 200px;height: 200px"/>

        </div>

      </a-col>
    </a-row>
    <a-row>
      <a-col :span="24">
        <div
            style="align-content: center;justify-content: center;justify-items: center;align-items: center;display: flex;margin-top: 20px">
          <span style="font-size: 20px">AlicoChat开源交流群1</span>
        </div>

      </a-col>
    </a-row>
  </div>
</template>

<style scoped lang="less">

</style>