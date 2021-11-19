<template>
  <div class="container">
    <div class="avatar-container">
      <img class="avatar" :src="profile.avatar"/>
    </div>
    <Card :padding="100">
      <div v-if="profile.user">
        <p style="margin-top: -10px">
          <span v-if="profile.user" class="emphasis">{{profile.user.username}}</span>
          <span v-if="profile.school">@{{profile.school}}</span>
        </p>
        <Button type="text" class="setting-btn" @click="goSetting()">계정 관리</Button>
        <p v-if="profile.mood">
          {{profile.mood}}
        </p>
        
        <div class="flex-container">
          <div class="middle">
            <div slot="title" style="font-size: 25px; margin-bottom: 20px; color: #263747; margin-left: -600px;"><b>참여중인 대회</b></div>
            <b-tabs content-class="mt-3" pills card fill>
              <b-tab title="일반용" id="contest-content">
              <div id="problem-group">
                <b-card v-for="problem in problemlist"
                            :key="problem.title"
                            :img-src='`../../../../../static/img/${problem.id}.jpg`'
                            img-left
                            img-height="150"
                            img-width="300"
                            shadow
                            class="mb-2 problem-card">
                  <b-card-body class="problem-content">
                    <b-card-title class="problem-title" @click="goGeneralProblem(problem._id)">{{problem.title}}</b-card-title>
                    <b-card-sub-title class="problem-subtitle">{{problem.created_by.username}}</b-card-sub-title>
                    <b-card-text class="problem-text">
                      <p class="content">{{problem.start_time | localtime('YYYY-M-D HH:mm')}} - {{problem.end_time | localtime('YYYY-M-D HH:mm')}}</p> 
                    </b-card-text>
                    <b-button pill variant="outline-primary" @click="goGeneralProblem(problem._id)" style="float: right;"><b>더보기</b></b-button>
                  </b-card-body>
                </b-card>
              </div>
              </b-tab>
              
              <b-tab title="수업용" id="contest-content">
              <div id="problem-group">
                <b-card v-for="problem in classproblemList"
                            :key="problem.title"
                            :img-src='`../../../../../static/img/${problem.id}.jpg`'
                            img-left
                            img-height="200"
                            img-width="400"
                            shadow
                            class="mb-2 problem-card">
                  <b-card-body class="problem-content">
                    <b-card-title class="problem-title" @click="goClassProblem(problem._id)">{{problem.title}}</b-card-title>
                    <b-card-sub-title class="problem-subtitle">{{problem.created_by.username}}</b-card-sub-title>
                    <b-card-text class="problem-text">
                      <p class="content">{{problem.start_time | localtime('YYYY-M-D HH:mm')}} - {{problem.end_time | localtime('YYYY-M-D HH:mm')}}</p>
                    </b-card-text>
                    <!--<b-button pill variant="outline-primary" @click="isModalViewed = true"><b>입장하기</b></b-button>
                    <ModalView v-if="isModalViewed" v-bind:problemID="problem._id" v-bind:problemPassword="problem.password" @close="isModalViewed = false"></ModalView>-->
                    <b-button pill variant="outline-primary" @click="goClassProblem(problem._id)"><b>입장하기</b></b-button>
                  </b-card-body>
                </b-card>
              </div>
              </b-tab>
            </b-tabs>
            <!--<p class="emphasis">{{profile.user_join_contest}}</p>-->
          </div>
          <!--<div class="left">
            <p>{{$t('m.UserHomeSolved')}}</p>
            <p class="emphasis">{{profile.accepted_number}}</p>
          </div>
          <div class="middle">
            <p>{{$t('m.UserHomeserSubmissions')}}</p>
            <p class="emphasis">{{profile.submission_number}}</p>
          </div>
          <div class="right">
            <p>{{$t('m.UserHomeScore')}}</p>
            <p class="emphasis">{{profile.total_score}}</p>
          </div>-->
        </div>
        <!--<div id="problems">
          <div v-if="problems.length">{{$t('m.List_Solved_Problems')}}
            <Poptip v-if="refreshVisible" trigger="hover" placement="right-start">
              <Icon type="ios-help-outline"></Icon>
              <div slot="content">
                <p>If you find the following problem id does not exist,<br> try to click the button.</p>
                <Button type="info" @click="freshProblemDisplayID">regenerate</Button>
              </div>
            </Poptip>
          </div>
          <p v-else>{{$t('m.UserHomeIntro')}}</p>
          <div class="btns">
            <div class="problem-btn" v-for="problemID of problems" :key="problemID">
              <Button type="ghost" @click="goProblem(problemID)">{{problemID}}</Button>
            </div>
          </div>
        </div>-->
        <div id="icons">
          <a :href="profile.github">
            <Icon type="social-github-outline" size="30"></Icon>
          </a>
          <a :href="'mailto:'+ profile.user.email">
            <Icon class="icon" type="ios-email-outline" size="30"></Icon>
          </a>
          <a :href="profile.blog">
            <Icon class="icon" type="ios-world-outline" size="30"></Icon>
          </a>
        </div>
      </div>
    </Card>
  </div>
