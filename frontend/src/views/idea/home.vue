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
      <div class="data">
        <el-card class="data-card" shadow="hover">
          <div slot="header">
            <span>最近的投稿</span>
          </div>
          <div>
            <span>

            </span>
          </div>
        </el-card>
        <el-card class="data-card" shadow="hover">
          <div slot="header">
            <span>最近的被收藏的作品</span>
          </div>
          <div>
          </div>
        </el-card>
        <el-card class="data-card" shadow="hover">
          <div slot="header">
            <span>最近被浏览的作品</span>
          </div>
          <div>
          </div>
        </el-card>
        <el-card class="data-card" shadow="hover">
          <div slot="header">
            <span>粉丝</span>
          </div>
          <div>
          </div>
        </el-card>
        <el-card class="data-card" shadow="hover">
          <div slot="header">
            <span>作品总浏览量</span>
          </div>
          <div>
          </div>
        </el-card>

      </div>
    </el-main>
  </el-container>
</template>

<script>
import axios from "axios";
import index from "vuex";

export default {
  computed: {
    index() {
      return index
    }
  },
  created() {
    this.whatsTime()
    this.getUserInfo()
    this.getFansInfo()
    this.getIdeaDate()
  },
  data(){
    return{
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
        this.constTime()
        console.log(this.ideas)
      })
    },
    constTime(){

    },
    whatsTime(){
      const date = new Date();
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
    }
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
