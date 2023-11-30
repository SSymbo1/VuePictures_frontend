<template>
  <el-container>
    <el-backtop></el-backtop>
    <el-main>
      <div class="function_bar">
        <el-input v-model="keyword" maxlength="32" placeholder="请输入搜索关键字" prefix-icon="el-icon-search" style="width: 300px" clearable></el-input>
        <el-button type="primary" round icon="el-icon-search" @click="searchFollowFans" style="margin-left: 10px">搜索</el-button>
      </div>
      <div class="fans" v-if="fans.length!==0">
        <div class="fans_iteration" v-for="(user,index) in fans" :key="index">
          <transition name="el-fade-in-linear" appear>
            <el-popover
                placement="right-end"
                width="400"
                trigger="hover">
              <div class="fans-info" style="width: 400px;height: 240px;cursor: pointer">
                <div class="fans-background">
                  <el-image
                      :src="user.background"
                      style="height: 80px;width: 100%"
                      fit="cover"/>
                </div>
                <div class="fans-info-card">
                  <el-image
                      :src="user.userimage"
                      style="border-radius: 50%;width: 100px;height: 100px;margin-top: 10px;margin-left: 10px"
                      fit="cover"
                      @click="toUser(user.iid)"/>
                  <span class="fans-self" @click="toUser(user.iid)">昵称：{{user.nickname}}</span>
                  <div class="follow-time" @click="toUser(user.iid)">在{{user.followTime}}关注了你</div>
                  <div class="fans-button">
                    <el-button round type="primary" v-if="isFollowed(user.iid)" @click="followIt(user.iid,true)">取消回关</el-button>
                    <el-button round type="primary" v-else @click="followIt(user.iid,false)">回关</el-button>
                  </div>
                </div>
              </div>
              <el-card
                  slot="reference"
                  shadow="hover"
                  :body-style="{padding:'0px'}"
                  style="width:220px;height:270px;margin-left: 30px;cursor: pointer">
                <el-image
                    @click="toUser(user.iid)"
                    :src="user.userimage"
                    fit="cover"
                    lazy
                    style="border-radius: 50%;width: 110px;height: 110px;margin-left: 55px;margin-top: 30px"/>
                <div style="text-align: center;margin-top: 15px" @click="toUser(user.iid)">
                  {{user.nickname}}
                </div>
                <div class="bottom" style="text-align: center;margin-top: 25px">
                  <el-button type="danger" round  v-if="bans.includes(user.iid)" @click="blockUser(user.iid)" size="medium">取消拉黑</el-button>
                  <el-button type="danger" round  v-else @click="blockUser(user.iid)" size="medium">拉黑</el-button>
                </div>
              </el-card>
            </el-popover>
          </transition>
        </div>
      </div>
      <div class="not-fans" v-else>
        <span>没有找到您的粉丝呢,在努努力吧！</span>
      </div>
      <el-pagination
          :page-size="9"
          :pager-count=7
          layout="prev, pager, next"
          :total="this.maxPage*9"
          @current-change="handleCurrentChangeUser"
          style="margin-top: 15px">
      </el-pagination>
    </el-main>
  </el-container>
</template>

<script>
import axios from "axios";
import {Loading} from "element-ui";

export default {
  created() {
    this.showLoading()
    this.getBans()
    this.getLoginUser()
    this.getFollowed()
    this.searchFollowFans()
  },
  data(){
    return{
      keyword:'',
      fans:[],
      follow:[],
      loginUsr:[],
      bans:[],
      pageFans:1,
      maxPage:0
    }
  },
  methods:{
    searchFollowFans(){
      axios({
        method:'get',
        url:'api/search_fans',
        params:{
          token:localStorage.getItem("token"),
          page:this.pageFans,
          keyword:this.keyword
        }
      }).then((resp)=>{
        this.fans=resp.data.records
        this.maxPage=resp.data.pages
        this.hideLoading()
      })
    },
    getFollowed(){
      axios({
        method:'get',
        url:"api/all_user_follower",
        params:{
          token:localStorage.getItem("token")
        }
      }).then((resp)=>{
        this.follow=resp.data;
      }).catch((err)=>{
        this.$router.push("/wrong")
        this.hideLoading()
      })
    },
    getLoginUser(){
      axios({
        method:'get',
        url:'api/user_info',
        params:{
          token:localStorage.getItem("token")
        }
      }).then((resp)=>{
        this.loginUsr=resp.data
      })
    },
    getBans(){
      axios({
        method:'get',
        url:'api/userBlocker',
        params:{
          token:localStorage.getItem("token")
        }
      }).then((resp)=>{
        this.bans=resp.data
      })
    },
    toUser(id){
      this.$router.push({
        path:'/user',
        query:{
          uid:id
        }
      })
    },
    blockUser(ban){
      axios({
        method:'get',
        url:'api/block',
        params:{
          token:localStorage.getItem("token"),
          uid:ban
        }
      }).then((resp)=>{
        if(resp.data.success){
          this.$message.success(resp.data.message)
        }else {
          this.$message.error(resp.data.message)
        }
        this.getBans()
      })
    },
    followIt(fan,isFollowed){
      if (isFollowed){
        axios({
          method: 'get',
          url: 'api/follow',
          params: {
            uid: fan,
            fan: this.loginUsr[0].iid
          }
        }).then((resp)=>{
          if (resp.data===true){
            this.$message.success("取消关注成功！")
            this.getFollowed()
          }else {
            this.$message.success("取消关注失败！")
          }
        })
      }else {
        if (fan===this.loginUsr[0].iid){
          this.$message.error("操作失败！不能关注自己！")
        }else {
          axios({
            method: 'get',
            url: 'api/follow',
            params: {
              uid: fan,
              fan: this.loginUsr[0].iid
            }
          }).then((resp)=>{
            if (resp.data===true){
              this.$message.success("关注成功！")
              this.getFollowed()
            }else {
              this.$message.success("关注失败！")
            }
          })
        }
      }
    },
    handleCurrentChangeUser(page){
      this.pageFans=page;
      this.searchFollowFans()
      window.scrollTo(0,0)
      this.hideLoading()
    },
    isFollowed(uid){
      return this.follow.includes(uid)
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
.not-fans{
  font-family: "font_aigei_com",sans-serif;
  font-weight: bolder;
  font-size: large;
  margin-top: 20px;
  margin-left: 15px;
}
.function_bar{
  margin-left: 30px;
}
.fans_iteration{
  margin-top: 20px;
}
.fans{
  display: flex;
  flex-wrap: wrap;
  overflow: auto;
  align-items: center;
  justify-content: flex-start;
}
.fans-info-card{
  width: 400px;
  height: 150px;
  background-color: #f5f5f5;
  margin-top: 5px;
}
.fans-self{
  position: relative;
  top: -65px;
  margin-left: 25px;
}
.follow-time{
  position: relative;
  top: -58px;
  margin-left: 135px;
}
.fans-button{
  position: relative;
  top: -45px;
  margin-left: 135px;
}
.bottom {
  margin-top: 1px;
  line-height: 10px;
}
</style>