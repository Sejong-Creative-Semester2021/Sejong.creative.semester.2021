<template>
<div>
    <Form ref="formRegister" :model="formRegister" :rules="ruleRegister">
      <FormItem prop="username">
        <span class="label">아이디</span>
        <Input type="text" v-model="formRegister.username" :placeholder="'아이디'" size="large" @on-enter="handleRegister">
        <!--<<Icon type="ios-person-outline" slot="prepend"></Icon>-->
        </Input>
      </FormItem>
      <FormItem prop="email">
        <span class="label">이메일</span>
        <Input v-model="formRegister.email" :placeholder="'이메일'" size="large" @on-enter="handleRegister">
        <!--<<Icon type="ios-email-outline" slot="prepend"></Icon>-->
        </Input>
      </FormItem>
      <FormItem prop="password">
        <span class="label">비밀번호</span>
        <Input type="password" v-model="formRegister.password" :placeholder="'비밀번호'" size="large" @on-enter="handleRegister">
        <!--<<Icon type="ios-locked-outline" slot="prepend"></Icon>-->
        </Input>
      </FormItem>
      <FormItem prop="passwordAgain">
        <span class="label">비밀번호 확인</span>
        <Input type="password" v-model="formRegister.passwordAgain" :placeholder="'비밀번호 확인'" size="large" @on-enter="handleRegister">
        <!--<<Icon type="ios-locked-outline" slot="prepend"></Icon>-->
        </Input>
      </FormItem>
      <FormItem prop="captcha" style="margin-bottom:10px">
        <div class="oj-captcha">
          <div class="oj-captcha-code">
            <Input v-model="formRegister.captcha" :placeholder="'보안문자'" size="large" @on-enter="handleRegister">
            <!--<<Icon type="ios-lightbulb-outline" slot="prepend"></Icon>-->
            </Input>
          </div>
          <div class="oj-captcha-img">
            <Tooltip content="새로고침" placement="top">
              <img :src="captchaSrc" @click="getCaptchaSrc"/>
            </Tooltip>
          </div>
        </div>
      </FormItem>
    </Form>
    <div class="footer">
      <Button
        type="primary"
        @click="handleRegister"
        class="btn" long
        :loading="btnRegisterLoading">
        가입하기
      </Button>
      <div style="font-size: 14px; color: #98A8B9; text-align: center;">
        이미 계정이 있으신가요?
        <a @click="switchMode('login')" style="color: rgb(48, 33, 184); font-weight: bold; font-size: 15px;">로그인</a>
      </div>
      <!--<Button
        type="primary"
        @click="switchMode('login')"
        class="btn" long>
        로그인으로 되돌아가기
      </Button>-->
    </div>
  </div>
</template>

<script>
  import { mapGetters, mapActions } from 'vuex'
  import api from '@oj/api'
  import { FormMixin } from '@oj/components/mixins'

  export default {
    mixins: [FormMixin],
    mounted () {
      this.getCaptchaSrc()
    },
    data () {
      const CheckUsernameNotExist = (rule, value, callback) => {
        api.checkUsernameOrEmail(value, undefined).then(res => {
          if (res.data.data.username === true) {
            callback(new Error(this.$i18n.t('m.The_username_already_exists')))
          } else {
            callback()
          }
        }, _ => callback())
      }
      const CheckEmailNotExist = (rule, value, callback) => {
        api.checkUsernameOrEmail(undefined, value).then(res => {
          if (res.data.data.email === true) {
            callback(new Error(this.$i18n.t('m.The_email_already_exists')))
          } else {
            callback()
          }
        }, _ => callback())
      }
      const CheckPassword = (rule, value, callback) => {
        if (this.formRegister.password !== '') {
          // 对第二个密码框再次验证
          this.$refs.formRegister.validateField('passwordAgain')
        }
        callback()
      }

      const CheckAgainPassword = (rule, value, callback) => {
        if (value !== this.formRegister.password) {
          callback(new Error(this.$i18n.t('m.password_does_not_match')))
        }
        callback()
      }

      return {
        btnRegisterLoading: false,
        formRegister: {
          username: '',
          password: '',
          passwordAgain: '',
          email: '',
          captcha: ''
        },
        ruleRegister: {
          username: [
            {required: true, trigger: 'blur'},
            {validator: CheckUsernameNotExist, trigger: 'blur'}
          ],
          email: [
            {required: true, type: 'email', trigger: 'blur'},
            {validator: CheckEmailNotExist, trigger: 'blur'}
          ],
          password: [
            {required: true, trigger: 'blur', min: 6, max: 20},
            {validator: CheckPassword, trigger: 'blur'}
          ],
          passwordAgain: [
            {required: true, validator: CheckAgainPassword, trigger: 'change'}
          ],
          captcha: [
            {required: true, trigger: 'blur', min: 1, max: 10}
          ]
        }
      }
    },
    methods: {
      ...mapActions(['changeModalStatus', 'getProfile']),
      switchMode (mode) {
        this.changeModalStatus({
          mode,
          visible: true
        })
      },
      handleRegister () {
        this.validateForm('formRegister').then(valid => {
          let formData = Object.assign({}, this.formRegister)
          delete formData['passwordAgain']
          this.btnRegisterLoading = true
          api.register(formData).then(res => {
            this.$success(this.$i18n.t('m.Thanks_for_registering'))
            this.switchMode('login')
            this.btnRegisterLoading = false
          }, _ => {
            this.getCaptchaSrc()
            this.formRegister.captcha = ''
            this.btnRegisterLoading = false
          })
        })
      }
    },
    computed: {
      ...mapGetters(['website', 'modalStatus'])

    }
  }
</script>

<style scoped lang="less">
  .label {
    font-size: 16px;
    font-weight: 500;
  }
  .footer {
    overflow: auto;
    margin-top: 20px;
    margin-bottom: -15px;
    text-align: left;
    .btn {
      margin: 0 0 15px 0;
      &:last-child {
        margin: 0;
      }
    }
  }
  .ivu-btn-primary {
    background-color: rgb(119, 67, 214);
    color: white;
    font-size: 18px;
    font-weight: 800;
    border-radius: 40px;
  }
  .ivu-btn-primary:hover {
    background-color: rgba(119, 67, 214, 0.8);
    border-color: rgba(119, 67, 214, 0.8);
    color: white;
    font-size: 18px;
    font-weight: 800;
    border-radius: 40px;
  }
</style>
