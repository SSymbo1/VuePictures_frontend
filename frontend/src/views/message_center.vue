<template>
  <el-container>
    <el-aside style="height: 600px">
      <el-menu
          :default-active="menuAction"
          mode="vertical"
          v-for="(chat,index) in chats" :key="index">
        <el-menu-item :index="chat.nickname" style="margin-bottom: 10px;height: 156px" @click="toMessageSend(chat.iid,chat.nickname)">
          <el-card shadow="hover">
            <div class="user_image" style="float: left">
              <el-image
                  :src="chat.userimage"
                  style="border-radius: 50%;width: 80px;height: 80px;margin-top: 10px"/>
            </div>
            <div class="user_describe" style="margin-left: 100px">
              <span class="user_name">{{chat.nickname}}</span>
              <div class="online_statue" v-if="isOnline(chat.iid)" style="color: green;position: relative;top: -15px">
                <span style="margin-right: 5px">●</span>
                <span>在线</span>
              </div>
              <div class="online_statue" v-else style="color: gray;position: relative;top: -15px">
                <span style="margin-right: 5px;">●</span>
                <span>离线</span></div>
            </div>
          </el-card>
        </el-menu-item>
      </el-menu>
      <el-pagination
          :page-size="9"
          :pager-count="5"
          layout="prev, pager, next"
          :total="this.maxPageUser*9"
          style="float: right"
          @current-change="handleCurrentChangeUser">
      </el-pagination>
    </el-aside>
    <el-container>
      <el-main style="height: 100%;overflow: hidden">
        <router-view></router-view>
      </el-main>
    </el-container>
  </el-container>
</template>

<script>
import axios from "axios";
import {Loading} from "element-ui";
import {eventBus} from "@/main";

export default {
  created() {
    this.getChatUser()
    if (this.$store.state.online.userInfos!==undefined){
      this.online=this.$store.state.online.userInfos
    }
    eventBus.$on('ws-message',(message)=>{
      this.online=message.userInfos
    })
  },
  data(){
    return{
      menuAction:'0',
      chats:[],
      online:[],
      friends:[],
      pageUser:1,
      maxPageUser:0,
      count:0,
    }
  },
  methods:{
    getChatUser(){
      axios({
        method:'get',
        url:'api/getChatUser',
        params:{
          token:localStorage.getItem("token"),
          pageNum:this.pageUser,
        }
      }).then((resp)=>{
        this.chats=resp.data.records
        this.maxPageUser=resp.data.pages
        this.hideLoading()
      })
    },
    handleCurrentChangeUser(page){
      this.pageUser=page
      this.getChatUser()
      window.scrollTo(0,0)
    },
    isOnline(iid){
      for (let obj of this.online){
        if (iid===obj.iid){
          return true
        }
      }
      return false
    },
    toMessageSend(uid){
      this.$router.push({
        path:'/letter',
        query:{
          chat:uid,
        }
      })
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
  },
}
</script>

<style scoped>

</style>