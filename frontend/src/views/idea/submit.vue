<template>
  <el-container>
    <el-main>
      <el-form :model="ruleForm" :rules="rules" ref="ruleForm">
        <el-form-item label="插画文件："></el-form-item>
        <el-form-item prop="picture">
          <el-upload
              drag
              name="file"
              action="api/submit"
              ref="uploader"
              :auto-upload="false"
              :limit="1"
              :data="ruleForm"
              :rules="rules"
              :on-change="uploadChange"
              :on-success="successSubmit"
              :on-error="errorSubmit"
              accept=".jpg,.png,JPG,.PNG,.JPEG,.jpeg">
            <i class="el-icon-upload"></i>
            <div class="el-upload__text">将插画文件拖到此处，或<em>点击上传</em></div>
          </el-upload>
        </el-form-item>
        <el-form-item prop="subtitle" label="插画标题：" style="width: 400px">
          <el-input v-model="ruleForm.subtitle" placeholder="请输入插画的标题" maxlength="32" show-word-limit clearable></el-input>
        </el-form-item>
        <el-form-item prop="introduce" label="插画介绍：" style="width: 400px">
          <el-input type="textarea" v-model="ruleForm.introduce" placeholder="请描述您的作品" maxlength="150" show-word-limit resize="none" rows="7"></el-input>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" round icon="el-icon-upload" @click="submitForm">投稿</el-button>
          <el-button type="danger" round icon="el-icon-delete" @click="reset">重置</el-button>
        </el-form-item>
      </el-form>
    </el-main>
  </el-container>
</template>

<script>
export default {
  data(){
    return{
      ruleForm:{
        username:localStorage.getItem("token"),
        subtitle:'',
        introduce:'',
      },
      rules:{
        subtitle:[
          { required: true, message: '作品标题不得为空！', trigger: 'blur' },
          { max: 32, message: '作品标题不得超过32位！', trigger: 'blur' }
        ],
        introduce:[
          { required: true, message: '插画介绍不得为空！', trigger: 'blur' },
          { max: 150, message: '插画介绍不得超过150位！', trigger: 'blur' }
        ],
        picture:[
          {require:true,message:"投稿的插画不能为空！",trigger:'blur'}
        ]
      },
    }
  },
  methods:{
    submitForm(){
      this.$refs.ruleForm.validate((validate)=>{
        if (validate){
          this.$refs.uploader.submit()
        }
        else {
          this.$message.error("请按投稿要求提交表单！")
        }
      })
    },
    uploadChange(file,fileList){
      const size=file.size/1024/1024>30
      if (size){
        this.$message.error("上传插画大小不能超过30MB！")
        fileList.splice(0,1)
      }
      if (fileList.length>1){
        fileList.splice(0,1)
      }
    },
    successSubmit(){
      this.$message.success("感谢你对社区的贡献，您的投稿已被接受！")
      this.reset()
    },
    errorSubmit(){
      this.$message.error("投稿失败！")
    },
    reset(){
      this.$refs['ruleForm'].resetFields()
    },
  }
}
</script>

<style scoped>

</style>