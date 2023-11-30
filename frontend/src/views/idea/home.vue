<template>
  <el-container>
    <el-main v-for="(user,index) in userInfo" :key="index" style="width: 100%">
      <img
          :src="user.userimage"
          :alt="user.nickname"
          style="border-radius: 50%;width: 200px;height: 200px;float: left">
      <div class="welcome">
        <h2 style="font-size: 50px;font-family: 'font_aigei_com',sans-serif;">{{welcome}}{{user.nickname}}</h2>
        <h1 style="font-size: 20px;">{{slogn}}</h1>
      </div>
      <transition name="el-fade-in-linear" appear>
        <div class="data">
          <el-card class="data-card" shadow="hover">
            <div slot="header">
              <span>最近的投稿</span>
            </div>
            <div>
              <div v-if="time.submit!=='1970-01-01 08:00:00'">{{time.submit}}</div>
              <div v-else>无投稿</div>
            </div>
          </el-card>
          <el-card class="data-card" shadow="hover">
            <div slot="header">
              <span>最近的被收藏的作品</span>
            </div>
            <div>
              <div v-if="time.submit!=='1970-01-01 08:00:00'">{{time.favorite}}</div>
              <div v-else>无投稿</div>
            </div>
          </el-card>
          <el-card class="data-card" shadow="hover">
            <div slot="header">
              <span>最近被浏览的作品</span>
            </div>
            <div>
              <div v-if="time.submit!=='1970-01-01 08:00:00'">{{time.view}}</div>
              <div v-else>无投稿</div>
            </div>
          </el-card>
          <el-card class="data-card" shadow="hover">
            <div slot="header">
              <span>粉丝</span>
            </div>
            <div>
              <div>
                {{ideas.fans}}
              </div>
            </div>
          </el-card>
          <el-card class="data-card" shadow="hover">
            <div slot="header">
              <span>作品总浏览量</span>
            </div>
            <div>
            <span>
              {{ideas.views}}
            </span>
            </div>
          </el-card>
        </div>
      </transition>
    </el-main>
  </el-container>
</template>

<script>
import axios from "axios";
import {Loading} from "element-ui";

export default {
  mounted() {
    this.showLoading()
    this.whatsTime()
    this.getUserInfo()
    this.getFansInfo()
    this.getIdeaDate()
  },
  data(){
    return{
      time:{
        view:'',
        submit:'',
        favorite:'',
      },
      ideas:[],
      userInfo:[],
      fans:[],
      welcome:'',
      slogn:''
    }
  },
  methods:{
    getUserInfo(){
      axios({
        method:'get',
        url:'/api/user_info',
        params:{
          token:localStorage.getItem("token")
        }
      }).then((resp)=>{
        this.userInfo=resp.data
      }).catch((err)=>{
      })
    },
    getFansInfo(){
      axios({
        method:'get',
        url:'api/fans_info',
        params:{
          token:localStorage.getItem("token")
        }
      }).then((resp)=>{
        this.fans=resp.data
      }).catch((err)=>{
      })
    },
    getIdeaDate(){
      axios({
        method:'get',
        url:'api/idea',
        params:{
          token:localStorage.getItem("token")
        }
      }).then((resp)=>{
        this.ideas=resp.data
        this.constTime(this.ideas.lastFavorite.favoritetime,'f')
        this.constTime(this.ideas.lastSubmit.createtime,'s')
        this.constTime(this.ideas.lastView.lastviewtime,'v')
        this.hideLoading()
      })
    },
    constTime(time,cases){
      let date=new Date(time)
      let Y = date.getFullYear(),
          M = (date.getMonth() + 1 < 10 ? '0' + (date.getMonth() + 1) : date.getMonth() + 1),
          D = (date.getDate() < 10 ? '0' + (date.getDate()) : date.getDate()),
          h = (date.getHours() < 10 ? '0' + (date.getHours()) : date.getHours()),
          m = (date.getMinutes() < 10 ? '0' + (date.getMinutes()) : date.getMinutes()),
          s = (date.getSeconds() < 10 ? '0' + (date.getSeconds()) : date.getSeconds());
      if (cases==='f'){
        this.time.favorite=Y + '-' + M + '-' + D + ' ' + h + ':' + m + ':' + s
      }
      else if(cases==='s'){
        this.time.submit=Y + '-' + M + '-' + D + ' ' + h + ':' + m + ':' + s
      }
      else if(cases==='v'){
        this.time.view=Y + '-' + M + '-' + D + ' ' + h + ':' + m + ':' + s
      }
    },
    whatsTime(){
      let date = new Date();
      if ((date.getHours()>=2&&date.getHours()<4)||(date.getHours()>=22||date.getHours()<2)){
        this.welcome='还没睡码？'
        this.slogn='夜深人静，好好休息。'
      }
      else if(date.getHours()>=4&&date.getHours()<7){
        this.welcome="早上好！"
        this.slogn='新的一天，新的开始。'
      }
      else if(date.getHours()>=7&&date.getHours()<10){
        this.welcome='上午好！'
        this.slogn='精神饱满，迎接挑战。'
      }
      else if(date.getHours()>=10&&date.getHours()<14){
        this.welcome='中午好！'
        this.slogn='休息一下，为下午充电。'
      }
      else if(date.getHours()>=14&&date.getHours()<20){
        this.welcome='下午好！'
        this.slogn='体力充沛，全力以赴。'
      }
      else if(date.getHours()>=20&&date.getHours()<22){
        this.welcome='晚上好！'
        this.slogn='放松心情，享受夜晚。'
      }
    },
    showLoading(){
      this.loading=true
      Loading.service({
        lock:true,
        text:'加载中...',
        background: 'rgb(255,255,255)'
      })
    },
    hideLoading(){
      this.loading = false
      Loading.service().close()
    },
  }
}
</script>

<style scoped>
@import "@/assets/font/font.css";
.welcome{
  float: left;
  margin-left: 20px;
}
.data{
  float: left;
  margin-top: 15px;
}
.data-card{
  width: 250px;
  float: left;
  margin-left: 10px;
  margin-top: 10px;
}
</style>
