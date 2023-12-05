<template>
  <div>
    <div class="background">
      <transition-group name="fade">
        <img v-for="(image, index) in images" :key="image" :src="image" :class="{ active: index === currentIndex }" alt="background">
      </transition-group>
    </div>
    <div>
      <el-button type="primary" round @click="toRegister" class="right-up-btn">注册</el-button>
    </div>
    <div>
      <transition name="el-fade-in-linear" appear>
        <GlassCard>
          <h1>登录到</h1>
          <h3>— VuePictures —</h3>
          <h4>你 是 谁?</h4>
          <div></div>
          <el-form :model="ruleForm" :rules="rules" ref="ruleForm">
            <el-form-item prop="usr">
              <el-input v-model="ruleForm.usr" placeholder="请输入用户名" prefix-icon="el-icon-user"></el-input>
            </el-form-item>
            <el-form-item prop="pwd">
              <el-input v-model="ruleForm.pwd" placeholder="请输入密码" prefix-icon="el-icon-lock" show-password></el-input>
            </el-form-item>
            <el-form-item>
              <el-button type="primary" round @click="submitForm()" style="width:100%;margin-bottom:15px;">登录</el-button>
            </el-form-item>
          </el-form>
          <el-divider></el-divider>
        </GlassCard>
      </transition>
    </div>
    <router-view></router-view>
  </div>
</template>

<script>
import GlassCard from "@/components/GlassCard.vue";
import axios from "axios";
import router from "@/router/router";

export default {
  components: {GlassCard},
  created() {
    const msg=this.$route.query.msg;
    if (msg==="brq"){
      this.$message({
        showClose:true,
        message:"请先登录!",
        type:'error'
      })
    }
  },
  data() {
    return {
      //其他图片资源
      images: [
        require('@/assets/background6.png'),
        require('@/assets/background5.jpg'),
        require('@/assets/background4.jpg'),
        require('@/assets/background3.jpg'),
        require('@/assets/background2.png'),
        require('@/assets/background1.png'),
      ],
      ruleForm:{
        usr: "",
        pwd: ""
      },
      rules:{
        usr: [
          {required:true,message:"请输入用户名!",trigger:'blur'}
        ],
        pwd: [
          {required:true,message:"请输入密码!",trigger:'blur'}
        ]
      },
      //当前显示的背景图片的索引
      currentIndex: 0,
    };
  },
  mounted() {
    //计时器，用于背景渐变计时
    setInterval(() => {
      this.currentIndex = (this.currentIndex + 1) % this.images.length;
    }, 5000);
  },
  methods:{
    //跳转注册界面
    toRegister() {
      this.$router.push("/register")
    },
    //提交表单
    submitForm(){
      this.$refs.ruleForm.validate((valid)=>{
        if (valid){
          axios({
            method:"post",
            url:"api/login",
            data:{
              username:this.ruleForm.usr,
              password:this.ruleForm.pwd
            }
          }).then((resp)=>{
            if (resp.data.code===7777){
              localStorage.setItem("token",resp.data.data.token)
              this.$message({
                showClose:true,
                message:"欢迎用户: "+this.ruleForm.usr,
                type:'success'
              })
              router.push("/home")
            } else {
              this.$message({
                showClose:true,
                message:"用户名或密码错误!",
                type:'error'
              })
            }
          }).catch((error)=>{
            this.$message({
              showClose:true,
              message:"网络错误，请检查网络或联系作者！",
              type:'error'
            })
          })
        }
        else{
          this.$message({
            showClose:true,
            message:"必须输入用户名和密码！",
            type:'error'
          })
        }
      })
    }
  }
};
</script>

<style scoped>
@import "@/assets/font/font.css";
.background {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  z-index: -1;
}

.background img {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  opacity: 0;
  transition: opacity 0.5s ease-in-out;
}

.background img.active {
  opacity: 1;
}

.container {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 98vh;
}

h1 {
  font-family: "font_aigei_com",sans-serif;
  font-size: 30px;
  font-weight: bold;
  color: #333;
}
h3{
  font-family: "font_aigei_com",sans-serif;
  font-size: 50px;
  font-weight: bold;
  color: #333;
}
h4{
  font-family: "font_aigei_com",sans-serif;
  font-size: 20px;
  font-weight: bold;
  color: #333;
}
.right-up-btn{
  position: fixed;
  top: 10px;
  right: 10px;
  z-index: 9999;
}
</style>
