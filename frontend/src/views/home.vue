<template>
  <div>
    <el-container>
      <div class="container">
        <el-header class="right-align">
          <el-menu
              :default-active="activeIndex"
              class="el-menu-demo"
              mode="horizontal"
              @select="handleSelect">
            <el-menu-item index="0">
              <span class="logo" @click="toHome()">VuePictures</span>
            </el-menu-item>
            <el-menu-item>
              <el-input placeholder="请输入搜索内容" v-model="searchBar" class="input-with-select" style="width: 350px">
                <el-button slot="append" icon="el-icon-search" @click="toSearch()"></el-button>
              </el-input>
            </el-menu-item>
            <el-submenu index="1">
              <template slot="title">选项占位符</template>
              <el-menu-item index="1-1">选项1</el-menu-item>
              <el-menu-item index="1-2">选项2</el-menu-item>
              <el-menu-item index="1-3">选项3</el-menu-item>
            </el-submenu>
            <el-menu-item index="2">动态</el-menu-item>
            <el-menu-item index="3" @click="toSubmit">投稿</el-menu-item>
            <el-submenu index="4">
              <template slot="title"><el-avatar :size="50" :src="circleUrl"></el-avatar></template>
              <el-menu-item index="4-1" @click="toUserInfo()">个人资料</el-menu-item>
              <el-menu-item index="4-2">历史</el-menu-item>
              <el-menu-item index="4-3" @click="exit">退出登录</el-menu-item>
            </el-submenu>
          </el-menu>
        </el-header>
      </div>
      <el-main class="main">
        <el-backtop target=".main"></el-backtop>
        <router-view :key="$route.fullPath"></router-view>
      </el-main>
      <el-footer class="footer">
        <div class="footer">
        </div>
      </el-footer>
    </el-container>
  </div>
</template>

<script>
import router from "@/router/router";
import axios from "axios";

export default {
  data() {
    return {
      activeIndex: '1',
      circleUrl:'',
      searchBar:'',
      user:[]
    };
  },
  mounted() {
    axios({
      method:'get',
      url:'/api/user_info',
      params:{
        token:localStorage.getItem("token")
      }
    }).then((resp)=>{
      this.circleUrl=resp.data[0].userimage;
      this.user=resp.data
    })
  },
  destroyed() {
    window.removeEventListener("scroll",this.rolling)
  },
  beforeDestroy() {
    window.removeEventListener("scroll",this.rolling)
  },
  methods: {
    handleSelect(key, keyPath) {
      console.log(key, keyPath);
    },
    exit(){
      this.$confirm("是否退出登录？","退出",{
        confirmButtonText:'退出',
        cancelButtonText:'取消',
        type:'info'
      }).then(()=>{
        localStorage.removeItem("token");
        router.push('/');
        this.$message({
          type:'success',
          message:'再见'
        })
      }).catch(()=>{
      })
    },
    toUserInfo(){
      this.searchBar=''
      this.$router.push({
        path:'/user',
        query:{
          uid:this.user[0].iid
        }
      }).then().catch((err)=>{
        console.log(err)
      })
    },
    toSubmit(){
      this.searchBar=''
      this.$router.push('/submit')
    },
    toSearch(){
      if (this.searchBar.length===0){
        this.$router.push("/searchHome").catch((error)=>{
          console.log(error)})
      }else {
        this.$router.push({
          path:'/search',
          query:{
            searcher:this.searchBar,
            use:'artwork'
          }
        }).then().catch((err)=>{
          console.log(err)
        }).catch((error)=>{
          console.log(error)
        })
      }
    },
    toHome(){
      this.searchBar=''
      this.$router.push("/home")
    }
  }
}
</script>

<style scoped>
@import "@/assets/font/font.css";
.container {
  display: flex;
  flex-direction: column;
  max-width: 100%;
  margin: 0 auto;
}
.right-align{
  display: flex;
  justify-content: space-between;
  align-items: center;
  flex: 0 1 auto;
  max-width: 100%;
}
.logo{
  font-family: "font_aigei_com",sans-serif;
  font-size: 40px;
  font-weight: bold;
  color: #333;
}
</style>