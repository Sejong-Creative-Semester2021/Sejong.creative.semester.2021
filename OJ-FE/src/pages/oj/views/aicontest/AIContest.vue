<template>
  <Row type="flex" :gutter="18" align="center">
    <Col id="problem-main" :span=17>
      <!--problem main-->
      <!--<img class="problem-img" src="https://i.postimg.cc/rFSwYd77/banner1.jpg">-->
      <Panel :padding="40" shadow>
        <div style="padding:40px 0px 40px 0px">
          <div class="problem-title" slot="title" style="display:inline-block">{{problem.title}}</div>
          <div style="display:inline-block; float: right; margin-top: 30px; margin-bottom: 20px;">
            <b-button variant="primary" @click="join" :disabled="alreadyJoined == true">참여</b-button>
          </div>
        </div>
        <div id="problem-content">
          <b-tabs content-class="mt-3 tabs" align="center" pills card fill>
            <b-tab title="대회안내" id="contest-content">
              <p class="subtitle">{{'대회 주요 일정'}}</p>
              <b-tabs content-class="mt-3" fill>
                <b-tab title="개요"><p class="markdown-body content" v-html=problem.contest_description></p></b-tab>
                <b-tab title="규칙"><p class="markdown-body content" v-html=problem.rule_description></p></b-tab>
                <b-tab title="일정"><p class="markdown-body content" v-html=problem.schedule_description></p></b-tab>
              </b-tabs>
            </b-tab>
            <b-tab title="데이터">
              <b-button class="download-button" variant="light" name="Download Data" @click="downloadData(problem.id)" :disabled="alreadyJoined == false">다운로드</b-button>
              <p class="subtitle">{{'설명'}}</p>
              <b-card class="data-card">
                <b-text>
                  <p class="markdown-body content" v-html=problem.data_description></p>
                </b-text>
              </b-card>
            </b-tab>
            <b-tab title="리더보드">
              <div>
                <v-data-table
                  :headers="headers"
                  :items="itemsWithIndex"
                  :items-per-page="5"
                  class="elevation-1"
                >
                </v-data-table>
              </div>
              <!--<Table :data="problem.rank" :columns="columns" size="large"></Table>-->
            </b-tab>
            <b-tab title="제출">
            <p class="subtitle">{{'제출'}}</p>
              <b-card>
                <upload
                  action="/api/upload_csv"
                  name="file"
                  :data="{id: problem._id}"
                  :show-file-list="true"
                  :on-success="uploadFileSucceeded">
                  <button size="small" type="primary" icon="el-icon-fa-upload">Choose File</button>
                </upload>
                <!-- <v-file-input truncate-length="15" @change="uploadFile"></v-file-input> -->
                <!--<v-file-input
                  accept=".csv"
                  label="Click here to select a .csv file"
                  outlined
                  @change="selectFile"
                ></v-file-input>-->
                <v-btn right @click="submit" :disabled="alreadyJoined == false">제출</v-btn>
                <p>{{ data }}</p>
                <!-- <b-form-file
                  v-model="file1"
                  placeholder="Choose a file or drop it here..."
                  drop-placeholder="Drop file here..."
                  size="lg"
                ></b-form-file>
                <div class="mt-3">Selected file: {{ file1 ? file1.name : '' }}</div> -->
              </b-card>
            </b-tab>
          </b-tabs>
        </div>
      </Panel>
    </Col>
  </Row>
