<template>
  <Row type="flex" :gutter="18" align="center">
    <Col :span=14>
      <div style="font-size: 35px; font-weight: 800;"><b>{{'진행중인 대회'}}</b></div>
      <p style="color: gray; font-size: 20px; font-weight: bold;"> 지금 바로 대회에 참여해보세요.</p>
      <b-card-group deck id="problem-group">
        <div v-for="problem in problemList" :key="problem.title" style="margin-bottom: 10px">
          <b-card :img-src='`../../../../../static/img/${problem.id}.jpg`'
                  img-top
                  style="min-width: 10rem; max-width: 20rem; border-radius: 20px;"
                  class="mb-3"
                  id="problem-card"
                  @click="goProblem(problem._id)">
            <b-card-body class="problem-content">
              <b-card-title class="problem-title" @click="goProblem(problem._id)">{{problem.title}}</b-card-title>
              <!--<b-card-sub-title class="problem-subtitle">{{problem.created_by.username}}</b-card-sub-title>-->
              <div class="problem-describe">
                <b-card-text class="problem-text">
                  <b-progress height="8px" :value="getProgress(problem.start_time, problem.end_time)" class="mb-3"></b-progress>
                  <div class="row ml-1 mr-1 mb-1" style="font-size: 17px">
                    <span class="content">{{problem.start_time | localtime('YYYY-M-D')}}</span>
                    <div class="spacer"></div>
                    <span>{{getDuration(problem.start_time, problem.end_time)}}</span>
                  </div>
                </b-card-text>  
                <b-card-text class="problem-tag">
                  <span v-for="tag in problem.tags" :key="tag.name">
                    <Button type="ghost"
                            size="small"
                            shape="circle"
                            class="tag-btn"
                            style="margin-top: 3px; font-size: 15px;">{{tag}}
                    </Button>
                  </span>
                </b-card-text>  
              </div>
              <!--<b-button variant="dark" size="sm" style="border-radius: 1rem; " @click="goProblem(problem._id)">JOIN</b-button>-->
            </b-card-body>
          </b-card>
        </div>
      </b-card-group>

    </Col>
  </Row>
</template>

