<template>
  <div>
    <router-view></router-view>
  </div>
</template>

<script>
export default {
  name: 'App',
  data:function (){
    return{
    }
  },
}
</script>

<style>
#nprogress .bar{
  background: #00f2ff;
}
::-webkit-scrollbar {
  -webkit-appearance: none;
  width: 10px;
  height: 10px;
}
::-webkit-scrollbar-track {
  background: rgba(0, 0, 0, 0.1);
  border-radius: 10px;
}
::-webkit-scrollbar-thumb {
  cursor: pointer;
  border-radius: 5px;
  background: rgb(78,158,253);
  transition: color 0.2s ease;
}
::-webkit-scrollbar-thumb:hover {
  background: rgb(110,177,253);
}
</style>