</template>
<script src="https://cdn.jsdelivr.net/npm/danfojs@0.3.3/lib/bundle.min.js"></script> 
<script>
  import {mapGetters, mapActions} from 'vuex'
  import {types} from '../../../../store'
  import CodeMirror from '@oj/components/CodeMirror.vue'
  import storage from '@/utils/storage'
  import {FormMixin} from '@oj/components/mixins'
  import {JUDGE_STATUS, CONTEST_STATUS, buildProblemCodeKey, RULE_TYPE} from '@/utils/constants'
  import api from '@oj/api'
  import {pie, largePie} from './chartData'
  import utils from '@/utils/utils'
  // import * as dfd from 'danfojs/danfojs/src'
  // import {DataFrame} from 'danfojs/dist/core/frame'
  // import {Series} from 'danfojs/dist/core/series'
  // import './App.css'
  // import * as dfd from 'danfojs'
  // import * as dfd from 'danfojs/danfojs/src/index'

  // 只显示这些状态的图形占用
  const filtedStatus = ['-1', '-2', '0', '1', '2', '3', '4', '8']

  export default {
    name: 'AIContest',
    components: {
      CodeMirror
    },
    mixins: [FormMixin],
    data () {
      return {
        // table 추가 부분
        headers: [
          // {
          //   text: 'rank',
          //   align: 'start',
          //   sortable: false,
          //   value: 'rankDict'
          // },
          { text: 'rank', value: 'index' },
          { text: 'score', value: 'score', sortable: false },
          { text: 'name', value: 'username', sortable: false },
          { text: 'submitTime', value: 'submitTime', sortable: false }
        ],
        showRanks: [],
        today: null,
        submitTime: null,
        // 추가 부분
        solutionIdGet: null,
        predictIdGet: null,
        page: 1,
        limit: 30,
        total: 0,
        chosenFile: '',
        data: null,
        rank: null,
        username: '',
        profile: {},
        y_score: null,
        alreadyJoined: false,
        join_contest: [],
        user_join_contest: [],
        // dataRank: [],
        // showRank: [],
        // 추가 부분
        columns: [
          {
            align: 'center',
            width: 60,
            render: (h, params) => {
              return h('span', {}, params.index + (this.page - 1) * this.limit + 1)
            }
          },
          {
            title: this.$i18n.t('m.User_User'),
            align: 'center',
            render: (h, params) => {
              return h('a', {
                style: {
                  'display': 'inline-block',
                  'max-width': '200px'
                },
                on: {
                  click: () => {
                    this.$router.push(
                      {
                        name: 'user-home',
                        query: {username: params.row.user.username}
                      })
                  }
                }
              }, params.row.user.username)
            }
          },
          {
            title: this.$i18n.t('m.mood'),
            align: 'center',
            key: 'mood'
          },
          {
            title: this.$i18n.t('m.AC'),
            align: 'center',
            key: 'accepted_number'
          },
          {
            title: this.$i18n.t('m.Total'),
            align: 'center',
            key: 'submission_number'
          },
          {
            title: this.$i18n.t('m.Rating'),
            align: 'center',
            render: (h, params) => {
              return h('span', utils.getACRate(params.row.accepted_number, params.row.submission_number))
            }
          }
        ],
        statusVisible: false,
        captchaRequired: false,
        graphVisible: false,
        submissionExists: false,
        captchaCode: '',
        captchaSrc: '',
        contestID: '',
        problemID: '',
        submitting: false,
        code: '',
        language: 'C++',
        theme: 'solarized',
        submissionId: '',
        submitted: false,
        result: {
          result: 9
        },
        problem: {
          title: '',
          description: '',
          summary_description: '',
          rule_description: '',
          schedule_description: '',
          testhint: '',
          my_status: '',
          template: {},
          languages: [],
          created_by: {
            username: ''
          },
          tags: [],
          io_mode: {'io_mode': 'Standard IO'}
        },
        pie: pie,
        largePie: largePie,
        // echarts 无法获取隐藏dom的大小，需手动指定
        largePieInitOpts: {
          width: '500',
          height: '480'
        }
      }
    },
    beforeRouteEnter (to, from, next) {
      let problemCode = storage.get(buildProblemCodeKey(to.params.problemID, to.params.contestID))
      if (problemCode) {
        next(vm => {
          vm.language = problemCode.language
          vm.code = problemCode.code
          vm.theme = problemCode.theme
        })
      } else {
        next()
      }
    },
    mounted () {
      this.$store.commit(types.CHANGE_CONTEST_ITEM_VISIBLE, {menu: false})
      this.init()
    },
    methods: {
      ...mapActions(['changeDomTitle']),
      init () {
        this.$Loading.start()
        this.$router.push(this.route)
        this.contestID = this.$route.params.contestID
        console.log('this.$route', this.$route)
        this.problemID = this.$route.params.problemID
        console.log('this.$route.params', this.$route.params)
        this.username = this.$route.params.username
        let func = this.$route.name === 'aiproblem-details' ? 'getAIProblem' : 'getContestProblem'
        console.log(func)
        api[func](this.problemID, this.contestID).then(res => {
          this.$Loading.finish()
          let problem = res.data.data
          console.log(problem)
          console.log(problem.id)
          console.log('problem rank', problem.rank)
          console.log('problem join_contest', problem.join_contest)
          // this.join_contest = problem.join_contest
          console.log('this.join_contest', this.join_contest)
          this.showRanks = problem.rank
          for (let v in this.showRanks) {
            this.showRanks[v]['score'] = this.showRanks[v]['score'].toFixed(4)
            console.log('this.showRanks[v][score]', this.showRanks[v]['score'])
          }
          // this.showRank.append(problem.rank)
          console.log('show Ranks', this.showRanks)
          this.changeDomTitle({title: problem.title})
          console.log('10')
          // api.submissionExists(problem.id).then(res => {
          //   this.submissionExists = res.data.data
          // })
          // problem.languages = problem.languages.sort()
          this.problem = problem
          // this.changePie(problem)
          // 在beforeRouteEnter中修改了, 说明本地有code，无需加载template
          if (this.code !== '') {
            return
          }
          console.log('1')
          // // try to load problem template
          // this.language = this.problem.languages[0]
          // let template = this.problem.template
          // if (template && template[this.language]) {
          //   this.code = template[this.language]
          // }
          console.log('2')
        }, () => {
          this.$Loading.error()
        }).then(res => {
          api.getUserInfo(this.username).then(res => {
            this.profile = res.data.data
            console.log('this.profile', this.profile)
            this.username = this.profile.user.username
            this.join_contest = this.profile.user_join_contest
          }).then(res => {
            // console.log('this.username', this.username)
            // console.log('before this.alreadyJoined', this.alreadyJoined)
            console.log(this.problem._id)
            this.alreadyJoined = this.join_contest.includes(this.problem._id)
            // console.log('after this.alreadyJoined', this.alreadyJoined)
          })
        })
      },
      downloadData (problemID) {
        let url = '/data_csv?problem_id=' + problemID
        console.log(problemID)
        utils.downloadFile(url)
      },
      // 추가 부분
      importTxt () {
        if (!this.chosenFile) { this.data = 'No File Chosen' }
        this.data = this.chosenFile
        console.log(this.data)
        api.upload_file(this.problem.id, this.data)
      },
      uploadFile (e) {
        // let file = e
        console.log(e)
      },
      // 추가 부분
      uploadFileSucceeded (response) {
        console.log(response)
        console.log(response.data)
        if (response.error) {
          this.$error(response.data)
          return
        }
        this.y_score = response.data.y_score
        console.log('y_score', response.data.y_score)
        this.solutionIdGet = response.data.solutionId
        this.predictIdGet = response.data.predictId
        console.log('solutionIdGet', this.solutionIdGet)
        console.log('predictIdGet', this.predictIdGet)
        // this.problem.solution_id = response.data.id
        // 여기서 이름 가져오고 y_score랑 같이 rank에 저장
        this.getUserName()
        // 여기서 api 사용해서 editrank사용
        // problem._id 를 사용하기
        console.log('before editRank')
        console.log('problem id', this.problem._id)
        console.log('rank', this.rank)
        // api['editRank'](this.problem._id, this.rank)
        // api.getAIProblem(this.problem._id).then(res => {
        //   console.log('in editRank')
        //   console.log(res)
        // })
        console.log('after')
      },
      // 날짜 추가
      addDay () {
        this.today = new Date()
        var year = this.today.getFullYear()
        var month = ('0' + (this.today.getMonth() + 1)).slice(-2)
        var day = ('0' + this.today.getDate()).slice(-2)
        var dateString = year + '-' + month + '-' + day
        var hours = ('0' + this.today.getHours()).slice(-2)
        var minutes = ('0' + this.today.getMinutes()).slice(-2)
        var seconds = ('0' + this.today.getSeconds()).slice(-2)
        var timeString = hours + ':' + minutes + ':' + seconds
        console.log('this.today', this.today)
        console.log('dateString', dateString)
        console.log('timeString', timeString)
        this.submitTime = dateString + ' ' + timeString
      },
      // 유저 이름 추가하는 부분
      getUserName () {
        api.getUserInfo(this.username).then(res => {
          this.changeDomTitle({title: res.data.data.user.username})
          this.profile = res.data.data
          // console.log('11111')
          // console.log(this.profile)
          // console.log('22222')
          // console.log(this.profile.user.username)
          this.addDay()
          this.rank = [{
            'userid': this.profile.user.id,
            'username': this.profile.user.username,
            'score': this.y_score,
            'submitTime': this.submitTime
          }]
          console.log('getUserName', this.rank)
          console.log('editrank - getuser before')
          // api['editRank'](this.problem._id, this.rank)
          console.log('editrank - getuser after')
          // this.load_csv()
          // this.getSolvedProblems()
          // let registerTime = time.utcToLocal(this.profile.user.create_time, 'YYYY-MM-D')
          // console.log('The guy registered at ' + registerTime + '.')
          // 이름 가져오는 방법
          // <span v-if="profile.user" class="emphasis">{{profile.user.username}}</span>
        })
      },
      // getRankData (page) {
      //   let offset = (page - 1) * this.limit
      //   let bar = this.$refs.chart
      //   bar.showLoading({maskColor: 'rgba(250, 250, 250, 0.8)'})
      //   if (page == 1) {
      //     this.changeCharts(res.data.data.results.slice(0, 10))
      //   }
      //   this.total = res.data.data.total
      //   this.dataRank = res.data.data.results
      //   bar.hideLoading()
      // },
      // join 가져오는 함수 추가
      join () {
        api.editJoinContest(this.username, this.problem._id)
        this.alreadyJoined = true
        api.getUserInfo(this.username).then(res => {
          this.profile = res.data.data
          // console.log('this.profile', this.profile)
          // this.user_join_contest
          this.profile.user_join_contest.push(this.problem._id)
          console.log('this.profile.user_join_contest', this.profile.user_join_contest)
          api.updateProfileJoinContest(this.profile).then(res => {
            console.log('updateProfileJoinContest out')
          })
        })
      },
      submit () {
        console.log('submit button')
        api['editRank'](this.problem._id, this.rank)
        this.$router.go()
        console.log('submit button2')
      },
      changePie (problemData) {
        // 只显示特定的一些状态
        for (let k in problemData.statistic_info) {
          if (filtedStatus.indexOf(k) === -1) {
            delete problemData.statistic_info[k]
          }
        }
        let acNum = problemData.accepted_number
        let data = [
          {name: 'WA', value: problemData.submission_number - acNum},
          {name: 'AC', value: acNum}
        ]
        this.pie.series[0].data = data
        // 只把大图的AC selected下，这里需要做一下deepcopy
        let data2 = JSON.parse(JSON.stringify(data))
        data2[1].selected = true
        this.largePie.series[1].data = data2

        // 根据结果设置legend,没有提交过的legend不显示
        let legend = Object.keys(problemData.statistic_info).map(ele => JUDGE_STATUS[ele].short)
        if (legend.length === 0) {
          legend.push('AC', 'WA')
        }
        this.largePie.legend.data = legend

        // 把ac的数据提取出来放在最后
        let acCount = problemData.statistic_info['0']
        delete problemData.statistic_info['0']

        let largePieData = []
        Object.keys(problemData.statistic_info).forEach(ele => {
          largePieData.push({name: JUDGE_STATUS[ele].short, value: problemData.statistic_info[ele]})
        })
        largePieData.push({name: 'AC', value: acCount})
        this.largePie.series[0].data = largePieData
      },
      handleRoute (route) {
        console.log('asdfasdfasdfasdfasdfadfsdfsd', route)
        this.$router.push(route)
        console.log('asdfasdfasdfasdfasdfadfsdfsd', route)
      },
      onChangeLang (newLang) {
        if (this.problem.template[newLang]) {
          if (this.code.trim() === '') {
            this.code = this.problem.template[newLang]
          }
        }
        this.language = newLang
      },
      onChangeTheme (newTheme) {
        this.theme = newTheme
      },
      onResetToTemplate () {
        this.$Modal.confirm({
          content: this.$i18n.t('m.Are_you_sure_you_want_to_reset_your_code'),
          onOk: () => {
            let template = this.problem.template
            if (template && template[this.language]) {
              this.code = template[this.language]
            } else {
              this.code = ''
            }
          }
        })
      },
      checkSubmissionStatus () {
        // 使用setTimeout避免一些问题
        if (this.refreshStatus) {
          // 如果之前的提交状态检查还没有停止,则停止,否则将会失去timeout的引用造成无限请求
          clearTimeout(this.refreshStatus)
        }
        const checkStatus = () => {
          let id = this.submissionId
          api.getSubmission(id).then(res => {
            this.result = res.data.data
            if (Object.keys(res.data.data.statistic_info).length !== 0) {
              this.submitting = false
              this.submitted = false
              clearTimeout(this.refreshStatus)
              this.init()
            } else {
              this.refreshStatus = setTimeout(checkStatus, 2000)
            }
          }, res => {
            this.submitting = false
            clearTimeout(this.refreshStatus)
          })
        }
        this.refreshStatus = setTimeout(checkStatus, 2000)
      },
      selectFile (file) {
        this.chosenFile = file
      },
      submitCode () {
        if (this.code.trim() === '') {
          this.$error(this.$i18n.t('m.Code_can_not_be_empty'))
          return
        }
        this.submissionId = ''
        this.result = {result: 9}
        this.submitting = true
        let data = {
          problem_id: this.problem.id,
          language: this.language,
          code: this.code,
          contest_id: this.contestID
        }
        if (this.captchaRequired) {
          data.captcha = this.captchaCode
        }
        const submitFunc = (data, detailsVisible) => {
          this.statusVisible = true
          api.submitCode(data).then(res => {
            this.submissionId = res.data.data && res.data.data.submission_id
            // 定时检查状态
            this.submitting = false
            this.submissionExists = true
            if (!detailsVisible) {
              this.$Modal.success({
                title: this.$i18n.t('m.Success'),
                content: this.$i18n.t('m.Submit_code_successfully')
              })
              return
            }
            this.submitted = true
            this.checkSubmissionStatus()
          }, res => {
            this.getCaptchaSrc()
            if (res.data.data.startsWith('Captcha is required')) {
              this.captchaRequired = true
            }
            this.submitting = false
            this.statusVisible = false
          })
        }

        if (this.contestRuleType === 'OI' && !this.OIContestRealTimePermission) {
          if (this.submissionExists) {
            this.$Modal.confirm({
              title: '',
              content: '<h3>' + this.$i18n.t('m.You_have_submission_in_this_problem_sure_to_cover_it') + '<h3>',
              onOk: () => {
                // 暂时解决对话框与后面提示对话框冲突的问题(否则一闪而过）
                setTimeout(() => {
                  submitFunc(data, false)
                }, 1000)
              },
              onCancel: () => {
                this.submitting = false
              }
            })
          } else {
            submitFunc(data, false)
          }
        } else {
          submitFunc(data, true)
        }
      },
      onCopy (event) {
        this.$success('Code copied')
      },
      onCopyError (e) {
        this.$error('Failed to copy code')
      }
    },
    computed: {
      ...mapGetters(['problemSubmitDisabled', 'contestRuleType', 'OIContestRealTimePermission', 'contestStatus']),
      contest () {
        return this.$store.state.contest.contest
      },
      contestEnded () {
        return this.contestStatus === CONTEST_STATUS.ENDED
      },
      submissionStatus () {
        return {
          text: JUDGE_STATUS[this.result.result]['name'],
          color: JUDGE_STATUS[this.result.result]['color']
        }
      },
      submissionRoute () {
        if (this.contestID) {
          return {name: 'contest-submission-list', query: {problemID: this.problemID}}
        } else {
          return {name: 'submission-list', query: {problemID: this.problemID}}
        }
      },
      // showRanks에 index 추가
      itemsWithIndex () {
        return this.showRanks.map(
          (showRanks, index) => ({
            ...showRanks,
            index: index + 1
          }))
      }
    },
    beforeRouteLeave (to, from, next) {
      // 防止切换组件后仍然不断请求
      clearInterval(this.refreshStatus)

      this.$store.commit(types.CHANGE_CONTEST_ITEM_VISIBLE, {menu: true})
      storage.set(buildProblemCodeKey(this.problem._id, from.params.contestID), {
        code: this.code,
        language: this.language,
        theme: this.theme
      })
      next()
    },
    watch: {
      '$route' () {
        this.init()
      }
    }
  }
