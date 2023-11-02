<template>
  <el-container>
    <el-header height="250px">
      <el-page-header @back="goBack" :content="user.nickname" style="margin-bottom: 5px"></el-page-header>
      <div style="height: 250px;position: relative">
        <el-image
            style="width: 100%;height: 100%"
            :src="user.background"
            fit="cover"></el-image>
        <div class="button-container" style="position: absolute; bottom: 0; right: 0;">
          <el-button v-show="buttonShow" type="primary" round @click="updateBkDialog" class="chb-button"><i class="el-icon-edit"></i></el-button>
        </div>
      </div>
    </el-header>
    <el-main>
      <div class="userSelfCard">
        <div class="userHead">
          <img
              :src="user.userimage"
              alt=""
              style="border-radius: 50%;width: 280px;height: 280px;">
          <div class="button-container" style="position: absolute; bottom: 21px; right: 0;">
            <el-button v-show="buttonShow" type="primary" circle @click="updateUserImageDialog" class="chb-button"><i class="el-icon-edit"></i></el-button>
          </div>
        </div>
        <div class="userInfo">
          <div>
            <span>昵称：{{user.nickname}}</span>
            <el-divider direction="vertical"></el-divider>
            <span>性别：{{user.sex}}</span>
            <el-divider direction="vertical"></el-divider>
            <span>生日：{{user.birthday}}</span>
          </div>
          <div>
            <p>电子邮件：{{user.email}}</p>
          </div>
          <div>
            <p>个人简介：{{user.self}}</p>
          </div>
          <div>
            <el-button v-show="buttonShow" type="primary" round @click="updateUserSelfDialog" >修改个人资料</el-button>
            <el-button v-show="!buttonShow" type="primary" round @click="follow">{{followButton}}</el-button>
          </div>
        </div>
      </div>
      <div>
        <el-menu
            mode="horizontal"
            default-active="0">
          <el-menu-item index="0" @click="switchMode=true" >作品</el-menu-item>
          <el-menu-item index="1" @click="toFavorite">收藏</el-menu-item>
        </el-menu>
      </div>
      <div class="data-card">
        <div v-if="switchMode===true" v-for="(work,index) in works" :key="index" class="card">
          <el-card shadow="hover" :body-style="{padding:'0px'}" class="image-card">
            <el-image
                :src="work.picture"
                fit="cover"
                style="width: 260px;height: 150px;cursor: pointer"
                lazy
                @click="toArtworksInfo(work.pid)"></el-image>
            <div style="padding: 14px" >
              <span @click="toArtworksInfo(work.pid)" style="cursor: pointer">{{work.subtitle}}</span>
              <div class="bottom clearfix">
                <el-button type="text" class="star-button" v-if="work.liked" icon="el-icon-star-on" @click="favoriteIt(work.pid,work.liked)"></el-button>
                <el-button type="text" class="star-button" v-else icon="el-icon-star-off" @click="favoriteIt(work.pid,work.liked)"></el-button>
              </div>
            </div>
          </el-card>
        </div>
        <div v-if="switchMode===false" v-for="(favor,index) in favors" :key="index" class="card">
          <el-card shadow="hover" :body-style="{padding:'0px'}" class="image-card">
            <el-image
                :src="favor.picture"
                fit="cover"
                style="width: 260px;height: 150px;cursor: pointer"
                lazy
                @click="toArtworksInfo(favor.pid)"></el-image>
            <div style="padding: 14px" >
              <span @click="toArtworksInfo(favor.pid)" style="cursor: pointer">{{favor.subtitle}}</span>
              <div class="bottom clearfix">
                <el-button type="text" class="star-button" v-if="favor.liked" icon="el-icon-star-on" @click="favoriteIt(favor.pid,favor.liked)"></el-button>
                <el-button type="text" class="star-button" v-else icon="el-icon-star-off" @click="favoriteIt(favor.pid,favor.liked)"></el-button>
              </div>
            </div>
          </el-card>
        </div>
      </div>
    </el-main>
    <el-footer>
    </el-footer>
    <el-dialog
        :title="dialogTitle"
        :visible.sync="updateBkVisible"
        width="400px">
      <el-upload
          drag
          :action="updateUrl"
          :headers="header"
          :before-upload="beforeBkImgUpload"
          :on-success="handleSuccess"
          :auto-upload="true"
          :file-list="userBkList"
          :limit="1"
          :multiple="false">
        <i class="el-icon-upload"></i>
        <div class="el-upload__text">将图片拖到此处，或<em>点击上传</em></div>
        <div class="el-upload__tip" slot="tip">只能上传jpg/png照片，且不超过5MB</div>
      </el-upload>
    </el-dialog>
    <el-dialog
        :title="dialogTitle"
        :visible.sync="updateSelfVisible"
        width="500px">
      <el-form
          ref="userForm"
          :model="userForm"
          label-width="55px"
          :rules="rules">
        <el-form-item label="昵称" prop="nickname">
          <el-input v-model="userForm.nickname" placeholder="请输入昵称"></el-input>
        </el-form-item>
        <el-form-item label="性别" prop="sex">
          <el-select v-model="userForm.sex" placeholder="请选择">
            <el-option label="男" value="men"></el-option>
            <el-option label="女" value="women"></el-option>
            <el-option label="无" value="none"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="生日" prop="date">
          <el-date-picker
              type="date"
              placeholder="选择日期"
              v-model="date"
              value-format="yyyy-MM-dd"></el-date-picker>
        </el-form-item>
        <el-form-item label="邮箱" prop="email">
          <el-input v-model="userForm.email" placeholder="请输入邮箱"></el-input>
        </el-form-item>
        <el-form-item label="介绍" prop="self">
          <el-input
              type="textarea"
              placeholder="介绍下你自己"
              rows="2"
              v-model="userForm.self"
              maxlength="80"
              show-word-limit></el-input>
        </el-form-item>
        <div style="text-align: right">
          <el-button type="primary" round @click="submitSelfChange">提交</el-button>
          <el-button round @click="updateUserSelfDialog">取消</el-button>
        </div>
      </el-form>
    </el-dialog>
  </el-container>
