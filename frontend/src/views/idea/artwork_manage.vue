<template>
  <el-container>
    <el-backtop></el-backtop>
    <el-main v-if="this.artworks.length!==0">
      <div class="function_bar">
        <el-input v-model="keyword" maxlength="32" placeholder="请输入搜索关键字" prefix-icon="el-icon-search" style="width: 300px"></el-input>
        <el-button type="primary" round icon="el-icon-search" @click="searchSubmitArtworks" style="margin-left: 5px">搜索</el-button>
        <el-button type="danger" round icon="el-icon-delete" @click="delAllSubmit">清空投稿</el-button>
      </div>
      <div class="artworks">
        <div class="artworks_iteration" v-for="(artwork,index) in artworks" :key="index">
          <el-card
              shadow="hover"
              :body-style="{padding:'0px'}"
              style="height: 250px;margin-left: 15px">
            <el-image
                :src="artwork.picture"
                fit="cover"
                style="width: 260px;height: 150px;"
                lazy/>
            <div class="button-container">
              <el-button type="primary" round><i class="el-icon-edit"></i></el-button>
            </div>
            <div style="padding: 14px">
              <span style="position:relative;top: -40px">{{artwork.subtitle}}</span>
              <div style="position: relative;top: -40px">{{artwork.createtimeString}}</div>
              <div class="bottom clearfix" style="position: relative;top: -40px">
                <el-button type="text" class="delete" icon="el-icon-delete" @click="delSubmit(artwork.pid)"></el-button>
                <el-button type="text" class="edit" icon="el-icon-edit"></el-button>
              </div>
            </div>
          </el-card>
        </div>
      </div>
      <el-pagination
          :page-size="9"
          :pager-count=7
          layout="prev, pager, next"
          :total="this.maxPageSubmit*9"
          @current-change="handleCurrentChangeUser">
      </el-pagination>
    </el-main>
    <el-main v-else>
      <div class="not-submit">您还没有投过稿，快来投稿吧！</div>
    </el-main>
  </el-container>
</template>

<script>
import {Loading} from "element-ui";
import axios from "axios";

export default {
  created() {
    this.getUserInfo()
    this.searchSubmitArtworks()
    this.hideLoading()
  },
  data(){
    return{
      keyword:'',
      artworks:[],
      userinfo:[],
      maxPageSubmit:0,
      pageSubmit:1,
    }
  },
  methods:{
    searchSubmitArtworks(){
      this.showLoading()
      axios({
        method:'get',
        url:'api/search_submit',
        params:{
          token:localStorage.getItem("token"),
          keyword:this.keyword,
          page:this.pageSubmit
        }
      }).then((resp)=>{
        this.artworks=resp.data.records
        this.maxPageSubmit=resp.data.pages
        this.hideLoading()
      })
    },
    getUserInfo(){
      axios({
        method:'get',
        url:'api/user_info',
        params:{
          token:localStorage.getItem("token")
        }
      }).then((resp)=>{
        this.userinfo=resp.data
      })
    },
    delSubmit(pid){
      this.$confirm("是否删除该投稿？（注意：不可撤销！）","删除投稿",{
        confirmButtonText:"删除",
        cancelButtonText:"取消",
        type:"warning",
        roundButton:true
      }).then(()=>{
        axios({
          method:'get',
          url:'api/delSubmit',
          params:{
            token:localStorage.getItem("token"),
            pid:pid
          }
        }).then((resp)=>{
          if (resp.data.code===7777){
            this.$message.success(resp.data.message)
          }else {
            this.$message.error(resp.data.message)
          }
          this.searchSubmitArtworks()
        })
      }).catch(()=>{})
    },
    delAllSubmit(){
      this.$confirm("危险操作:是否要删除所有投稿？（注意：执行该操作需要您绑定邮箱，我们会向您绑定的邮箱发送验证信息）","危险操作",{
        confirmButtonText:"",
        cancelButtonText:"",
        type:'warning',
        roundButton:true
      }).then(()=>{
        if (this.userinfo[0].email==="none"){
          this.$message({
            type:'error',
            message:'请先在个人资料中绑定邮箱！'
          })
        }
      }).catch(()=>{
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
    handleCurrentChangeUser(page){
      this.pageSubmit=page;
      this.searchSubmitArtworks()
      window.scrollTo(0,0)
      this.hideLoading()
    },
  }
}
</script>

<style scoped>
@import "@/assets/font/font.css";
.function_bar{
}
.artworks {
  display: flex;
  flex-wrap: wrap;
  overflow: auto;
  align-items: center;
  justify-content: flex-start;
}
.artworks_iteration{
  margin-top: 15px;
}
.bottom {
  margin-top: 1px;
  line-height: 10px;
}
.not-submit{
  font-family: "font_aigei_com",sans-serif;
  font-weight: bolder;
  font-size: large;
}
.clearfix:before,
.clearfix:after {
  display: table;
  content: "";
}
.clearfix:after {
  clear: both
}
.delete {
  padding: 5px;
  float: right;
  margin-right: 12px;
}
.edit {
  padding: 5px;
  float: right;
}
.button-container {
  position: relative;
  bottom: 50px;
  left: 195px;
}
</style>