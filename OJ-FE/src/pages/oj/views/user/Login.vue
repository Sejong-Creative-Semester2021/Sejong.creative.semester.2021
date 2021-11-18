<template>
  <div>
    <Form ref="formLogin" :model="formLogin" :rules="ruleLogin">
      <FormItem prop="username">
        <span class="label">아이디</span>
        <Input type="text" v-model="formLogin.username" :placeholder="'아이디'" size="large" @on-enter="handleLogin">
        <!--<Icon type="ios-person-outline" slot="prepend"></Icon>-->
        </Input>
      </FormItem>
      <FormItem prop="password">
        <span class="label">비밀번호</span>
        <a @click.stop="goResetPassword" style="float: right; color: rgb(48, 33, 184); font-weight: bold; font-size: 14px;">비밀번호 찾기</a>
        <Input type="password" v-model="formLogin.password" :placeholder="'비밀번호'" size="large" @on-enter="handleLogin">
        <!--<Icon type="ios-locked-outline" slot="prepend"></Icon>-->
        </Input>
      </FormItem>
      <FormItem prop="tfa_code" v-if="tfaRequired">
        <Input v-model="formLogin.tfa_code" :placeholder="$t('m.TFA_Code')">
        <Icon type="ios-lightbulb-outline" slot="prepend"></Icon>
        </Input>
      </FormItem>
    </Form>
    <div class="footer">
      <Button
        type="primary"
        @click="handleLogin"
        class="btn" long
        :loading="btnLoginLoading">
        로그인
      </Button>
      <div style="font-size: 14px; color: #98A8B9; text-align: center;">
        아직 계정이 없으신가요?
        <a v-if="website.allow_register" @click.stop="handleBtnClick('register')" style="color: rgb(48, 33, 184); font-weight: bold; font-size: 15px;">가입하기</a>
      </div>
      <!--<a @click.stop="goResetPassword" style="float: right">비밀번호 찾기</a>-->
    </div>
  </div>
</template>

<script>
  import { mapGetters, mapActions } from 'vuex'
  import api from '@oj/api'
  import { FormMixin } from '@oj/components/mixins'

  export default {
    mixins: [FormMixin],
    data () {
      const CheckRequiredTFA = (rule, value, callback) => {
        if (value !== '') {
          api.tfaRequiredCheck(value).then(res => {
            this.tfaRequired = res.data.data.result
          })
        }
        callback()
      }

      return {
        tfaRequired: false,
        btnLoginLoading: false,
        formLogin: {
          username: '',
          password: '',
          tfa_code: ''
        },
        ruleLogin: {
          username: [
            {required: true, trigger: 'blur'},
            {validator: CheckRequiredTFA, trigger: 'blur'}
          ],
          password: [
            {required: true, trigger: 'change', min: 6, max: 20}
          ]
        }
      }
    },
    methods: {
      ...mapActions(['changeModalStatus', 'getProfile']),
      handleBtnClick (mode) {
        this.changeModalStatus({
          mode,
          visible: true
        })
      },
      handleLogin () {
        this.validateForm('formLogin').then(valid => {
          this.btnLoginLoading = true
          let formData = Object.assign({}, this.formLogin)
          if (!this.tfaRequired) {
            delete formData['tfa_code']
          }
          api.login(formData).then(res => {
            this.btnLoginLoading = false
            this.changeModalStatus({visible: false})
            this.getProfile()
            this.$success(this.$i18n.t('m.Welcome_back'))
          }, _ => {
            this.btnLoginLoading = false
          })
        })
      },
      goResetPassword () {
        this.changeModalStatus({visible: false})
        this.$router.push({name: 'apply-reset-password'})
      }
    },
    computed: {
      ...mapGetters(['website', 'modalStatus']),
      visible: {
        get () {
          return this.modalStatus.visible
        },
        set (value) {
          this.changeModalStatus({visible: value})
        }
      }
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
  .ivu-input-large {
    font-size: 16px !important;
    padding: 6px 7px !important;
    height: 40px !important;
  }
</style>
