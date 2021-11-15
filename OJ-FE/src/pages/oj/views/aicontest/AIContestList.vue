<template>
  <Row type="flex" :gutter="18" align="center">
    <Col :span=15>
    <Panel shadow>
      <div slot="title" style="font-size: 20px;"><b>{{$t('진행중인 대회')}}</b></div>
      <div slot="extra">
        <ul class="filter">
          <li>
            <Input v-model="query.keyword"
                   @on-enter="filterByKeyword"
                   @on-click="filterByKeyword"
                   placeholder="검색"
                   icon="ios-search-strong"/>
          </li>
        </ul>
      </div>
      <!-- 추가 부분 -->
      <b-tabs content-class="block mt-3 tabs" pills fill >
        <b-tab title="일반용" id="contest-content" href="/">
        <div id="problem-group">
          <b-card v-for="problem in problemList"
                      :key="problem.title"
                      :img-src='`../../../../../static/img/${problem.id}.jpg`'
                      img-left
                      img-height="100"
                      img-width="200"
                      shadow
                      class="mb-3 problem-card">
            <b-card-body class="problem-content">
              <b-card-title class="problem-title" @click="goProblem(problem._id)">{{problem.title}}</b-card-title>
              <b-card-sub-title class="problem-subtitle">{{problem.created_by.username}}</b-card-sub-title>
              <b-card-text class="problem-text">
                <p class="content" style="font-size: 16px; float: right; margin-top: -40px;">{{problem.start_time | localtime('YYYY-M-D')}} - {{problem.end_time | localtime('YYYY-M-D')}}</p> 
                <span v-for="tag in problem.tags" :key="tag.name">
                  <Button @click="filterByTag(tag)"
                          type="ghost"
                          size="small"
                          shape="circle"
                          class="tag-btn"
                          style="margin-top: 3px;">{{tag}}
                  </Button>
                </span>
                <span style="font-size: 20px; float: right; margin-top:-8px; font-weight:bold;">D-{{getDuration(problem.start_time, problem.end_time)}}</span>
              </b-card-text>
              <!--<b-button pill variant="outline-primary" @click="goProblem(problem._id)" size="sm" style="float: right; margin-top: -60px;"><b>더보기</b></b-button>-->
            </b-card-body>
          </b-card>
        </div>
        </b-tab>

        <b-tab title="수업용" id="contest-content" @click="goRouter()">
        <!-- <div id="problem-group">
          <b-card v-for="problem in classproblemList"
                      :key="problem.title"
                      :img-src='`../../../../../static/img/${problem.id}.jpg`'
                      img-left
                      img-height="100"
                      img-width="200"
                      shadow
                      class="mb-3 problem-card">
            <b-card-body class="problem-content">
              <b-card-title class="problem-title" @click="goProblem(problem._id)">{{problem.title}}</b-card-title>
              <b-card-sub-title class="problem-subtitle">{{problem.created_by.username}}</b-card-sub-title>
              <b-card-text class="problem-text">
                <p class="content" style="font-size: 16px; float: right; margin-top: -40px;">{{problem.start_time | localtime('YYYY-M-D')}} - {{problem.end_time | localtime('YYYY-M-D')}}</p>
              </b-card-text>
              <b-button pill variant="outline-primary" @click="isModalViewed = true" size="sm" style="float: right; margin-top: -25px;"><b>입장하기</b></b-button>
              <ModalView v-if="isModalViewed" v-bind:problemID="problem._id" v-bind:problemPassword="problem.password" @close="isModalViewed = false"></ModalView>
            </b-card-body>
          </b-card>
        </div> -->
        </b-tab>
      </b-tabs>
    </Panel>
    </Col>
  </Row>
</template>

<script>
  import {mapGetters} from 'vuex'
  import api from '@oj/api'
  import utils from '@/utils/utils'
  import { ProblemMixin } from '@oj/components/mixins'
  import Pagination from '@oj/components/Pagination'
  import ModalView from '@oj/components/ModalView'
  import time from '@/utils/time'

  export default {
    name: 'AIContestList',
    mixins: [ProblemMixin],
    components: {
      Pagination,
      ModalView
    },
    data () {
      return {
        // tagList: [],
        isModalViewed: false,
        url: this.$route.path + '/class',
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
        classproblemList: [],
        limit: 20,
        total: 0,
        loadings: {
          table: true,
          tag: true
        },
        currentPath: '',
        routeName: '',
        query: {
          keyword: '',
          difficulty: '',
          tag: '',
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
        this.currentPath = this.$route.path
        this.routeName = this.$route.name
        let query = this.$route.query
        this.query.difficulty = query.difficulty || ''
        this.query.keyword = query.keyword || ''
        this.query.tag = query.tag || ''
        this.query.page = parseInt(query.page) || 1
        if (this.query.page < 1) {
          this.query.page = 1
        }
        this.query.limit = parseInt(query.limit) || 10
        // if (!simulate) {
        //   this.getTagList()
        // }
        this.getProblemList()
        this.getClassProblemList()
      },
      // 추가 부분
      getDuration (startTime, endTime) {
        var duration = time.duration(startTime, endTime)
        var day = duration.replace(/days|hours/, '')
        return day
      },
      goProblem (problemID) {
        this.$router.push({name: 'aiproblem-general-details', params: {problemID: problemID}})
      },
      goRouter () {
        this.$router.push({name: 'aiproblem-list-class'})
      },
      getProblemList () {
        let offset = (this.query.page - 1) * this.query.limit
        this.loadings.table = true
        api.getGeneralAIProblemList(offset, this.limit, this.query).then(res => {
          this.loadings.table = false
          this.total = res.data.data.total
          this.problemList = res.data.data.results
          this.problemList = this.problemList.reverse()
          if (this.isAuthenticated) {
            this.addStatusColumn(this.problemTableColumns, res.data.data.results)
          }
        }, res => {
          this.loadings.table = false
        })
      },
      getClassProblemList () {
        let offset = (this.query.page - 1) * this.query.limit
        this.loadings.table = true
        api.getClassAIProblemList(offset, this.limit, this.query).then(res => {
          this.loadings.table = false
          this.total = res.data.data.total
          this.classproblemList = res.data.data.results
          this.classproblemList = this.classproblemList.reverse()
          if (this.isAuthenticated) {
            this.addStatusColumn(this.problemTableColumns, res.data.data.results)
          }
        }, res => {
          this.loadings.table = false
        })
      },
      // getTagList () {
      //   api.getAIProblemTagList().then(res => {
      //     this.tagList = res.data.data
      //     this.loadings.tag = false
      //   }, res => {
      //     this.loadings.tag = false
      //   })
      // },
      filterByTag (tagName) {
        this.query.tag = tagName
        this.query.page = 1
        this.pushRouter()
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
      handleTagsVisible (value) {
        if (value) {
          this.problemTableColumns.push(
            {
              title: this.$i18n.t('m.Tags'),
              align: 'center',
              render: (h, params) => {
                let tags = []
                params.row.tags.forEach(tag => {
                  tags.push(h('Tag', {}, tag))
                })
                return h('div', {
                  style: {
                    margin: '8px 0'
                  }
                }, tags)
              }
            })
        } else {
          this.problemTableColumns.splice(this.problemTableColumns.length - 1, 1)
        }
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

  .tabs {
      font-weight: bold;
      font-size: 16px;
    }

  #problem-group{

    .problem-card{
      border-radius: 20px 20px 20px 20px;
      max-height: 100px;
    }
    img {
      border-radius: 20px 20px 20px 20px;
    }

    .problem-content{
      margin-top: -25px;
    }
    .problem-title{
      font-size: 18px;
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