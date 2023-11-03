<template>
  <el-container>
    <el-header>
      <el-page-header @back="goBack" content="创作中心" style="margin-bottom: 5px"></el-page-header>
    </el-header>
    <el-main>
      <el-menu
          :default-active="activeIndex"
          class="el-menu-demo"
          mode="vertical"
          style="width: 20%;float: left">
        <el-menu-item index="0">
          <i class="el-icon-s-home"></i>
          <span @click="this.$router.push('/')">主页</span>
        </el-menu-item>
        <el-menu-item index="1">
          <i class="el-icon-upload"></i>
          <span>投稿</span>
        </el-menu-item>
        <el-menu-item index="2">
          <i class="el-icon-picture"></i>
          <span>插画管理</span>
        </el-menu-item>
        <el-menu-item index="3">
          <i class="el-icon-s-custom"></i>
          <span>粉丝管理</span>
        </el-menu-item>
        <el-menu-item index="4">
          <i class="el-icon-s-order"></i>
          <span>插画数据</span>
        </el-menu-item>
        <el-menu-item index="5">
          <i class="el-icon-message-solid"></i>
          <span>粉丝数据</span>
        </el-menu-item>
      </el-menu>
      <div class="main-view" style="float: none;margin-left: 10px;width: 80%">
        <router-view></router-view>
      </div>
    </el-main>
  </el-container>
</template>

<script>
export default {
  data(){
    return{
      activeIndex:'0'
    }
  },
  methods:{
    goBack(){
      this.$router.back()
    },
  }
}
</script>

<style scoped>

</style>