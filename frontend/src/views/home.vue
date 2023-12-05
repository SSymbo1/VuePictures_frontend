<template>
  <div>
    <el-container>
      <div class="container">
        <el-header class="right-align">
          <el-menu
              :default-active="activeIndex.toString()"
              class="el-menu-demo"
              mode="horizontal">
            <el-menu-item index="/home">
              <span class="logo" @click="toHome()">VuePictures</span>
            </el-menu-item>
            <el-menu-item index="/search">
              <el-input placeholder="请输入搜索内容" v-model="searchBar" class="input-with-select" style="width: 350px">
                <el-button slot="append" icon="el-icon-search" @click="toSearch()"></el-button>
              </el-input>
            </el-menu-item>
            <el-menu-item index="/message" @click="toMessage">
              <i class="el-icon-chat-dot-square"></i>
              <span slot="title">信息</span>
            </el-menu-item>
            <el-menu-item index="/trends">
              <i class="el-icon-s-promotion"></i>
              <span slot="title">动态</span>
            </el-menu-item>
            <el-menu-item index="/ideahome" @click="toSubmit">
              <i class="el-icon-edit"></i>
              <span slot="title">创作中心</span>
            </el-menu-item>
            <el-submenu index="/user">
              <template slot="title"><el-avatar :size="50" :src="circleUrl"></el-avatar></template>
              <el-menu-item index="/personal" @click="toUserInfo()">个人资料</el-menu-item>
              <el-menu-item index="/history" @click="toHistory()">历史</el-menu-item>
              <el-menu-item index="/exit" @click="exit">退出登录</el-menu-item>
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
import {eventBus} from "@/main";

export default {
  data() {
    return {
      ws:null,
      activeIndex: "0",
      circleUrl:'',
      searchBar:'',
      user:[],
      nickname:'',
      websocket:null,
    };
  },
  created() {
    this.initWebSocket()
  },
  mounted() {
    this.getUserInfo()
  },
  destroyed() {
    //移除滚动条监听器
    window.removeEventListener("scroll",this.rolling)
  },
  beforeDestroy() {
    //移除滚动条监听器
    window.removeEventListener("scroll",this.rolling)
  },
  methods: {
    //获取当前登录用户信息
    getUserInfo(){
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
    getUser(id){
      axios({
        method:'get',
        url:'api/user_info_id',
        params:{
          uid:id
        }
      }).then((resp)=>{
        for (let obj of resp.data){
          this.nickname=obj.nickname
        }
      })
    },
    initWebSocket(){
      const token=localStorage.getItem("token")
      if (this.ws===null){
        this.ws=new WebSocket(`ws://localhost:9090/chat_ws/${token}`)
        this.ws.addEventListener('open',(event)=>{
          console.log("成功连接至websocket服务器!")
        })
        this.ws.addEventListener('message',(event)=>{
          console.log("从websocket服务器获取信息")
          if ("message" in JSON.parse(event.data)){
            this.getUser(JSON.parse(event.data).from)
            this.$notify({
              title:'你有一条新信息！来自:'+this.nickname,
              message:JSON.parse(event.data).message,
              position:'bottom-right',
              onClick:()=>{
                this.toNote(JSON.parse(event.data).from)
              }
            })
            eventBus.$emit('ws-note',JSON.parse(event.data))
          }else {
            this.$store.commit('set_online',JSON.parse(event.data))
            eventBus.$emit('ws-message',JSON.parse(event.data))
          }
        })
        this.ws.addEventListener('error',(event)=>{
          console.log("连接websocket失败!")
        })
      }
      this.$root.$websocket=this.ws
    },
    //退出登录（注销）
    exit(){
      this.$confirm("是否退出登录？","退出",{
        confirmButtonText:'退出',
        cancelButtonText:'取消',
        type:'info',
        roundButton:true
      }).then(()=>{
        localStorage.removeItem("token");
        this.ws.close()
        this.ws=null
        router.push('/');
        this.$message({
          type:'success',
          message:'再见'
        })
      }).catch(()=>{
      })
    },
    //跳转个人资料
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
    //跳转历史记录
    toHistory(){
      this.$router.push({
        path:'/history'
      })
    },
    //跳转投稿
    toSubmit(){
      this.searchBar=''
      this.$router.push('/ideahome')
    },
    toMessage(){
      this.$router.push({
        path:'/message_home',
      })
    },
    //跳转搜索
    toSearch(){
      if (this.searchBar.length===0){
        this.$router.push("/searchHome").catch((error)=>{
          console.log(error)
        })
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
    //跳转主页
    toHome(){
      this.searchBar=''
      this.activeIndex=-1
      this.$router.push("/home")
    },
    toNote(id){
      this.$router.push({
        path:'/letter',
        query:{
          chat:id
        }
      })
    },
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