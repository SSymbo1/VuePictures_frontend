<template>
  <div class="container">
    <div class="glass-card">
      <div class="content">
        <slot></slot>
      </div>
    </div>
  </div>
</template>

<style scoped>
.container {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100vh;
}

.glass-card {
  background-color: rgba(255, 255, 255, 0.5);
  border-radius: 20px;
  padding: 20px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  display: flex;
  justify-content: center;
  align-items: center;
  position: relative;
  /* 限制卡片的最大宽度 */
  max-width: 80%;
}

.content {
  text-align: center;
}
</style>
