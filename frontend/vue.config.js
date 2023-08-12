const { defineConfig } = require('@vue/cli-service')
module.exports = defineConfig({
  transpileDependencies: true
})
module.exports = defineConfig({
  devServer:{
    open:true,
    host:'0.0.0.0',
    port:8080,
    proxy:{
      '/api':{
        target:'http://192.168.162.135:9090/',
        ws:true,
        changeOrigin:true,
        secure:true,
        pathRewrite:{
          "^/api":''
        }
      }
    }
  },
  transpileDependencies: true
})