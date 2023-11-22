<template>
  <div>
    <el-container>
      <el-backtop></el-backtop>
      <el-header>
        <el-menu
            mode="horizontal"
            :default-active="selectCon">
          <el-menu-item index="0" @click="toArtwork()">插画</el-menu-item>
          <el-menu-item index="1" @click="toSearchUser()">用户</el-menu-item>
        </el-menu>
      </el-header>
      <el-main>
        <div class="search-card">
          <div class="artwork" v-if="switchMode===true">
            <div v-if="this.imgs.length===0" class="not-found">
              什么都没有找到呢...
            </div>
            <div v-else>
              <div v-for="(img,index) in imgs" :key="index">
                <el-card shadow="hover" class="image-card" >
                  <div style="margin:0;float: left" @click="toArtworksInfo(img.pid)">
                    <el-image
                        :src="img.picture"
                        lazy
                        fit="cover"
                        style="height: 180px;width: 300px;">
                    </el-image>
                  </div>
                  <div style="margin-left: 20px;float: left">
                    <div @click="toArtworksInfo(img.pid)">pid:{{img.pid}}</div>
                    <div @click="toArtworksInfo(img.pid)">标题：{{img.subtitle}}</div>
                    <div @click="toArtworksInfo(img.pid)">收藏数：{{img.likenum}}</div>
                    <div style="margin-top: 10px">
                      <el-button type="primary" round v-if="img.liked" @click="favoriteIt(img.pid,img.liked)">取消收藏</el-button>
                      <el-button type="primary" round v-else @click="favoriteIt(img.pid,img.liked)">收藏</el-button>
                    </div>
                  </div>
                  <div class="artist">
                    <img
                        :src="img.userInfo.userimage"
                        style="float: left;border-radius: 50%;width: 80px;height: 80px"
                        alt="用户头像"
                        @click="toUser(img.uid)">
                    <div style="float: left;margin-left: 15px;margin-top: 15px">
                      <span @click="toUser(img.uid)">作者：{{img.userInfo.nickname}}</span>
                      <span style="margin-left: 15px">
                      <el-button type="primary" round v-if="isFollowed(img.userInfo.iid)" @click="followIt(img.userInfo.iid,true)">取消关注</el-button>
                      <el-button type="primary" round v-else @click="followIt(img.userInfo.iid,false)">关注</el-button>
                    </span>
                    </div>
                  </div>
                </el-card>
              </div>
            </div>
            <el-pagination
                :page-size="9"
                :pager-count=7
                layout="prev, pager, next"
                :total="this.maxPageArtworks*9"
                @current-change="handleCurrentChangeArtworks">
            </el-pagination>
          </div>
          <div class="user" v-if="switchMode===false">
            <div v-if="this.userinfo.length===0" class="not-found">
              什么都没有找到呢...
            </div>
            <div v-else>
              <div v-for="(user,index) in userinfo" :key="index" class="user-card">
                <el-card shadow="hover" class="image-card">
                  <img
                      :src="user.userimage"
                      alt="用户头像"
                      style="float:left;border-radius: 50%;width: 180px;height: 180px"
                      @click="toUser(user.iid)">
                  <div style="float: left;margin-left: 50px;">
                    <div @click="toUser(user.iid)">uid：{{user.iid}}</div>
                    <div @click="toUser(user.iid)">昵称：{{user.nickname}}</div>
                    <div @click="toUser(user.iid)">个人简介：{{user.self}}</div>
                    <div class="user-artwork">
                      <div v-for="(view,index) in user.artworks" :key="index" style="width: 500px">
                        <el-image
                            :src="view.picture"
                            style="float: left;width: 160px;height: 100px;margin-left: 5px;margin-top: 15px"
                            lazy
                            @click="toArtworksInfo(view.pid)"></el-image>
                      </div>
                    </div>
                  </div>
                  <div style="float: left;margin-left: 200px;margin-top: 20px">
                    <el-button type="primary" round v-if="isFollowed(user.iid)" @click="followIt(user.iid,true)">取消关注</el-button>
                    <el-button type="primary" round v-else @click="followIt(user.iid,false)">关注</el-button>
                  </div>
                </el-card>
              </div>
            </div>
            <el-pagination
                :page-size="9"
                :pager-count=7
                layout="prev, pager, next"
                :total="this.maxPageUser*9"
                @current-change="handleCurrentChangeUser">
            </el-pagination>
          </div>
        </div>
      </el-main>
    </el-container>
  </div>
</template>

<script>
import axios from "axios";
import {Loading} from "element-ui";

