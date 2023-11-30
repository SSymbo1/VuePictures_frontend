<template>
  <el-container>
    <el-backtop></el-backtop>
    <el-main>
      <div class="function_bar">
        <el-input v-model="keyword" maxlength="32" placeholder="请输入搜索关键字" prefix-icon="el-icon-search" style="width: 300px" clearable></el-input>
        <el-button type="primary" round icon="el-icon-search" @click="searchSubmitArtworks" style="margin-left: 10px">搜索</el-button>
        <el-button type="danger" round icon="el-icon-delete" @click="delAllSubmit">清空投稿</el-button>
      </div>
      <div class="artworks" v-if="artworks.length!==0">
        <div class="artworks_iteration" v-for="(artwork,index) in artworks" :key="index">
          <transition name="el-fade-in-linear" appear>
            <el-card
                shadow="hover"
                :body-style="{padding:'0px'}"
                style="margin-left: 15px;cursor: pointer;height: 250px">
              <el-image
                  :src="artwork.picture"
                  fit="cover"
                  style="width: 260px;height: 150px;"
                  lazy @click="toArtworks(artwork.pid)"/>
              <div class="button-container">
                <el-button type="primary" round @click="openImageChangeWindow(artwork.pid)" title="修改投稿图源"><i class="el-icon-edit"></i></el-button>
              </div>
              <div style="padding: 14px">
                <span style="position:relative;top: -40px">{{artwork.subtitle}}</span>
                <div style="position: relative;top: -40px">{{artwork.createtimeString}}</div>
                <div class="bottom clearfix" style="position: relative;top: -40px">
                  <i class="el-icon-star-on" style="color: rgb(78,158,253);margin-top: 5px" title="收藏数">{{artwork.likenum}}</i>
                  <i class="el-icon-view" style="color: rgb(78,158,253);margin-left: 10px" title="点击数">{{artwork.view}}</i>
                  <el-button type="text" class="delete" icon="el-icon-delete" style="margin-right: -5px" @click="delSubmit(artwork.pid)" title="删除投稿"></el-button>
                  <el-button type="text" class="edit" icon="el-icon-edit" @click="openInfoChangeWindow(artwork.pid,artwork.subtitle,artwork.introduce)" title="修改投稿详细信息"></el-button>
                </div>
              </div>
            </el-card>
          </transition>
        </div>
      </div>
      <div class="not-submit" v-else>
        <span>没有找到您的投稿，快来投稿吧！</span>
      </div>
      <el-pagination
          :page-size="9"
          :pager-count=7
          layout="prev, pager, next"
          :total="this.maxPageSubmit*9"
          @current-change="handleCurrentChangeUser"
          style="margin-top: 15px">
      </el-pagination>
    </el-main>
    <el-dialog
        title="插画信息修改"
        :visible.sync="update_window_visible"
        width="500px">
      <el-form
          ref="artwork"
          :model="artwork"
          :rules="rules">
        <el-form-item label="插画标题" prop="subtitle">
          <el-input v-model="artwork.subtitle" placeholder="请输入插画标题" maxlength="32" show-word-limit clearable/>
        </el-form-item>
        <el-form-item label="插画描述" prop="introduce">
          <el-input type="textarea" v-model="artwork.introduce" placeholder="请描述您的作品" maxlength="150" show-word-limit resize="none" rows="7"/>
        </el-form-item>
        <el-form-item>
          <div style="text-align: right">
            <el-button type="primary" round icon="el-icon-upload" @click="submitInfoChange">投稿</el-button>
            <el-button type="danger" round icon="el-icon-delete" @click="reset">重置</el-button>
          </div>
        </el-form-item>
      </el-form>
    </el-dialog>
    <el-dialog
        title="插画图源修改"
        :visible.sync="update_artwork_source_visible"
        width="400px">
      <el-upload
          drag
          action="api/submitImageChange"
          :headers="header"
          :before-upload="beforeImageChange"
          :on-success="handleSuccess"
          :file-list="artworkFile"
          :auto-upload="true"
          :multiple="false"
          :limit="1"
          accept=".jpg,.png,JPG,.PNG,.JPEG,.jpeg">
        <i class="el-icon-upload"></i>
        <div class="el-upload__text">将图片拖到此处，或<em>点击上传</em></div>
        <div class="el-upload__tip" slot="tip">只能上传jpg/png照片，且不超过30MB</div>
      </el-upload>
    </el-dialog>
  </el-container>
</template>

<script>
import {Loading} from "element-ui";
import axios from "axios";

