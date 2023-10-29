<template>
  <el-container>
    <el-backtop></el-backtop>
    <el-header height="310px">
      <el-carousel :interval="4000" indicator-position="outside" arrow="hover" trigger="click">
        <el-carousel-item v-for="(hot,index) in dailyHotArtworks" :key="index">
          <el-image
              :src="hot.picture"
              fit="cover"
              style="height: 100%;width: 100%">
          </el-image>
        </el-carousel-item>
      </el-carousel>
    </el-header>
    <el-main>
      <div class="user-need-card">
        <div class="hot-card">
          <span class="label-hot">热门：</span>
          <div class="label-image">
            <el-carousel :interval="6000" arrow="hover">
              <el-carousel-item v-for="(hot,index) in hots" :key="index">
                <el-image
                    :src="hot.picture"
                    fit="cover"
                    style="height: 100%;width: 100%"></el-image>
              </el-carousel-item>
            </el-carousel>
          </div>
        </div>
        <div class="user-follow-update-card">
          <span class="label-updates">动态：</span>
        </div>
        <div class="user-card">
          <div class="user-card-head-image">
            <img :src="user.userimage" alt="" style="border-radius: 50%;width: 100px;height: 100px" :title="user.nickname">
          </div>
          <div class="user-card-name">
            <span>{{user.nickname}}</span>
          </div>
          <div class="user-card-follow">
            <span>关注:{{fans[1]}}</span>
            <el-divider direction="vertical"></el-divider>
            <span>粉丝:{{fans[0]}}</span>
          </div>
          <div class="user-card-self-info">
            <span>{{user.self}}</span>
          </div>
        </div>
      </div>
      <span class="label-hope-you-like">猜你喜欢：</span>
      <div class="you-like">
        <div v-for="(image,index) in imgs" :key="index" class="like-card">
          <el-card shadow="hover" :body-style="{padding:'0px'}" class="image-card">
            <el-image
                :src="image.picture"
                fit="cover"
                style="width: 260px;height: 150px;cursor: pointer"
                lazy
                @click="toArtworksInfo(image.pid)"></el-image>
            <div style="padding: 14px" >
              <span @click="toArtworksInfo(image.pid)" style="cursor: pointer">{{image.subtitle}}</span>
              <div class="bottom clearfix">
                <el-button type="text" class="button" v-if="image.liked" icon="el-icon-star-on" @click="favoriteIt(image.pid,image.liked)"></el-button>
                <el-button type="text" class="button" v-else icon="el-icon-star-off" @click="favoriteIt(image.pid,image.liked)"></el-button>
              </div>
            </div>
          </el-card>
        </div>
      </div>
    </el-main>
  </el-container>
</template>

<script>
import axios from "axios";
import {Loading} from "element-ui";