</template>
<script>
  import { mapActions } from 'vuex'
  import time from '@/utils/time'
  import api from '@oj/api'

  export default {
    data () {
      return {
        username: '',
        profile: {},
        problems: [],
        problemlist: [],
        classproblemList: []
      }
    },
    mounted () {
      this.init()
    },
    methods: {
      ...mapActions(['changeDomTitle']),
      init () {
        this.username = this.$route.query.username
        api.getUserInfo(this.username).then(res => {
          this.changeDomTitle({title: res.data.data.user.username})
          this.profile = res.data.data
          this.getSolvedProblems()
          let registerTime = time.utcToLocal(this.profile.user.create_time, 'YYYY-MM-D')
          console.log('The guy registered at ' + registerTime + '.')
        }).then(res => {
          console.log('hihiasd')
          // this.createProblemList()
          this.getProblemList()
          this.getClassProblemList()
        })
      },
      getSolvedProblems () {
        let ACMProblems = this.profile.acm_problems_status.problems || {}
        let OIProblems = this.profile.oi_problems_status.problems || {}
        // todo oi problems
        let ACProblems = []
        for (let problems of [ACMProblems, OIProblems]) {
          Object.keys(problems).forEach(problemID => {
            if (problems[problemID]['status'] === 0) {
              ACProblems.push(problems[problemID]['_id'])
            }
          })
        }
        ACProblems.sort()
        this.problems = ACProblems
      },
      goSetting () {
        this.$router.push('/setting/profile')
      },
      goGeneralProblem (problemID) {
        this.$router.push({name: 'aiproblem-general-details', params: {problemID: problemID}})
      },
      goClassProblem (problemID) {
        this.$router.push({name: 'aiproblem-class-details', params: {problemID: problemID}})
      },
      freshProblemDisplayID () {
        api.freshDisplayID().then(res => {
          this.$success('Update successfully')
          this.init()
        })
      },
      getProblemList () {
        for (var i in this.profile.user_join_contest) {
          // console.log('general this.profile.user_join_contest', this.profile.user_join_contest)
          // console.log('i', i)
          api.getUserGeneralAIProblemList(this.profile.user_join_contest[i]).then(res => {
            // console.log('res.data.data', res.data.data)
            if (res.data.data.total) {
              this.problemlist.push(res.data.data.results[0])
              // console.log('res.data.data.results[0]', res.data.data.results[0])
            }
          })
          // this.problemlist = this.problemlist.reverse()
        }
        // console.log(this.problemlist)
      },
      getClassProblemList () {
        for (var i in this.profile.user_join_contest) {
          console.log('class this.profile.user_join_contest', this.profile.user_join_contest)
          api.getUserClassAIProblemList(this.profile.user_join_contest[i]).then(res => {
            if (res.data.data.total) {
              this.classproblemList.push(res.data.data.results[0])
              // console.log('class res.data.data.results[0]', res.data.data.results[0])
            }
          })
          // console.log('classProblemList', this.classProblemList)
        }
        // this.classproblemList = this.classproblemList.reverse()
      }
      // createProblemList () {
      //   // console.log('createProblemList in')
      //   for (var i in this.profile.user_join_contest) {
      //     console.log('this.profile.user_join_contest', this.profile.user_join_contest)
      //     console.log('i', i)
      //     api.getAIProblem(this.profile.user_join_contest[i]).then(res => {
      //       // console.log('res.data.data', res.data.data)
      //       this.problemlist.push(res.data.data)
      //       // console.log('반복')
      //       // console.log('AAAAAthis.problemlist', this.problemlist)
      //     })
      //   }
      //   console.log('ABNCDthis.problemlist', this.problemlist)
      //   // console.log('createProblemList out')
      // }
    },

    computed: {
      refreshVisible () {
        if (!this.username) return true
        if (this.username && this.username === this.$store.getters.user.username) return true
        return false
      }
    },
    watch: {
      '$route' (newVal, oldVal) {
        if (newVal !== oldVal) {
          this.init()
        }
      }
    }
  }
