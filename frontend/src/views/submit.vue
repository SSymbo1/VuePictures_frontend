<template>
  <div class="main-form">
    <el-container>
      <el-header>
      </el-header>
      <el-main>
        <div class="main-submit-form">
          <el-form
              :model="artworks"
              ref="artworks"
              :rules="rule">
            <el-form-item style="width: 400px" prop="picture">
              <el-upload
                  drag
                  action="api/submit"
                  ref="uploader"
                  :auto-upload="false"
                  :on-change="uploadChange"
                  :on-success="successSubmit"
                  :on-error="errorSubmit"
                  accept=".jpg,.jpeg,.png,.JPEG,.PNG"
                  :data="artworks"
                  name="file"
                  multiple
                  :rules="rule">
                <i class="el-icon-upload"></i>
                <div class="el-upload__text">将图片拖到此处，或<em>点击上传</em></div>
                <div class="el-upload__tip" slot="tip">只能上传jpg/png照片，且不超过30MB</div>
              </el-upload>
            </el-form-item>
            <el-form-item label="插画标题" style="width: 400px" prop="subtitle">
              <el-input v-model="artworks.subtitle" prefix-icon="el-icon-picture" maxlength="30" show-word-limit></el-input>
            </el-form-item>
            <el-form-item label="插画描述" style="width: 450px" prop="introduce">
              <el-input v-model="artworks.introduce" type="textarea" maxlength="80" rows="4" show-word-limit resize="none"></el-input>
            </el-form-item>
            <el-form-item>
              <div>
                <el-button type="primary" @click="submitForm" round>投稿</el-button>
                <el-button  @click="reset" round>重置</el-button>
              </div>
            </el-form-item>
          </el-form>
        </div>
      </el-main>
    </el-container>
  </div>
</template>

<script>
export default {
  data(){
    return{
      artworks:{
        username: localStorage.getItem("token"),
        subtitle:'',
        introduce:''
      },
      rule:{
        subtitle:[
          {required:true,message:"请输入插画标题!",trigger:'blur'},
        ],
        introduce:[
          {required:true,message:"请输入插画描述!",trigger:'blur'}
        ],
        picture:[
          {require:true,message:"投稿的插画不能为空！",trigger:'blur'}
        ]
      },
    }
  },
  methods:{
    uploadChange(file,fileList){
      const size=file.size/1024/1024>30
      if (size){
        this.$message.error("上传插画大小不能超过30MB！")
        fileList.splice(0,1)
      }
      else {
        console.log("已加入对象！")
        console.log(this.artworks.picture)
      }
      if (fileList.length>1){
        fileList.splice(0,1)
      }
    },
    reset(){
      this.$refs['artworks'].resetFields()
    },
    successSubmit(){
      this.$message.success("感谢你对社区的贡献，您的投稿已被接受！")
      this.reset()
    },
    errorSubmit(){
      this.$message.success("投稿失败！")
    },
    submitForm(){
      this.$refs.artworks.validate((validate)=>{
        if (validate){
          this.$refs.uploader.submit()
        }
        else {
          this.$message.error("请按投稿要求提交表单！")
        }
      })
    }
  }
}
</script>

<style scoped>
.main-submit-form{
  width: 800px;
  text-align: center;
}
</style>