export default {
  mounted() {
    window.addEventListener("scroll",this.rolling)
    this.showLoading()
    this.getArtworks(1);
    axios({
      method:'get',
      url:'api/fans_info',
      params:{
        token:localStorage.getItem("token")
      }
    }).then((resp)=>{
      this.fans=resp.data
    })
    axios({
      method:'get',
      url:'api/getHeaderImg'
    }).then((resp)=>{
      this.dailyHotArtworks=resp.data
    })
    axios({
      method:'get',
      url:'api/getHotImg'
    }).then((resp)=>{
      this.hots=resp.data
    })
    axios({
      method:'get',
      url:'api/user_info',
      params:{
        token:localStorage.getItem("token")
      }
    }).then((resp)=>{
      this.user=resp.data[0]
    })
    this.hideLoading()
  },
  destroyed() {
    window.removeEventListener("scroll",this.rolling)
  },
  beforeDestroy() {
    window.removeEventListener("scroll",this.rolling)
  },
  data(){
    return{
      user:{
        iid: 0,
        background: '',
        userimage: '',
        nickname: '',
        self:'',
        sex: '',
        birthday:0,
        email: ''
      },
      favoriteButton:'el-icon-star-off',
      page:1,
      maxPage:0,
      favorite:[],
      dailyHotArtworks:[],
      imgs:[],
      fullImage:[],
      fans:[],
      hots:[]
    }
  },
  methods:{
    getArtworks(page){
      axios({
        method:'get',
        url:'api/getArtworksP',
        params:{
          token:localStorage.getItem("token"),
          page:page
        }
      }).then((resp)=>{
        this.maxPage=resp.data.pages
        this.imgs=this.imgs.concat(resp.data.records)
      })
    },
    toArtworksInfo(id){
      this.$router.push({
        path:'/artworks',
        query:{
          pid:id
        }
      })
    },
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
              }
            }
          }
          else if(resp.data===false){
            this.$message.error("收藏失败！")
          }
        })
      }
    },
    rolling(){
      const scrollTop = this.getScrollTop();
      const clientHeight = this.getClientHeight();
      const scrollHeight = this.getScrollHeight();
      //如果满足公式则，确实到底了
      if(scrollTop+clientHeight+3 >= scrollHeight){
        if (this.page<=this.maxPage){
          this.page++
          this.getArtworks(this.page)
          if (this.page===this.maxPage){
            this.page=0
          }
        }
        else {
          this.getArtworks(this.page)
        }
      }
    },
    getClientHeight() {
      let clientHeight = 0;
      if (document.body.clientHeight && document.documentElement.clientHeight) {
        clientHeight = Math.min(document.body.clientHeight, document.documentElement.clientHeight)
      } else {
        clientHeight = Math.max(document.body.clientHeight, document.documentElement.clientHeight)
      }
      return clientHeight
    },
    getScrollHeight() {
      return Math.max(document.body.scrollHeight, document.documentElement.scrollHeight)
    },
    getScrollTop() {
      let scrollTop = 0;
      if (document.documentElement && document.documentElement.scrollTop) {
        scrollTop = document.documentElement.scrollTop
      } else if (document.body) {
        scrollTop = document.body.scrollTop
      }
      return scrollTop
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
    }
  }
}
</script>

<style scoped>
@import "@/assets/font/font.css";
el-main{
  display: flex;
  flex-wrap: wrap;
  overflow: auto;
  height: 1000px;
}
.el-carousel__item h3 {
  color: #475669;
  font-size: 18px;
  opacity: 0.75;
  line-height: 300px;
  margin: 0;
}
.user-need-card{
  margin-top: 25px;
  height: 310px;
  display: flex;
  flex-wrap: wrap;
  justify-content: space-between;
}
.user-card{
  flex: 1 0 9%;
  height: 310px;
  border-radius: 8%;
  margin-left: 15px;
  background-color: #f5f5f5
}
.user-card-head-image{
  text-align: center;
  padding-top: 30px;
}
.user-card-name{
  text-align: center;
  padding-top: 20px;
}
.user-card-self-info{
  text-align: center;
  padding-top: 20px;
}
.user-card-follow{
  text-align: center;
  padding-top: 20px;
}
.hot-card{
  flex: 1 0 35%;
  height: 310px;
}
.user-follow-update-card{
  flex: 1 0 30%;
  height: 310px;
  margin-left: 15px;
  border-radius: 5%;
  background-color: #f5f5f5
}
.label-hot{
  display: flex;
  margin-top: -30px;
  margin-left: 30px;
  font-family: "font_aigei_com",sans-serif;
  font-size: 25px;
  font-weight: bold;
  color: #333;
}
.label-updates{
  display: flex;
  margin-top: -30px;
  margin-left: 30px;
  font-family: "font_aigei_com",sans-serif;
  font-size: 22px;
  font-weight: bold;
  color: #333;
}
.label-image{
  margin-top: 5px;
  padding-left: 5px;
  padding-right: 5px;
  flex: 1 0 35%;
  height: 310px;
  border-radius: 5%;
}
.you-like{
  display: flex;
  flex-wrap: wrap;
  overflow: auto;
  align-items: center;
  justify-content: flex-start;
}
.label-hope-you-like{
  display: flex;
  font-family: "font_aigei_com",sans-serif;
  margin-top: 10px;
  margin-left: 30px;
  font-size: 22px;
  font-weight: bold;
  color: #333;
}
.image-card{
  margin-left: 10px;
  height: 240px;
  width: 260px;
}
.like-card{
  padding-top: 10px;
}

.bottom {
  margin-top: 13px;
  line-height: 12px;
}
.button {
  padding: 0;
  float: right;
}
.clearfix:before,
.clearfix:after {
  display: table;
  content: "";
}
.clearfix:after {
  clear: both
}
</style>