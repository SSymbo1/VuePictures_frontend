<template>
  <el-container>
    <el-backtop></el-backtop>
    <el-header>
      <el-page-header @back="goBack" content="历史浏览" style="margin-bottom: 5px"></el-page-header>
    </el-header>
    <el-main>
      <div class="date-filter">
        <el-date-picker
            type="date"
            placeholder="选择日期"
            v-model="date"
            value-format="yyyy-MM-dd">
        </el-date-picker>
        <el-button type="primary" style="margin-left: 5px" round @click="searchHistory()">搜索</el-button>
        <el-button type="danger" style="margin-left: 5px" round @click="deleteAllHistory()">清空历史</el-button>
      </div>
      <div class="history-card">
        <div v-if="this.history.length===0" class="not-found">
          什么足迹也没有留下呢...
        </div>
        <div v-for="(img,index) in history" :key="index" class="history-iteration" v-else>
          <el-card
              shadow="hover"
              :body-style="{padding:'0px'}"
              class="history-info">
            <el-image
                :src="img.artworks.picture"
                fit="cover"
                style="width: 260px;height: 150px;cursor: pointer"
                lazy
                @click="toArtworksInfo(img.artworks.pid)">
            </el-image>
            <div style="padding: 14px">
              <span style="cursor: pointer">{{img.artworks.subtitle}}</span>
              <div style="cursor: pointer">{{img.viewtime}}</div>
              <div class="bottom clearfix">
                <el-button type="text" class="button" v-if="img.artworks.liked" icon="el-icon-star-on" @click="favoriteIt(img.artworks.pid,img.artworks.liked)"></el-button>
                <el-button type="text" class="button" v-else icon="el-icon-star-off" @click="favoriteIt(img.artworks.pid,img.artworks.liked)"></el-button>
                <el-button type="text" class="delete" icon="el-icon-delete" @click="deleteHistory(img.artworks.pid)"></el-button>
              </div>
            </div>
          </el-card>
        </div>
      </div>
    </el-main>
  </el-container>
</template>

<script>
import {Loading} from "element-ui";
import axios from "axios";

export default {
  mounted() {
    this.showLoading()
    this.getHistory()
  },
  data(){
    return{
      date:null,
      history:[],
    }
  },
  methods:{
    goBack(){
      this.$router.back()
    },
    getHistory(){
      axios({
        method:"get",
        url:'api/historyUid',
        params:{
          token:localStorage.getItem("token")
        }
      }).then((resp)=>{
        this.history=resp.data
        this.constDate()
        this.hideLoading()
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
    searchHistory(){
      if (this.date===null){
        this.getHistory()
      }else {
        const date=new Date(this.date).valueOf()
        axios({
          method:'get',
          url:"api/historyUidDate",
          params:{
            token:localStorage.getItem("token"),
            viewtime:date
          }
        }).then((resp)=>{
          this.history=resp.data
          this.constDate()
        }).catch((err)=>{
        })
      }
      console.log(this.date)
    },
    deleteAllHistory(){
      this.$confirm("是否删除所有历史记录？（注意：此操作不可逆）","删除所有历史记录",{
        confirmButtonText:'确认删除',
        cancelButtonText:'取消',
        type:"warning"
      }).then(()=>{
        axios({
          method:'get',
          url:'api/deleteUserHistory',
          params:{
            token:localStorage.getItem("token")
          }
        }).then((resp)=>{
          if (resp.data.code===4446){
            this.$message({
              type:"success",
              message:"历史记录已清空！",
            })
            this.getHistory()
          }
          else if(resp.data.code===4443){
            this.$message({
              type:"error",
              message:"操作异常！"
            })
          }
        })
      }).catch(()=>{
      })
    },
    deleteHistory(pid){
      this.$confirm("是否删除这条历史记录？","删除历史记录",{
        confirmButtonText:'删除',
        cancelButtonText:'取消',
        type:'warning'
      }).then(()=>{
        axios({
          method:"post",
          url:'api/deleteHistory',
          data:{
            token:localStorage.getItem("token"),
            pid:pid
          }
        }).then((resp)=>{
          if (resp.data.code===4446){
            this.$message({
              type:"success",
              message:"删除成功！",
            })
            this.getHistory()
          }
          else if(resp.data.code===4443){
            this.$message({
              type:"error",
              message:"删除失败！"
            })
          }
        }).catch((err)=>{
        })
      }).catch(()=>{
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
            for (let i=0;i<this.history.length;i++){
              if (this.history[i].artworks.pid===id){
                this.history[i].artworks.liked=false
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
            for (let i=0;i<this.history.length;i++){
              if (this.history[i].artworks.pid===id){
                this.history[i].artworks.liked=true
              }
            }
          }
          else if(resp.data===false){
            this.$message.error("收藏失败！")
          }
        })
      }
    },
    constDate(){
      for (var i = 0; i < this.history.length; i++){
        const date=new Date(this.history[i].viewtime)
        let Y = date.getFullYear(),
            M = (date.getMonth() + 1 < 10 ? '0' + (date.getMonth() + 1) : date.getMonth() + 1),
            D = (date.getDate() < 10 ? '0' + (date.getDate()) : date.getDate()),
            h = (date.getHours() < 10 ? '0' + (date.getHours()) : date.getHours()),
            m = (date.getMinutes() < 10 ? '0' + (date.getMinutes()) : date.getMinutes()),
            s = (date.getSeconds() < 10 ? '0' + (date.getSeconds()) : date.getSeconds());
        this.history[i].viewtime=Y + '-' + M + '-' + D + ' ' + h + ':' + m + ':' + s
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
.date-filter{
  text-align: right;
}
.history-card{
  display: flex;
  flex-wrap: wrap;
  overflow: auto;
  align-items: center;
  justify-content: flex-start;
}
.history-info{
  margin-left: 10px;
  height: 240px;
  width: 260px;
}
.history-iteration{
  margin-top: 15px;
}
.not-found{
  font-family: "font_aigei_com",sans-serif;
  font-weight: bolder;
  font-size: large;
  margin-top: 20px;
}
.button {
  padding: 0;
  float: right;
}
.delete{
  padding: 0;
  float: right;
  margin-right: 15px;
}
.bottom {
  margin-top: 1px;
  line-height: 10px;
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