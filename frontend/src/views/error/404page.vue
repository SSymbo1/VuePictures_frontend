<template>
  <div class="error-page">
    <img :src="img" class="background" alt="404">
    <h1>访问的页面不存在！</h1>
    <p>看来您访问的页面并不存在，请检查访问的路径是否正确</p>
    <router-link to="/home">返回主页</router-link>
  </div>
</template>

<script>
export default {
  data(){
    return{
      img:require('@/assets/404.jpg')
    }
  }
}
</script>

<style scoped>
.background{
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  z-index: -1;
}
.error-page {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  height: 98vh;
  font-size: 2rem;
  font-weight: bold;
  color: white;
}
.error-page h1 {
  margin-bottom: 1rem;
}
.error-page p {
  margin-bottom: 2rem;
}
.error-page a {
  color: #007bff;
  text-decoration: none;
}
</style>
