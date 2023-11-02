<template>
  <el-container>
    <el-header>
      <el-page-header @back="goBack" content="插画">
      </el-page-header>
    </el-header>
    <el-main>
      <div class="show-artworks-card">
        <div class="artworks-image">
          <div v-for="(art,index) in artworks" :key="index">
            <el-image
                :src="art.picture"
                fit="cover"
                style="width: 100%;height: 100%">
            </el-image>
          </div>
        </div>
        <div class="artworks-info">
          <div class="artworks-info-card">
            <div class="artworks-info-title" v-for="(art,index) in artworks" :key="art.pid">
              <p>标题：{{art.subtitle}}</p>
              <p>上传时间：{{art.createtime}}</p>
              <span>喜欢：{{art.likenum}} 浏览：{{art.view}}</span>
            </div>
            <div class="artworks-user-info" v-for="(user,index) in user" :key="user.uid">
              <div class="artworks-user-info-img">
                <img
                    :src="user.userimage"
                    style="width: 120px;height: 120px;border-radius: 50%;cursor: pointer"
                    alt=""
                    @click="toUser">
              </div>
              <div class="artworks-user-info-name">
                <span @click="toUser" style="cursor: pointer">{{user.nickname}}</span>
              </div>
            </div>
            <div class="artworks-self-info" v-for="(art,index) in artworks" :key="0">
              <el-input
                  type="textarea"
                  :rows="5"
                  placeholder="无介绍"
                  v-model="art.introduce"
                  resize="none"
                  disabled
                  style="width: 98%;margin-left: 6px">
              </el-input>
            </div>
            <div style="text-align: right;margin-top: 10px;margin-right: 10px;margin-bottom: 5px">
              <el-button type="primary" :icon="favoriteButton" @click="favorite" circle></el-button>
              <el-button type="primary" icon="el-icon-download" @click="downloadImg" circle download></el-button>
            </div>
          </div>
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
    this.showLoading()
    //更新插画最后一次浏览时间
    axios({
      method:'get',
      url:'api/updateTime',
      params:{
        pid:this.$route.query.pid
      }
    }).then((resp)=>{
      //获取插画详细信息
      axios({
        method:'get',
        url:'api/getArtworksId',
        params:{
          pid:this.$route.query.pid
        }
      }).then((resp)=>{
        this.artworks=resp.data
        const date=new Date(this.artworks[0].createtime)
        this.artworks[0].createtime=`${date.getFullYear()}-${date.getMonth()+1}-${date.getDate()}`
        //获取作者详细信息
        axios({
          method:'get',
          url:'api/user_info_id',
          params:{
            uid:this.artworks[0].uid
          }
        }).then((resp)=>{
          this.user=resp.data
          //插画浏览量数增加
          axios({
            method:"get",
            url:'api/view',
            params:{
              pid:this.$route.query.pid
            }
          }).then((resp)=>{
            //获取插画收藏状态
            axios({
              method:'get',
              url:'/api/favoriteStatue',
              params:{
                token:localStorage.getItem("token"),
                pid:this.$route.query.pid
              }
            }).then((resp)=>{
              if (resp.data===true){
                this.favoriteButton='el-icon-star-off'
              }
              else if(resp.data===false){
                this.favoriteButton='el-icon-star-on'
              }
              this.history()
              this.hideLoading()
            })
          })
        })
      }).catch((error)=>{
        this.$router.push("/wrong")
        this.hideLoading()
      })
    })
  },
  data(){
    return{
      artworks:[],
      user:[],
      favoriteButton:''
    }
  },
  methods:{
    //下载插画
    downloadImg(){
      axios({
        method:'get',
        url:'api/download',
        responseType:'blob',
        params:{
          'pid':this.artworks[0].pid
        }
      }).then((resp)=>{
        const blob = new Blob([resp.data]);
        const link = document.createElement('a');
        link.href = URL.createObjectURL(blob);
        link.download =this.artworks[0].subtitle+".jpg";
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
      })
    },
    //返回之前的界面
    goBack(){
      this.$router.back()
    },
    //跳转用户详细信息
    toUser(){
      this.$router.push({
        path:'/user',
        query:{
          uid:this.artworks[0].uid
        }
      })
    },
    //插画收藏（取消收藏）
    favorite(){
      if (this.favoriteButton==='el-icon-star-off'){
        axios({
          method:'get',
          url:'api/favorite',
          params:{
            token:localStorage.getItem("token"),
            pid:this.$route.query.pid
          }
        }).then((resp)=>{
          if (resp.data){
            this.$message.success("收藏成功！")
            this.favoriteButton='el-icon-star-on'
            this.artworks[0].likenum++
          }
          else {
            this.$message.error("收藏失败！")
          }
        })
      }
      if (this.favoriteButton==='el-icon-star-on'){
        axios({
          method:'get',
          url:'api/favorite',
          params:{
            token:localStorage.getItem("token"),
            pid:this.$route.query.pid
          }
        }).then((resp)=>{
          if (resp.data){
            this.$message.success("取消收藏成功！")
            this.favoriteButton='el-icon-star-off'
            this.artworks[0].likenum--
          }
          else {
            this.$message.error("取消收藏失败！")
          }
        })
      }
    },
    //历史记录添加（更新）
    history(){
      axios({
        method:'post',
        url:'api/addHistory',
        data:{
          token:localStorage.getItem("token"),
          pid:this.$route.query.pid,
          viewtime:0
        }
      }).then((resp)=>{
        if (resp.data.code===4444){
          console.log(resp.data.message)
        }
        else if(resp.data.code===4445){
          console.log(resp.data.message)
        }
        else if(resp.data.code===4443){
          console.log(resp.data.message)
        }
      }).catch((err)=>{
        console.log(err)
      })
    },
    //显示加载界面
    showLoading(){
      this.loading=true
      Loading.service({
        lock:true,
        text:'加载中...',
        background: 'rgb(255,255,255)'
      })
    },
    //隐藏加载界面
    hideLoading(){
      this.loading = false
      Loading.service().close()
    }
  }
}
</script>

<style scoped>
.show-artworks-card{
  height: 100%;
  display: flex;
  flex-wrap: wrap;
  overflow: auto;
  justify-content: space-between;
}
.artworks-image{
  flex: 1 0 64%;
  flex-wrap: wrap;
}
.artworks-info{
  flex: 1 0 30%;
  flex-wrap: wrap;
  margin-left: 15px;
  background-color: #f5f5f5;
  border-radius: 3%;
}
.artworks-user-info{
  display: flex;
  margin-top: 40px;
  margin-left: 20px;
  overflow: auto;
}
.artworks-user-info-name{
  padding-top: 50px;
  margin-left: 25px;
  display: flex;
  overflow: auto;
}
.artworks-user-info-img{
  display: flex;
  overflow: auto;
}
.artworks-info-title{
  margin-left: 20px;
}
.artworks-self-info{
  margin-top: 30px;
}
</style>