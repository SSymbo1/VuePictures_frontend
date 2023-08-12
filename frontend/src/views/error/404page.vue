<template>
  <div class="error-page">
    <h1>404页面不存在！</h1>
    <p>看来您访问的页面并不存在，请检查访问的路径是否正确</p>
    <router-link to="/home">返回主页</router-link>
  </div>
</template>

<script>
export default {

}
</script>

<style>
.error-page {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  height: 98vh;
  font-size: 2rem;
  font-weight: bold;
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