</script>

<style lang="less" scoped>
  .problem-title {
    margin-top: 20px;
    margin-bottom: 20px;
    font-size: 30px;
    font-weight: 750;
  }

  .card-title {
    margin-left: 8px;
  }

  .flex-container {
    #problem-main {
      flex: auto;
      margin-right: 18px;
    }
    #right-column {
      flex: none;
      width: 220px;
    }
  }

  .subtitle{
    font-size: 18px;
    font-weight: bold;
  }
  
  .data-card{
    margin-top: 15px;
    margin-bottom: 15px;
  }

  .download-button{
    font-weight: bold;
    float: right;
  }

  #problem-content {
    margin-top: -40px;
    .tabs {
      font-weight: bold;
      font-size: 16px;
    }
    .card-img-top{
      width: 40rem;
    }
    .title {
      font-size: 27px;
      font-weight: 730;
      margin: 25px 0 8px 0;
      margin-bottom: 20px;
      .copy {
        padding-left: 10px;
      }
    }
    p.content {
      margin-left: 25px;
      margin-right: 20px;
      font-size: 15px
    }
    .sample {
      align-items: stretch;
      &-input, &-output {
        width: 50%;
        flex: 1 1 auto;
        display: flex;
        flex-direction: column;
        margin-right: 5%;
      }
      pre {
        flex: 1 1 auto;
        align-self: stretch;
        border-style: solid;
        background: transparent;
      }
    }
  }

  #contest-content{
    text-align: center;
    font-weight: bold;
    .subtitle{
      margin-top: 50px;
    }
    p.content {
      text-align: left;
      margin-bottom: 50px;
    }
  }

  #submit-code {
    margin-top: 20px;
    margin-bottom: 20px;
    .status {
      float: left;
      span {
        margin-right: 10px;
        margin-left: 10px;
      }
    }
    .captcha-container {
      display: inline-block;
      .captcha-code {
        width: auto;
        margin-top: -20px;
        margin-left: 20px;
      }
    }
  }

  #info {
    margin-bottom: 20px;
    margin-top: 20px;
    ul {
      list-style-type: none;
      li {
        border-bottom: 1px dotted #e9eaec;
        margin-bottom: 10px;
        p {
          display: inline-block;
        }
        p:first-child {
          width: 90px;
        }
        p:last-child {
          float: right;
        }
      }
    }
  }

  .fl-right {
    float: right;
  }

  #pieChart {
    .echarts {
      height: 250px;
      width: 210px;
    }
    #detail {
      position: absolute;
      right: 10px;
      top: 10px;
    }
  }

  #pieChart-detail {
    margin-top: 20px;
    width: 500px;
    height: 480px;
  }
</style>