</script>

<style lang="less" scoped>
  .container {
    position: relative;
    width: 75%;
    margin: 170px auto;
    text-align: center;
    p {
      margin-top: 8px;
      margin-bottom: 8px;
    }
    .avatar-container {
      position: absolute;
      left: 50%;
      transform: translate(-50%);
      z-index: 1;
      top: -90px;
      .avatar {
        width: 140px;
        height: 140px;
        border-radius: 50%;
        box-shadow: 0 1px 1px 0;
      }
    }
    .emphasis {
      font-size: 20px;
      font-weight: 600;
    }
    #split {
      margin: 20px auto;
      width: 90%;
    }
    .flex-container {
      margin-top: 30px;

      border: 0.0625rem solid #D7E2EB;
      border-radius: 40px;
      padding: 50px;
      .left {
        flex: 1 1;
      }
      .middle {
        flex: 1 1;
        // border-left: 1px solid #999;
        // border-right: 1px solid #999;
      }
      .right {
        flex: 1 1;
      }
    }
    #problems {
      margin-top: 40px;
      padding-left: 30px;
      padding-right: 30px;
      font-size: 18px;
      .btns {
        margin-top: 15px;
        .problem-btn {
          display: inline-block;
          margin: 5px;
        }
      }
    }
    #icons {
      position: absolute;
      bottom: 20px;
      left: 50%;
      transform: translate(-50%);
      .icon {
        padding-left: 20px;
      }
    }
  }
  .taglist-title {
    margin-left: -10px;
    margin-bottom: -10px;
  }

  .tag-btn {
    margin-right: 5px;
    margin-bottom: 10px;
  }
  
  .setting-btn {
    font-size: 16px; 
    font-weight: bold; 
    background: rgb(48, 33, 184);
    color: white; 
    float: right;
    padding: 0.4rem 0.8rem;
    line-height: 1.125rem;
    margin-top: -40px;
  }

  #pick-one {
    margin-top: 10px;
  }
  
  #card-deck{
    display: flex;
  }

  #problem-group{
    padding: 20px;

    .problem-card{
      border-radius: 20px 20px 20px 20px;
      margin-bottom: 10px;
    }
    img {
      border-radius: 20px 20px 20px 20px;
    }

    .problem-content{
      margin-bottom: -25px;
    }
    .problem-title{
      font-size: 22px;
      font-weight: bold;
      color: #3399ff;
    }
    .problem-subtitle{
      font-size: 16px;
    }
    .problem-text{
      font-weight: 600;
      color: #686868;
    }
  }

  
  #list {
    margin-bottom: 10px;
    margin-top: 20px;
    ul {
      margin-top: 20px;
      margin-bottom: 20px;
      list-style-type: none;
      li {
        margin-bottom: 1px;
        p {
          display: inline-block;
        }
        p:first-child {
          width: 50px;
        }
        p:last-child {
          float: right;
        }
      }
    }
  }
</style>