export default {
  created() {
    this.showLoading()
    this.getUserInfo()
    this.searchSubmitArtworks()
    this.hideLoading()
  },
  data(){
    return{
      artwork:{
        pid:'',
        subtitle:'',
        introduce:''
      },
      rules:{
        subtitle:[
          { required: true, message: '作品标题不得为空！', trigger: 'blur' },
          { max: 32, message: '作品标题不得超过32位！', trigger: 'blur' }
        ],
        introduce:[
          { required: true, message: '插画介绍不得为空！', trigger: 'blur' },
          { max: 150, message: '插画介绍不得超过150位！', trigger: 'blur' }
        ]
      },
      header:{
        pid:''
      },
      artworkFile:[],
      update_artwork_source_visible:false,
      update_window_visible:false,
      captcha:'',
      keyword:'',
      artworks:[],
      userinfo:[],
      maxPageSubmit:0,
      pageSubmit:1,
    }
  },
  methods:{
    searchSubmitArtworks(){
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
    toArtworks(pid){
      this.$router.push({
        path:'/artworks',
        query:{
          pid:pid
        }
      })
    },
    openInfoChangeWindow(pid,subtitle,introduce){
      this.artwork.pid=pid
      this.artwork.subtitle=subtitle
      this.artwork.introduce=introduce
      this.update_window_visible=!this.update_window_visible
    },
    openImageChangeWindow(pid){
      this.header.pid=pid
      this.update_artwork_source_visible=!this.update_artwork_source_visible
    },
    beforeImageChange(file){
      const fileType=file.name.split('.').pop();
      if (fileType!=='jpg'&&fileType!=='png'&&fileType!=='JPG'){
        this.$message({
          showClose:true,
          message:'背景图片必须是.jpg或.png类型！',
          type:"error"
        })
        return false;
      }
      if (file.size/1024/1024>30){
        this.$message({
          showClose:true,
          message:'背景图片大小不能超过30MB！',
          type:"error"
        })
        return false
      }
    },
    handleSuccess(res, file) {
      this.artworkFile.push(file)
      this.$message.success("插画图源修改成功！")
      this.artworkFile=[];
      this.update_artwork_source_visible=!this.update_artwork_source_visible
      this.searchSubmitArtworks()
    },
    submitInfoChange(){
      this.$refs.artwork.validate((validate)=>{
        if (validate){
          axios({
            method:'post',
            url:'api/submitInfoChange',
            data:{
              pid:this.artwork.pid,
              subtitle:this.artwork.subtitle,
              introduce:this.artwork.introduce
            }
          }).then((resp)=>{
            if (resp.data.code===7777){
              this.$message.success(resp.data.message)
            }else {
              this.$message.error(resp.data.message)
            }
            this.update_window_visible=!this.update_window_visible
            this.searchSubmitArtworks()
          })
        }else {
          this.$message.error("请按要求填写表单！")
        }
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
        roundButton:true,
      }).then(()=>{
        if (this.userinfo[0].email==="none"){
          this.$message({
            type:'error',
            message:'请先在个人资料中绑定邮箱！'
          })
        }else {
          axios({
            method:'get',
            url:'api/delete_email',
            params:{
              token:localStorage.getItem("token"),
              email:this.userinfo[0].email
            }
          }).then((resp)=>{
            this.captcha=resp.data.data.captcha
          })
          this.$prompt("已发送验证码至"+this.userinfo[0].email+",请输入验证码","安全验证",{
            confirmButtonText:'确认',
            cancelButtonText:'取消',
            roundButton:true,
            type:'warning'
          }).then(({value})=>{
            if (value!==this.captcha){
              this.$message({
                type:'error',
                message:'验证码不匹配！'
              })
            }else {
              axios({
                method:"post",
                url:'api/delAllSubmit',
                data:{
                  'token':localStorage.getItem("token"),
                  'captcha':this.captcha,
                  'inputCaptcha':value
                }
              }).then((resp)=>{
                if (resp.data.code===7777){
                  this.$message.success(resp.data.message)
                  this.searchSubmitArtworks()
                }else {
                  this.$message.error(resp.data.message)
                }
              }).catch((err)=>{})
            }
          }).catch(()=>{})
        }
      }).catch(()=>{})
    },
    reset(){
      this.artwork.subtitle=""
      this.artwork.introduce=""
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
      this.showLoading()
      this.pageSubmit=page;
      this.searchSubmitArtworks()
      window.scrollTo(0,0)
    },
  }
}
</script>

<style scoped>
@import "@/assets/font/font.css";
.function_bar{
  margin-left: 15px;
}
.artworks {
  display: flex;
  flex-wrap: wrap;
  overflow: auto;
  align-items: center;
  justify-content: flex-start;
}
.artworks_iteration{
  margin-top: 20px;
}
.bottom {
  margin-top: 1px;
  line-height: 10px;
}
.not-submit{
  font-family: "font_aigei_com",sans-serif;
  font-weight: bolder;
  font-size: large;
  margin-top: 20px;
  margin-left: 15px;
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