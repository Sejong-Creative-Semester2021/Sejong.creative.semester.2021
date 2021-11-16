<template>
  <div id="header" class="scroll-y">
    <Menu theme="light" mode="horizontal" @on-select="handleRoute" :active-name="activeMenu" class="oj-menu">  
      <div class="logo"><span>{{'OJ'}}</span></div>
      <div class="menulist">
        <Menu-item name="/" class='list'>
          {{$t('m.Home')}}
        </Menu-item>
        <Menu-item name="/aicontest_general" class='list'>
          {{'AI 대회'}}
        </Menu-item>
        <Menu-item name="/announcement" class='list'>
          {{'공지사항'}}
        </Menu-item>
        <Menu-item name="/FAQ" style="margin-right: 30px" class='list'>
          {{$t('m.FAQ')}}
        </Menu-item>
        <template v-if="!isAuthenticated">
          <div class="btn-menu">
            <Button class="login-btn"
                    type="ghost"
                    ref="loginBtn"
                    shape="circle"
                    @click="handleBtnClick('login')"
                    style="color: #ffffff">로그인
            </Button>
            <Button v-if="website.allow_register"
                    class="register-btn"
                    shape="circle"
                    @click="handleBtnClick('register')"
                    style="margin-left: 15px; border-color: rgb(217, 95, 95); background-color: rgb(217, 95, 95); color: #ffffff">회원가입
            </Button>
          </div>
        </template>
        <template v-else>
          <b-avatar button @click="handleRoute('/user-home')"></b-avatar>
          <Button type="text" name="/user-home" @click="handleRoute('/user-home')" style="font-size: 16px; font-weight: bold; color:#cac8c8;">{{ user.username }}</Button>
          <Button type="text" name="/logout" @click="handleRoute('/logout')" style="font-size: 16px; font-weight: bold; color:#cac8c8;">로그아웃</Button>
          <!--<Dropdown class="drop-menu" @on-click="handleRoute" placement="bottom" trigger="click">
            <Button type="text" class="drop-menu-title">{{ user.username }}
              <Icon type="arrow-down-b"></Icon>
            </Button>
            <Dropdown-menu slot="list">
              <Dropdown-item name="/user-home">마이페이지</Dropdown-item>
              <Dropdown-item name="/setting/profile">{{$t('m.Settings')}}</Dropdown-item>
              <Dropdown-item v-if="isAdminRole" name="/admin">관리</Dropdown-item>
              <Dropdown-item divided name="/logout">로그아웃</Dropdown-item>
            </Dropdown-menu>
          </Dropdown>-->
        </template>
      </div>
    </Menu>
    <Modal v-model="modalVisible" :width="400">
      <div slot="header" class="modal-title">{{$t('m.Welcome_to')}} {{website.website_name_shortcut}}</div>
      <component :is="modalStatus.mode" v-if="modalVisible"></component>
      <div slot="footer" style="display: none"></div>
    </Modal>
  </div>
</template>

<script>
  import { mapGetters, mapActions } from 'vuex'
  import login from '@oj/views/user/Login'
  import register from '@oj/views/user/Register'

  export default {
    components: {
      login,
      register
    },
    mounted () {
      this.getProfile()
    },
    methods: {
      ...mapActions(['getProfile', 'changeModalStatus']),
      handleRoute (route) {
        console.log('route', route)
        console.log('인')
        if (route && route.indexOf('admin') < 0) {
          this.$router.push(route)
        } else {
          window.open('/admin/')
        }
      },
      handleBtnClick (mode) {
        this.changeModalStatus({
          visible: true,
          mode: mode
        })
      }
    },
    computed: {
      ...mapGetters(['website', 'modalStatus', 'user', 'isAuthenticated', 'isAdminRole']),
      // 跟随路由变化
      activeMenu () {
        console.log('active')
        console.log('path', this.$route.path.split('/'))
        console.log('path2', this.$route.path)
        return '/' + this.$route.path.split('/')[1]
      },
      modalVisible: {
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

<style lang="less" scoped>
  .ivu-menu-horizontal {
    height: 0px;
  }
  .add {
    background-color: white !important;
  }
  #header {
    min-width: 300px;
    position: fixed;
    top: 0;
    left: 0;
    height: auto;
    width: 100%;
    z-index: 1000;
    background-color: white;
  
    li:hover {
      border-bottom-width: 0px !Important;
    }
    .ivu-menu-light.ivu-menu-horizontal .ivu-menu-item:hover {
      border-bottom: 0px;
    }
    .ivu-menu-item-selected {
      border-bottom-width: 0px !important;
    }
    
    .oj-menu {
      width: 70%;
      margin-left: 15%;
      background-color: transparent;
    }

    .menulist {
      float: right;
    }

    .sublist {
      color: #000000;
    }
    
    .list {
      font-weight: bold;
      font-size: large;
      display:table;
    }

    .logo {
      margin-left: 2%;
      margin-right: 2%;
      font-size: 20px;
      float: left;
      line-height: 60px;
      color: #ffffff;
    }

    .drop-menu {
      color: #ffcc00;
      float: right;
      margin-right: 30px;
      right: 10px;
      &-title {
        font-size: 18px;
      }
    }
    .dropdown-menu{
       color: #000000;
    }
    .btn-menu {
      color: #ffcc00;
      font-size: 16px;
      float: right;
      margin-right: 10px;
    }
    .login-btn {
      font-weight: bold;
      border-width: 2px;
      padding-top: 6px;
      padding-bottom: 6px;
      font-size: 14px;
    }
    .register-btn {
      font-weight: bold;
      border-width: 2px;
      padding-top: 6px;
      padding-bottom: 6px;
      font-size: 14px;
    }
    .ivu-btn-ghost:hover {
      background-color: #e3a8a8;
      border-color: #e3a8a8;
    }
  }

  .modal {
    &-title {
      font-size: 18px;
      font-weight: 600;
    }
  }
</style>