export default {
  mounted() {
    this.searchWhat=this.$route.query.use
    this.mode()
  },
  created() {
    this.showLoading()
    this.getUser()
    this.getArtworks()
    this.getFollowed()
    this.getLoginUser()
  },
  data(){
    return{
      selectCon:'0',
      searchWhat:'',
      searcher:'',
      pageArtworks:1,
      pageUser:1,
      maxPageArtworks:0,
      maxPageUser:0,
      imgs:[],
      userinfo:[],
      follow:[],
      loginUsr:[],
      switchMode:true,
    }
  },
  methods:{
    //搜索用户（分页）
    getUser(){
      axios({
        method:'get',
        url:'api/search_user',
        params:{
          search:this.$route.query.searcher,
          page:this.pageUser
        }
      }).then((resp)=>{
        this.maxPageUser=resp.data.pages;
        this.userinfo=resp.data.records;
        console.log(this.userinfo)
      }).catch((err)=>{
        this.$router.push({name:'404page'})
        this.hideLoading()
      })
    },
    //搜索插画（分页）
    getArtworks(){
      axios({
        method:'get',
        url:'api/search_artworks',
        params:{
          token:localStorage.getItem("token"),
          search:this.$route.query.searcher,
          page:this.pageArtworks
        }
      }).then((resp)=>{
        this.maxPageArtworks=resp.data.pages;
        this.imgs=resp.data.records;
        this.hideLoading()
      }).catch((err)=>{
        this.$router.push("/wrong")
        this.hideLoading()
      })
    },
    //获取关注状态
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
    //获取当前登录用户信息
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
    //搜索用户，搜索插画模式切换
    mode(){
      if (this.searchWhat==='user'){
        this.switchMode=false
        this.selectCon='1'
      }
      if (this.searchWhat==='artwork'){
        this.switchMode=true
        this.selectCon='0'
      }
    },
    //跳转插画搜索
    toArtwork(){
      this.$router.push({
        path:'/search',
        query:{
          searcher:this.$route.query.searcher,
          use:'artwork'
        }
      }).then().catch((err)=>{
        console.log(err)
      }).catch((error)=>{
        console.log(error)
      })
    },
    //跳转用户搜索
    toSearchUser(){
      this.$router.push({
        path:'/search',
        query:{
          searcher:this.$route.query.searcher,
          use:'user'
        }
      }).then().catch((err)=>{
        console.log(err)
      }).catch((error)=>{
        console.log(error)
      })
    },
    //点击插画分页按钮时自动返回页面顶部
    handleCurrentChangeArtworks(page){
      this.pageArtworks=page;
      this.getArtworks();
      window.scrollTo(0,0)
    },
    //点击用户分页按钮时自动返回页面顶部
    handleCurrentChangeUser(page){
      this.pageUser=page;
      this.getUser();
      window.scrollTo(0,0)
    },
    //跳转插画详细信息
    toArtworksInfo(id){
      this.$router.push({
        path:'/artworks',
        query:{
          pid:id
        }
      })
    },
    //跳转用户个人资料
    toUser(id){
      this.$router.push({
        path:'/user',
        query:{
          uid:id
        }
      })
    },
    //判断是否关注
    isFollowed(uid){
      return this.follow.includes(uid)
    },
    //插画收藏（取消收藏）
    favoriteIt(id,liked){
      if (liked===true){
        axios({
          method:'get',
          url:'api/favorite',
          params:{
            token:localStorage.getItem("token"),
            pid:id
          }
        }).then((resp)=>{
          if (resp.data===true){
            this.$message.success("取消收藏成功！")
            for (let i=0;i<this.imgs.length;i++){
              if (this.imgs[i].pid===id){
                this.imgs[i].liked=false
                this.imgs[i].likenum-=1
              }
            }
          }
          else if(resp.data===false){
            this.$message.error("取消收藏失败！")
          }
        })
      }
      else if(liked===false){
        axios({
          method:'get',
          url:'api/favorite',
          params:{
            token:localStorage.getItem("token"),
            pid:id
          }
        }).then((resp)=>{
          if (resp.data===true){
            this.$message.success("收藏成功！")
            for (let i=0;i<this.imgs.length;i++){
              if (this.imgs[i].pid===id){
                this.imgs[i].liked=true
                this.imgs[i].likenum+=1
              }
            }
          }
          else if(resp.data===false){
            this.$message.error("收藏失败！")
          }
        })
      }
    },
    //用户关注（取消关注）
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
    //显示加载页面
    showLoading(){
      this.loading=true
      Loading.service({
        lock:true,
        text:'加载中...',
        background: 'rgb(255,255,255)'
      })
    },
    //隐藏加载页面
    hideLoading(){
      this.loading = false
      Loading.service().close()
    }
  }
}
</script>

<style scoped>
@import "@/assets/font/font.css";
.search-card{

}
.image-card{
  margin-top: 20px;
  height: 220px;
  cursor: pointer;
}
.artist{
  float: left;
  margin-left:  50px;
  margin-top: 38px;
}
.not-found{
  font-family: "font_aigei_com",sans-serif;
  font-weight: bolder;
  font-size: large;
}
</style>