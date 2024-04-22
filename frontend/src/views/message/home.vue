<template>
  <el-container>
    <el-main v-for="(user,index) in users" :key="index">
      <img
          :src="user.userimage"
          :alt="user.nickname"
          style="border-radius: 50%;width: 200px;height: 200px;float: left">
      <div class="welcome">
        <h2 style="font-size: 50px;font-family: 'font_aigei_com',sans-serif;">你好啊！{{user.nickname}}</h2>
        <h1 style="font-size: 20px;">{{slogn}}</h1>
      </div>
      <br/>
      <transition name="el-fade-in-linear" appear>
        <div class="data">
          <el-card class="data-card" shadow="hover">
            <div slot="header">
              <span>好友在线</span>
            </div>
            <div>
              <div>{{count}}人</div>
            </div>
          </el-card>
          <el-card class="data-card" shadow="hover">
            <div slot="header">
              <span>未读信息</span>
            </div>
            <div>
              <div>{{message}}条</div>
            </div>
          </el-card>
          <el-card class="data-card" shadow="hover">
            <div slot="header">
              <span>通知</span>
            </div>
            <div>
              <div>{{broadcast}}条</div>
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
    this.getRandomSlogn()
    this.getUserInfo()
  },
  data(){
    return{
      users:[],
      online:[],
      aphorisms:['在交谈中，判断比雄辩更重要。',
                '沟通是情感的传递，是信息的互动。沟通没有对错，只有坚持。',
                '爱一人个是麻木，麻木会包容一切，沟通得到就行。',
                '世界上有两种东西能治病，一是药物，二是语言。',
                '交流是最快的理解方式之一。'],
      slogn:'',
      count:0,
      message:0,
      broadcast:0,
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
        this.users=resp.data
        this.hideLoading()
      }).catch((err)=>{
      })
    },
    getRandomSlogn(){
      this.slogn=this.aphorisms[Math.floor(Math.random()*this.aphorisms.length)]
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