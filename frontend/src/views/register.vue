<template>
  <div>
    <div class="background">
      <transition-group name="fade">
        <img v-for="(image, index) in images" :key="image" :src="image" :class="{ active: index === currentIndex }" alt="background">
      </transition-group>
    </div>
    <div>
      <el-button type="primary" round @click="toLogin" class="right-up-btn">登录</el-button>
    </div>
    <div>
      <GlassCard>
        <h1>成为</h1>
        <h3>VuePictures中的一员</h3>
        <h4>介绍下你自己?</h4>
        <div></div>
        <el-form :model="ruleForm" :rules="rules" ref="ruleForm">
          <el-form-item prop="usr">
            <el-input v-model="ruleForm.usr" placeholder="请输入用户名" prefix-icon="el-icon-user"></el-input>
          </el-form-item>
          <el-form-item prop="pwd">
            <el-input v-model="ruleForm.pwd" placeholder="请输入密码" prefix-icon="el-icon-lock" show-password></el-input>
          </el-form-item>
          <el-form-item prop="rpwd">
            <el-input v-model="ruleForm.rpwd" placeholder="请再次输入密码" prefix-icon="el-icon-lock" show-password></el-input>
          </el-form-item>
          <el-form-item>
            <el-button type="primary" round @click="submitForm" style="width:100%;margin-bottom:15px;">注册</el-button>
          </el-form-item>
        </el-form>
        <el-divider></el-divider>
      </GlassCard>
    </div>
  </div>
</template>

<script>

import GlassCard from "@/components/GlassCard.vue";
import axios from "axios";
import router from "@/router/router";

export default {
  components: {GlassCard},
  data() {
    return {
      // 其他图片资源
      images: [
        require('@/assets/background4.jpg'),
        require('@/assets/background6.png'),
        require('@/assets/background2.png'),
        require('@/assets/background3.jpg'),
        require('@/assets/background1.png'),
        require('@/assets/background5.jpg'),
      ],
      // 当前显示的背景图片的索引
      currentIndex: 0,
      ruleForm:{
        usr:"",
        pwd:"",
        rpwd:""
      },
      rules:{
        usr: [
          { required: true, message: '用户名不得为空！', trigger: 'blur' },
          { max: 10, message: '用户名不得超过10位！', trigger: 'blur' }
        ],
        pwd: [
          { required: true, message: '密码不得为空！', trigger: 'blur' },
          { max: 18, message: '密码不得超过18位！', trigger: 'blur' }
        ],
        rpwd: [
          { required: true, message: '再次输入密码不得为空！', trigger: 'blur' },
          { validator: this.validateConfirmPassword, trigger: 'blur'}
        ]
      },
    };
  },
  mounted() {
    setInterval(() => {
      this.currentIndex = (this.currentIndex + 1) % this.images.length;
    }, 5000);
  },
  methods:{
    toLogin(){
      this.$router.push('/login')
    },
    validateConfirmPassword(rule, value, callback){
      if (value!==this.ruleForm.pwd){
        callback(new Error("两次密码不一致！"))
      }
      else {
        callback()
      }
    },
    submitForm() {
      this.$refs.ruleForm.validate((valid)=>{
        if (valid){
          axios({
            method:"post",
            url:"api/register",
            data:{
              username:this.ruleForm.usr,
              password:this.ruleForm.pwd
            }
          }).then((resp)=>{
            if (resp.data.code===2222){
              this.$message({
                showClose:true,
                message:"注册成功!",
                type:'success'
              })
              router.push("/login")
            }
            else if(resp.data.code===2220){
              this.$message({
                showClose:true,
                message:"该用户已存在!",
                type:'error'
              })
            }
            else {
              this.$message({
                showClose:true,
                message:"注册失败!",
                type:'error'
              })
            }
          })
        }else {
          this.$message({
            showClose:true,
            message:"请按要求填写注册表！",
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
  height: 98vh; /* 调整父容器的高度 */
}

h1 {
  font-family: "font_aigei_com",sans-serif;
  font-size: 30px;
  font-weight: bold;
  color: #333;
}
h3{
  font-family: "font_aigei_com",sans-serif;
  font-size: 45px;
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
