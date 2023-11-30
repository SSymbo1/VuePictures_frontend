const { defineConfig } = require('@vue/cli-service')
module.exports = defineConfig({
  transpileDependencies: true
})
module.exports = defineConfig({
  devServer:{
    open:true,
    host:'0.0.0.0',
    port:8080,
    client:{
      webSocketURL: 'ws://0.0.0.0:8080/ws',
    },
    headers:{
      'Access-Control-Allow-Origin': '*',
    },
    proxy:{
      '/api':{
        target:'http://localhost:9090/',
        ws:true,
        changeOrigin:true,
        secure:true,
        pathRewrite:{
          "^/api":''
        }
      },
    }
  },
  transpileDependencies: true
})