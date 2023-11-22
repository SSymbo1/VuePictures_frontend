<template>
<div>
  <el-container>
    <el-header>
      <el-page-header @back="goBack" content="搜索" style="margin-bottom: 5px"></el-page-header>
    </el-header>
    <el-main>
      <div class="background">
        <transition-group name="fade" translation="fade">
          <img v-for="(image,index) in img" :key="image.pid" :src="image.picture" :class="{ active: index === currentIndex }" alt="background" class="background">
        </transition-group>
      </div>
      <div class="title">
        <span>VuePictures</span>
      </div>
      <div class="search">
        <el-input placeholder="请输入搜索内容" v-model="searchBar" style="width: 550px;">
          <el-button slot="append" icon="el-icon-search" @click="toSearch()"></el-button>
        </el-input>
      </div>
    </el-main>
  </el-container>
</div>
</template>

<script>
import axios from "axios";
import {Loading} from "element-ui";

export default {
  created() {
    this.showLoading()
    this.getBackImage()
  },
  mounted() {
    //无用方法，本来是背景渐变计时器
    setInterval(() => {
      this.currentIndex = (this.currentIndex + 1) % 4;
    }, 5000);
    this.hideLoading()
  },
  data(){
    return{
      searchBar:"",
      img:[],
      currentIndex:0
    }
  },
  methods:{
    //返回至来时的页面
    goBack(){
      this.$router.back()
    },
    //跳转搜索
    toSearch(){
      this.$router.push({
        path:'/search',
        query:{
          searcher:this.searchBar
        }
      }).then().catch((err)=>{
        console.log(err)
      })
    },
    //获取背景图片
    getBackImage(){
      axios({
        method:'get',
        url:'api/getHeaderImg',
      }).then((resp)=>{
        this.img=resp.data
      })
    },
    //显示加载页面
    showLoading(){
      this.loading=true
      Loading.service({
        lock:true,
        text:'加载中...',
        background: 'rgb(255,255,255)'
      })
    },
    //关闭加载页面
    hideLoading(){
      this.loading = false
      Loading.service().close()
    }
  }
}
</script>

<style scoped>
@import "@/assets/font/font.css";
.title{
  font-family: "font_aigei_com",sans-serif;
  font-weight: bold;
  font-size: 90px;
  display: flex;
  justify-content: center;
  align-items: center;
  line-height: 180px;
}
.search{
  margin-top: 45px;
  position: relative;
  text-align: center;
}
.background {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  z-index: -1;
}
.fade-enter-active, .fade-leave-active {
  transition: opacity 0.5s;
}
.fade-enter,.fade-leave-to{
  opacity: 0;
}
</style>