<template>
  <el-menu class="vertical_menu"
           :router="true" :default-active="currentPath">
    <div class="logo">
      <img src="../../../assets/logo.jpg" alt="oj admin"/>
    </div>
    <el-menu-item index="/" class="item"><i class="el-icon-fa-dashboard"></i>대시보드</el-menu-item>
    <el-submenu v-if="isSuperAdmin" class="item">
      <template slot="title" class="item"><i class="el-icon-menu"></i>일반</template>
      <el-menu-item index="/user" class="item">사용자 관리</el-menu-item>
      <el-menu-item index="/announcement" class="item">공지사항</el-menu-item>
      <el-menu-item index="/faq" class="item">{{$t('m.FAQ')}}</el-menu-item>
    </el-submenu>
    <el-menu-item index="/aicontest" class="item" v-if="hasProblemPermission"><i class="el-icon-fa-list"></i>AI 문제리스트</el-menu-item>
    <el-menu-item index="/aicontest/create" class="item" v-if="hasProblemPermission"><i class="el-icon-fa-clipboard"></i>문제 등록</el-menu-item>
  </el-menu>
</template>

<script>
  import {mapGetters} from 'vuex'

  export default {
    name: 'SideMenu',
    data () {
      return {
        currentPath: ''
      }
    },
    mounted () {
      this.currentPath = this.$route.path
    },
    computed: {
      ...mapGetters(['user', 'isSuperAdmin', 'hasProblemPermission'])
    }
  }
</script>

<style scoped lang="less">
  .el-menu-item.is-active {
    background: #990000 !important;
    color: #ffffff !important;
    font-weight: bold;
  }
  .el-submenu__title:hover {
    background-color: rgba(153, 0,0,0.1); 
  }
  .el-menu-item:hover {
    background: rgba(153, 0,0,0.1);
  }
  .el-menu-item {
    color: black;
  }
  .vertical_menu {
    overflow: auto;
    width: 205px;
    height: 100%;
    position: fixed !important;
    z-index: 100;
    top: 0;
    bottom: 0;
    left: 0;
    
    .logo {
      margin: 20px 0;
      text-align: center;
      img {
        background-color: #fff;
        border-radius: 50%;
        border: 3px solid #fff;
        width: 75px;
        height: 75px;
      }
    }
  }
</style>