<script>
  import {mapGetters} from 'vuex'
  import api from '@oj/api'
  import utils from '@/utils/utils'
  import { ProblemMixin } from '@oj/components/mixins'
  import Pagination from '@oj/components/Pagination'
  import time from '@/utils/time'

  export default {
    name: 'AIContestList',
    mixins: [ProblemMixin],
    components: {
      Pagination
    },
    data () {
      return {
        // tagList: [],
        bar_value: '70',
        imgpath: '',
        // currentTime: '',
        day: null,
        problemTableColumns: [
          {
            title: '#',
            key: '_id',
            width: 80,
            render: (h, params) => {
              return h('Button', {
                props: {
                  type: 'text',
                  size: 'large'
                },
                on: {
                  click: () => {
                    this.$router.push({name: 'aiproblem-details', params: {problemID: params.row._id}})
                  }
                },
                style: {
                  padding: '2px 0'
                }
              }, params.row._id)
            }
          },
          {
            title: this.$i18n.t('m.Title'),
            width: 400,
            render: (h, params) => {
              return h('Button', {
                props: {
                  type: 'text',
                  size: 'large'
                },
                on: {
                  click: () => {
                    this.$router.push({name: 'aiproblem-details', params: {problemID: params.row._id}})
                  }
                },
                style: {
                  padding: '2px 0',
                  overflowX: 'auto',
                  textAlign: 'left',
                  width: '100%'
                }
              }, params.row.title)
            }
          },
          {
            title: this.$i18n.t('m.Level'),
            render: (h, params) => {
              let t = params.row.difficulty
              let color = 'blue'
              if (t === 'Low') color = 'green'
              else if (t === 'High') color = 'yellow'
              return h('Tag', {
                props: {
                  color: color
                }
              }, this.$i18n.t('m.' + params.row.difficulty))
            }
          },
          {
            title: this.$i18n.t('m.Total'),
            key: 'submission_number'
          },
          {
            title: this.$i18n.t('m.AC_Rate'),
            render: (h, params) => {
              return h('span', this.getACRate(params.row.accepted_number, params.row.submission_number))
            }
          }
        ],
        problemList: [],
        generalProblemList: [],
        limit: 20,
        total: 0,
        loadings: {
          table: true
        },
        routeName: '',
        query: {
          keyword: '',
          difficulty: '',
          page: 1,
          limit: 10
        }
      }
    },
    mounted () {
      this.init()
    },
    methods: {
      init (simulate = false) {
        this.routeName = this.$route.name
        let query = this.$route.query
        this.query.difficulty = query.difficulty || ''
        this.query.keyword = query.keyword || ''
        this.query.page = parseInt(query.page) || 1
        if (this.query.page < 1) {
          this.query.page = 1
        }
        this.query.limit = parseInt(query.limit) || 10
        this.getProblemList()
      },
      pushRouter () {
        this.$router.push({
          name: 'aiproblem-list',
          query: utils.filterEmptyValue(this.query)
        })
      },
      // 추가 부분
      goProblem (problemID) {
        this.$router.push({name: 'aiproblem-general-details', params: {problemID: problemID}})
      },
      getProblemList () {
        let offset = (this.query.page - 1) * this.query.limit
        this.loadings.table = true
        api.getGeneralAIProblemList(offset, this.limit, this.query).then(res => {
          this.loadings.table = false
          this.total = res.data.data.total
          this.problemList = res.data.data.results
          if (this.isAuthenticated) {
            this.addStatusColumn(this.problemTableColumns, res.data.data.results)
          }
        }, res => {
          this.loadings.table = false
        })
      },
      getDuration (startTime, endTime) {
        // console.log(time.duration(startTime, endTime))
        // this.currentTime = new Date()
        var year = endTime.slice(0, 4)
        var month = endTime.slice(5, 7)
        var day = endTime.slice(8, 10)
        // console.log('endTime', endTime)
        // console.log(year, month, day)
        var Dday = new Date(year, month - 1, day)
        var nowTime = Date.now()
        var gap = nowTime - Dday.getTime()
        // console.log('gap1', gap)
        // console.log('nowTime', nowTime)
        // console.log('Dday', Dday)
        var result = Math.floor(gap / (1000 * 60 * 60 * 24)) * -1
        // console.log('result', result)
        if (result === 0) {
          result = 'D-day'
        }
        if (result > 0) { // 평상시 상황
          result = 'D-' + result
        }
        if (result < 0) { // dday 지난 경우
          result = '종료'
        }
        // 지금 시간이 대회 시작 날짜보다 이전이면...
        var startDay = new Date(startTime.slice(0, 4), startTime.slice(5, 7) - 1, startTime.slice(8, 10))
        console.log('nowTime', nowTime)
        console.log('startDay.getTime()', startDay.getTime())
        gap = nowTime - startDay.getTime()
        var result2 = Math.floor(gap / (1000 * 60 * 60 * 24)) * -1
        console.log('gap2', gap)
        if (gap < 0) {
          result = 'OPEN D-' + result2
        }
        return result
      },
      getProgress (startTime, endTime) {
        // totalDay 계산
        var startDay = new Date(startTime.slice(0, 4), startTime.slice(5, 7) - 1, startTime.slice(8, 10))
        var endDay = new Date(endTime.slice(0, 4), endTime.slice(5, 7) - 1, endTime.slice(8, 10))
        var gap1 = startDay.getTime() - endDay.getTime()
        var totalDay = Math.floor(gap1 / (1000 * 60 * 60 * 24)) * -1
        // result 계산
        var year = endTime.slice(0, 4)
        var month = endTime.slice(5, 7)
        var day = endTime.slice(8, 10)
        var Dday = new Date(year, month - 1, day)
        var nowTime = Date.now()
        var gap2 = nowTime - Dday.getTime()
        var result = Math.floor(gap2 / (1000 * 60 * 60 * 24)) * -1
        console.log('totalDay', totalDay)
        console.log('result', result)
        var barValue = ((totalDay - result) / totalDay) * 100
        console.log('barValue', barValue)
        return barValue
      },
      filterByDifficulty (difficulty) {
        this.query.difficulty = difficulty
        this.query.page = 1
        this.pushRouter()
      },
      filterByKeyword () {
        this.query.page = 1
        this.pushRouter()
      },
      onReset () {
        this.$router.push({name: 'aiproblem-list'})
      },
      pickone () {
        api.pickone().then(res => {
          this.$success('Good Luck')
          this.$router.push({name: 'aiproblem-details', params: {problemID: res.data.data}})
        })
      }
    },
    computed: {
      ...mapGetters(['isAuthenticated'])
    },
    watch: {
      '$route' (newVal, oldVal) {
        if (newVal !== oldVal) {
          this.init(true)
        }
      },
      'isAuthenticated' (newVal) {
        if (newVal === true) {
          this.init()
        }
      }
    }
  }
</script>

<style scoped lang="less">

  .taglist-title {
    margin-left: -10px;
    margin-bottom: -10px;
  }

  .tag-btn {
    margin-right: 5px;
    margin-bottom: 10px;
  }

  #pick-one {
    margin-top: 10px;
  }
  
  #card-deck{
    display: flex;
  }

  .card-body {
    padding: 20px 5px 0;
  }

  #problem-group{
    .card {
      border: 1px solid rgba(0, 0, 0, 0);
    }
    img {
      cursor: pointer;
      border-radius: 20px 20px 20px 20px;
    }
    .problem-content{
      height: 200px;
      margin-top: -25px;
      margin-bottom: -25px;
    }
    .problem-title{
      cursor: pointer;
      margin-top: 10px;
      font-size: 21px;
      font-weight: bold;
      overflow: hidden;
      text-overflow: ellipsis;
      display: -webkit-box;
      -webkit-line-clamp: 1;
      -webkit-box-orient: vertical;
    }
    .problem-subtitle{
      font-size: 16px;
      margin-top: 10px;
    }
    .problem-text{
      font-weight: 600;
      color: #686868;
    }
    .problem-describe {
      margin-bottom: -10px;
    }
  }




</style>

