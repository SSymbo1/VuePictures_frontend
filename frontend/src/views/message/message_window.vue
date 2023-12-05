<template>
  <el-container style="height: 100%;padding-left: 100px">
    <div style="padding: 10px; margin-bottom: 50px">
      <el-row>
        <el-col :span="20">
          <div style="width: 800px; margin: 0 auto; background-color: white;
                    border-radius: 5px; box-shadow: 0 0 10px #ccc">
            <div style="text-align: center; line-height: 50px;" v-for="(user,index) in acceptUserInfo" :key="index">
              {{user.nickname}}
            </div>
            <div style="height: 350px; overflow:auto; border-top: 1px solid #ccc" v-html="content"></div>
            <div style="height: 200px">
            <textarea v-model="text" style="resize: none;height: 110px; width: 760px; padding: 20px; border: none; border-top: 1px solid #ccc;
             border-bottom: 1px solid #ccc; outline: none"></textarea>
              <div style="text-align: right; padding-right: 10px;padding-top: 8px">
                <el-button type="primary" size="mini" @click="sendMessage">发送</el-button>
              </div>
            </div>
          </div>
        </el-col>
      </el-row>
    </div>
  </el-container>
</template>

<script>
import axios from "axios";
import {eventBus} from "@/main";
import {Loading} from "element-ui";
export default {
  data() {
    return {
      userInfo:[],
      acceptUserInfo:[],
      users: [],
      history:[],
      text: "",
      content: '',
      iid:0,
      loginUsr:{},
      socket:null,
    }
  },
  created() {
    this.showLoading()
    this.iid=this.$route.query.chat
    this.getUserInfo()
    this.initWebSocket()
    this.getAcceptInfo()
    this.getHistoryMessage()
  },
  methods: {
    getUserInfo(){
      axios({
        method:'get',
        url:'/api/user_info',
        params:{
          token:localStorage.getItem("token")
        }
      }).then((resp)=>{
        this.userInfo=resp.data
      })
    },
    getAcceptInfo(){
      axios({
        method:'get',
        url:'api/user_info_id',
        params:{
          uid:this.iid
        }
      }).then((resp)=>{
        this.acceptUserInfo=resp.data
      })
    },
    getHistoryMessage(){
      axios({
        method:'get',
        url:'api/historyMessage',
        params:{
          token:localStorage.getItem("token"),
          accept:this.iid
        }
      }).then((resp)=>{
        this.history=resp.data
        this.historyMessage()
      })
    },
    sendMessage() {
      if (!this.text) {
        this.$message({type: 'warning', message: "不能发送空内容,请输入内容!"})
      } else {
        let message = {from: this.userInfo[0].iid, to: this.iid, message: this.text}
        this.socket.send(JSON.stringify(message));
        console.log(message)
        this.createContent(null, this.userInfo[0].iid, message.message)
        this.text = '';
      }
    },
    initWebSocket(){
      this.socket=this.$root.$websocket
      eventBus.$on('ws-note',(message)=>{
        if ("message" in message){
          if (message.from===Number(this.iid)){
            this.createContent(message.from,null,message.message)
          }
        }
      })
    },
    historyMessage(){
      for (let obj of this.history){
        if (obj.send===this.userInfo[0].iid){
          this.createContent(null,obj.send,obj.message)
        }else {
          this.createContent(obj.send,null,obj.message)
        }
      }
      this.hideLoading()
    },
    createContent(remoteUser, nowUser, text) {
      let html
      if (nowUser) {
        html = "<div class=\"el-row\" style=\"padding: 5px 0\">\n" +
            "  <div class=\"el-col el-col-22\" style=\"text-align: right; padding-right: 10px\">\n" +
            "    <div class=\"tip left\">" + text + "</div>\n" +
            "  </div>\n" +
            "  <div class=\"el-col el-col-2\">\n" +
            "  <span class=\"el-avatar el-avatar--circle\" style=\"height: 40px; width: 40px; line-height: 40px;\">\n" +
            "    <img src="+this.userInfo[0].userimage+" style=\"object-fit: cover;\">\n" +
            "  </span>\n" +
            "  </div>\n" +
            "</div>";
      } else if (remoteUser) {
        html = "<div class=\"el-row\" style=\"padding: 5px 0\">\n" +
            "  <div class=\"el-col el-col-2\" style=\"text-align: right\">\n" +
            "  <span class=\"el-avatar el-avatar--circle\" style=\"height: 40px; width: 40px; line-height: 40px;\">\n" +
            "    <img src="+this.acceptUserInfo[0].userimage+" style=\"object-fit: cover;\">\n" +
            "  </span>\n" +
            "  </div>\n" +
            "  <div class=\"el-col el-col-22\" style=\"text-align: left; padding-left: 10px\">\n" +
            "    <div class=\"tip right\">" + text + "</div>\n" +
            "  </div>\n" +
            "</div>";
      }
      this.content += html;
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

<style>
.tip {
  color: white;
  text-align: center;
  border-radius: 10px;
  font-family: sans-serif;
  padding: 10px;
  width:auto;
  display:inline-block !important;
  display:inline;
}
.right {
  background-color: deepskyblue;
}
.left {
  background-color: forestgreen;
}
</style>