</template>

<script>
import axios, {options} from "axios";
import {Loading} from "element-ui";

export default {
  data() {
    return {
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
      userForm:{
        nickname:'',
        self:'',
        sex:'',
        birthday:0,
        email:'',
      },
      rules:{
        nickname:[
          {required:true,message:"请输入昵称!",trigger:'blur'},
          {max:15,message:"昵称不得大于15！",trigger:'blur'}
        ],
        email:[
          {max:30,message:"邮箱长度不能大于30！",trigger:'blur'}
        ],
      },
      header:{
        'Auth':localStorage.getItem("token")
      },
      userBkList:[],
      works:[],
      favors:[],
      dialogTitle:'',
      updateUrl:'',
      date:'',
      logUid:0,
      pageUid:0,
      followButton:'',
      switchMode:true,
      buttonShow:false,
      updateBkVisible:false,
      updateSelfVisible:false,
    }
  },
  created() {
    this.showLoading()
    this.getWorks()
    this.getFavorite()
    axios({
      method:'get',
      url:'api/user_info_id',
      params:{
        uid:this.$route.query.uid
      }
    }).then((resp)=>{
      this.pageUid=this.$route.query.uid
      this.user=resp.data[0]
      const date=new Date(this.user.birthday)
      this.user.birthday=`${date.getFullYear()}-${date.getMonth()+1}-${date.getDate()}`
      if (this.user.email==='none'){
        this.user.email='无'
      }
      if (this.user.sex==='none'){
        this.user.sex='无'
      }
      if (this.user.sex==='men'){
        this.user.sex='男'
      }
      if (this.user.sex==='women'){
        this.user.sex='女'
      }
      axios({
        method:'get',
        url:'api/user_info',
        params:{
          token:localStorage.getItem("token")
        }
      }).then((resp)=>{
        this.logUid=resp.data[0].iid
        if (this.logUid===this.user.iid){
          this.buttonShow=true
        }
        axios({
          method:'get',
          url:'api/followStatue',
          params:{
            'uid':this.pageUid,
            'fan':this.logUid
          }
        }).then((resp)=>{
          if (resp.data){
            this.followButton='关注'
          }
          else if (!resp.data){
            this.followButton='取消关注'
          }
          this.hideLoading()
        }).catch((error)=>{
          console.log(error)
        })
      }).catch((error)=>{
        console.log(error)
      })
    }).catch((err)=>{
      this.$router.push("/wrong")
      this.hideLoading()
    })
  },
  methods:{
    updateBkDialog(){
      this.updateUrl='api/uploadBk'
      this.dialogTitle='修改背景图片'
      this.updateBkVisible=!this.updateBkVisible
    },
    updateUserImageDialog(){
      this.updateUrl='api/uploadTH'
      this.dialogTitle='修改用户头像'
      this.updateBkVisible=!this.updateBkVisible
    },
    updateUserSelfDialog(){
      this.dialogTitle='修改个人资料'
      this.userForm.nickname=this.user.nickname
      this.date=this.user.birthday
      this.userForm.sex=this.user.sex
      this.userForm.email=this.user.email
      this.userForm.self=this.user.self
      this.updateSelfVisible=!this.updateSelfVisible;
    },
    beforeBkImgUpload(file){
      const fileType=file.name.split('.').pop();
      if (fileType!=='jpg'&&fileType!=='png'&&fileType!=='JPG'){
        this.$message({
          showClose:true,
          message:'背景图片必须是.jpg或.png类型！',
          type:"error"
        })
        return false;
      }
      if (file.size/1024/1024>5){
        this.$message({
          showClose:true,
          message:'背景图片大小不能超过5MB！',
          type:"error"
        })
        return false
      }
    },
    handleSuccess(res,file){
      this.userBkList.push(file)
      this.$message.success("上传背景图片成功！")
      this.userBkList=[];
      location.reload()
    },
    submitSelfChange(){
      this.userForm.birthday=new Date(this.date).valueOf()
      if (this.userForm.email==='无'){
        this.userForm.email='none';
      }
      if (this.userForm.sex==='男'){
        this.userForm.sex='men'
      }
      if (this.userForm.sex==='女'){
        this.userForm.sex='women'
      }
      if (this.userForm.sex==='none'){
        this.userForm.sex='none'
      }
      if (this.userForm.self.length<=0){
        this.userForm.self='这个人很懒，没有个人简介哦'
      }
      this.$refs.userForm.validate((validate)=>{
        if (validate){
          axios({
            method:'post',
            url:'api/uploadSelf',
            data:{
              'iid':this.user.iid,
              'background': this.user.background,
              'userimage':this.user.userimage,
              'nickname':this.userForm.nickname,
              'self':this.userForm.self,
              'sex':this.userForm.sex,
              'birthday':this.userForm.birthday,
              'email':this.userForm.email
            }
          }).then((resp)=>{
            if (resp.data.code===9922){
              this.$message.success("修改个人资料成功！")
              location.reload()
            }
            else {
              this.$message.error("修改个人资料失败！")
            }
          }).catch((error)=>{
            console.log(error)
          })
        }
        else {
          this.$message.error("请正确填写个人资料！")
        }
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
            for (let i=0;i<this.works.length;i++){
              if (this.works[i].pid===id){
                this.works[i].liked=false
              }
            }
            for (let i=0;i<this.favors.length;i++){
              if (this.favors[i].pid===id){
                this.favors[i].liked=false
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
            for (let i=0;i<this.works.length;i++){
              if (this.works[i].pid===id){
                this.works[i].liked=true
              }
            }
            for (let i=0;i<this.favors.length;i++){
              if (this.favors[i].pid===id){
                this.favors[i].liked=true
              }
            }
          }
          else if(resp.data===false){
            this.$message.error("收藏失败！")
          }
        })
      }
    },
    toFavorite(){
      this.switchMode=false
      this.getFavorite()
    },
    getFavorite(){
      axios({
        method:'get',
        url:'api/getFavorite',
        params:{
          uid:this.$route.query.uid
        }
      }).then((resp)=>{
        this.favors=resp.data
      }).then((err)=>{
        console.log(err)
      })
    },
    getWorks(){
      axios({
        method:'get',
        url:'api/getWorks',
        params:{
          uid:this.$route.query.uid
        }
      }).then((resp)=>{
        this.works=resp.data
      }).catch((err)=>{
        console.log(err)
      })
    },
    follow(){
      if (this.followButton==='关注'){
        axios({
          method:'get',
          url:'api/follow',
          params:{
            'uid':this.pageUid,
            'fan':this.logUid
          }
        }).then((resp)=>{
          if (resp.data===true){
            this.$message.success("关注成功！")
            this.followButton='取消关注'
          }
          else {
            this.$message.error("关注失败！")
          }
        })
      }
      if (this.followButton==='取消关注'){
        axios({
          method:'get',
          url:'api/follow',
          params:{
            'uid':this.pageUid,
            'fan':this.logUid
          }
        }).then((resp)=>{
          if (resp.data===true){
            this.$message.success("取消关注成功！")
            this.followButton='关注'
          }
          else {
            this.$message.error("取消关注失败！")
          }
        })
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
    goBack(){
      this.$router.back()
    },
  }
}
</script>

<style scoped>
.userSelfCard {
  display: flex;
  position: relative;
  flex-direction: row;
  align-items: center;
  justify-content: space-between;
}
.userHead {
  position: relative;
  display: flex;
  height: 100%;
  margin-left: 10px;
  padding-top: 30px;
  flex: 0 0 280px;
}
.userInfo {
  position: relative;
  margin-left: 30px;
  padding-left: 30px;
  flex: 1;
}
.userSelfCard{
  height: 310px;
  background-color: #f5f5f5
}
.button-container {
  position: absolute;
  bottom: 0;
  right: 0;
  padding: 10px;
}
:deep(.el-textarea__inner){
  resize: none;
}
.data-card{
  margin-top: 10px;
  display: flex;
  flex-wrap: wrap;
  overflow: auto;
  align-items: center;
  justify-content: flex-start;
  float: inherit;
}
.image-card{
  margin-top: 10px;
  margin-left: 10px;
  height: 240px;
  width: 260px;
}
.bottom {
  margin-top: 13px;
  line-height: 12px;
}
.clearfix:before,
.clearfix:after {
  display: table;
  content: "";
}
.clearfix:after {
  clear: both
}
.star-button{
  padding: 0;
  float: right;
}
</style>