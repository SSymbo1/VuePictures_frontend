<template>
  <div>
    <div class="background">
      <transition-group name="fade">
        <img v-for="(image, index) in images" :key="image" :src="image" :class="{ active: index === currentIndex }" alt="background">
      </transition-group>
    </div>
    <div>
      <GlassCard>
        <h1>VuePictures</h1>
        <h3>一个正在测试的插画网站</h3>
        <div></div>
        <div class="button-container">
          <el-button type="primary" round @click="toLogin" style="width:100%;margin-bottom:15px;">登录</el-button>
          <el-button round @click="toRegister" style="width:100%;margin-bottom:15px;margin-left: 0">注册</el-button>
        </div>
        <el-divider></el-divider>
      </GlassCard>
    </div>
  </div>
</template>

<script>

import GlassCard from "@/components/GlassCard.vue";

export default {
  components: {GlassCard},
  data() {
    return {
      //其他图片资源
      images: [
        require('@/assets/background1.png'),
        require('@/assets/background2.png'),
        require('@/assets/background3.jpg'),
        require('@/assets/background4.jpg'),
        require('@/assets/background5.jpg'),
        require('@/assets/background6.png'),
      ],
      // 当前显示的背景图片的索引
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
    //跳转登录页面
    toLogin(){
      this.$router.push('/login')
    },
    //跳转注册页面
    toRegister(){
      this.$router.push('/register')
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

.button-container {
  display: flex;
  flex-direction: column; /* 将元素垂直排列 */
  align-items: center; /* 水平居中对齐 */
}

h1 {
  font-family: "font_aigei_com",sans-serif;
  font-size: 70px;
  font-weight: bold;
  color: #333;
}
h3{
  font-family: "font_aigei_com",sans-serif;
  font-size: 20px;
  font-weight: bold;
  color: #333;
}
</style>
