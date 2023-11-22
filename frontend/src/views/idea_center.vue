<template>
  <el-container>
    <el-main>
      <el-menu
          :default-active="menuAction"
          mode="vertical"
          style="width: 20%;float: left">
        <el-menu-item index="/ideahome" @click="toHome">
          <i class="el-icon-s-home"></i>
          <span>主页</span>
        </el-menu-item>
        <el-menu-item index="/submit" @click="toSubmit">
          <i class="el-icon-upload"></i>
          <span>投稿</span>
        </el-menu-item>
        <el-menu-item index="/artwork_manage" @click="toArtworkManage">
          <i class="el-icon-picture"></i>
          <span>插画管理</span>
        </el-menu-item>
        <el-menu-item index="/fans_manage">
          <i class="el-icon-s-custom"></i>
          <span>粉丝管理</span>
        </el-menu-item>
        <el-menu-item index="/artwork_data">
          <i class="el-icon-s-order"></i>
          <span>插画数据</span>
        </el-menu-item>
        <el-menu-item index="/fans_data">
          <i class="el-icon-message-solid"></i>
          <span>粉丝数据</span>
        </el-menu-item>
      </el-menu>
      <div class="main-view" style="float: none;margin-left: 10px;width: 80%">
        <router-view :key="$route.fullPath"></router-view>
      </div>
    </el-main>
  </el-container>
</template>

<script>
import router from "@/router/router";
export default {
  created() {
    this.menuAction = this.$route.path
  },
  data(){
    return{
      menuAction:"0"
    }
  },
  methods:{
    toHome(){
      router.push("/ideahome")
    },
    toSubmit(){
      router.push("/submit")
    },
    toArtworkManage(){
      router.push("/artwork_manage")
    }
  }
}
</script>

<style scoped>
</style>