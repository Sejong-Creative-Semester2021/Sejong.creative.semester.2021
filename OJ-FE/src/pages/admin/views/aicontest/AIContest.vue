<template>
  <div class="aicontest">
    <Panel :title="title">
      <el-form ref="form" :model="problem" :rules="rules" label-position="top" label-width="70px">
        <el-row :gutter="20">
          <el-col :span="6">
            <el-form-item :label="'유형'">
              <el-radio-group v-model="problem.p_type">
                <el-radio label="General">일반</el-radio>
                <el-radio label="Class">수업</el-radio> 
              </el-radio-group>
            </el-form-item>
          </el-col>
          <el-col :span="4" v-if="problem.p_type == 'Class'">
            <el-form-item :label="$t('비밀번호')">
              <el-input :placeholder="$t('비밀번호')" type="password" v-model="problem.password"></el-input>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="20">
          <el-col :span="6">
            <el-form-item prop="_id" :label="'문제 ID'"
                          :required="this.routeName === 'create-contest-problem' || this.routeName === 'edit-contest-problem'">
              <el-input :placeholder="'문제 ID'" v-model="problem._id"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="10">
            <el-form-item prop="title" :label="'문제 제목'" required>
              <el-input :placeholder="'문제 제목'" v-model="problem.title"></el-input>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="20">
          <el-col :span="24">
            <el-form-item :label="'평가 방식'">
              <el-select v-model="evalValue" value-key="value" placeholder="Select">
                <el-option v-for="item in evalList" :key="item.value" :label="item.label" :value="item">
                </el-option>
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="20">
          <el-col :span="24">
            <el-form-item prop="contest_description" :label="'개요'" required>
              <Simditor v-model="problem.contest_description"></Simditor>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="20">
          <!-- <el-col :span="24">
            <el-form-item prop="summary_description" :label="$t('Summary')" required>
              <Simditor v-model="problem.summary_description"></Simditor>
            </el-form-item>
          </el-col> -->
          <el-col :span="24">
            <el-form-item prop="rule_description" :label="'규칙'" required>
              <Simditor v-model="problem.rule_description"></Simditor>
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item prop="schedule_description" :label="'일정'" required>
              <Simditor v-model="problem.schedule_description"></Simditor>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item :label="'시작 날짜'" required>
              <el-date-picker
                v-model="problem.start_time"
                type="datetime"
                :placeholder="'시작 날짜'">
              </el-date-picker>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item :label="'마감 날짜'" required>
              <el-date-picker
                v-model="problem.end_time"
                type="datetime"
                :placeholder="'마감 날짜'">
              </el-date-picker>
            </el-form-item>
          </el-col>
          <!-- reward -->
          <el-col :span="24">
            <el-form-item prop="reward_description" :label="'상금'" required>
              <Simditor v-model="problem.reward_description"></Simditor>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="20">
          <!-- <el-col :span="5">
            <el-form-item :label="$t('m.TestCase')" :error="error.testcase">
              <el-upload
                action="/api/admin/test_case"
                name="file"
                :data="{spj: problem.spj}"
                :show-file-list="true"
                :on-success="uploadSucceeded"
                :on-error="uploadFailed">
                <el-button size="small" type="primary" icon="el-icon-fa-upload">Choose File</el-button>
              </el-upload>
            </el-form-item>
          </el-col> -->
          <el-col :span="5">
            <el-form-item :label="'정답 파일'">
              <el-upload
                action="/api/admin/upload_csv"
                name="file"
                :on-success="uploadFileSucceeded">
                <el-button size="small" type="primary" icon="el-icon-fa-upload">파일 선택</el-button>
              </el-upload>
            </el-form-item>
          </el-col>
          <el-col :span="5">
            <el-form-item :label="'데이터 파일'">
              <el-upload
                action="/api/admin/data_csv"
                name="file"
                :on-success="uploadDataSucceeded">
                <el-button size="small" type="primary" icon="el-icon-fa-upload">파일 선택</el-button>
              </el-upload>
            </el-form-item>
          </el-col>
          <el-col :span="5">
            <el-form-item :label="'태그'" :error="error.tags" required>
              <span class="tags">
                <el-tag
                  v-for="tag in problem.tags"
                  :closable="true"
                  :close-transition="false"
                  :key="tag"
                  type="success"
                  @close="closeTag(tag)"
                >{{tag}}</el-tag>
              </span>
              <el-autocomplete
                v-if="inputVisible"
                size="mini"
                class="input-new-tag"
                popper-class="problem-tag-poper"
                v-model="tagInput"
                :trigger-on-focus="false"
                @keyup.enter.native="addTag"
                @select="addTag"
                :fetch-suggestions="querySearch">
              </el-autocomplete>
              <el-button class="button-new-tag" v-else size="small" @click="inputVisible = true">+ {{$t('m.New_Tag')}}</el-button>
            </el-form-item>
          </el-col> 
        </el-row>        
        <!-- <div>
          <el-form-item v-for="(sample, index) in problem.samples" :key="'sample'+index">
            <Accordion :title="'Sample' + (index + 1)">
              <el-button type="warning" size="small" icon="el-icon-delete" slot="header" @click="deleteSample(index)">
                Delete
              </el-button>
              <el-row :gutter="20">
                <el-col :span="12">
                  <el-form-item :label="$t('m.Input_Samples')" required>
                    <el-input
                      :rows="5"
                      type="textarea"
                      :placeholder="$t('m.Input_Samples')"
                      v-model="sample.input">
                    </el-input>
                  </el-form-item>
                </el-col>
                <el-col :span="12">
                  <el-form-item :label="$t('m.Output_Samples')" required>
                    <el-input
                      :rows="5"
                      type="textarea"
                      :placeholder="$t('m.Output_Samples')"
                      v-model="sample.output">
                    </el-input>
                  </el-form-item>
                </el-col>
              </el-row>
            </Accordion>
          </el-form-item>
        </div> -->
        <!-- <div class="add-sample-btn">
          <button type="button" class="add-samples" @click="addSample()"><i class="el-icon-plus"></i>{{$t('m.Add_Sample')}}
          </button>
        </div> -->
        <el-form-item prop="data_description" :label="'데이터 설명'" required>
          <Simditor v-model="problem.data_description"></Simditor>
        </el-form-item>
        <!-- <el-form-item style="margin-top: 20px" :label="$t('Hint')">
          <Simditor v-model="problem.hint" placeholder=""></Simditor>
        </el-form-item> -->
        <!-- <el-row :gutter="20">
          <el-col :span="4">
            <el-form-item :label="$t('m.Type')">
              <el-radio-group v-model="problem.rule_type" :disabled="disableRuleType">
                <el-radio label="ACM">ACM</el-radio>
                <el-radio label="OI">OI</el-radio>
              </el-radio-group>
            </el-form-item>
          </el-col>
    

          <el-col :span="6">
            <el-form-item :label="$t('m.IOMode')">
              <el-radio-group v-model="problem.io_mode.io_mode">
                <el-radio label="Standard IO">Standard IO</el-radio>
                <el-radio label="File IO">File IO</el-radio>
              </el-radio-group>
            </el-form-item>
          </el-col>

          <el-col :span="4" v-if="problem.io_mode.io_mode == 'File IO'">
            <el-form-item :label="$t('m.InputFileName')" required>
              <el-input type="text" v-model="problem.io_mode.input"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="4" v-if="problem.io_mode.io_mode == 'File IO'">
            <el-form-item :label="$t('m.OutputFileName')" required>
              <el-input type="text" v-model="problem.io_mode.output"></el-input>
            </el-form-item>
          </el-col>

          <el-col :span="24">
            <el-table
              :data="problem.test_case_score"
              style="width: 100%">
              <el-table-column
                prop="input_name"
                :label="$t('m.Input')">
              </el-table-column>
              <el-table-column
                prop="output_name"
                :label="$t('m.Output')">
              </el-table-column>
              <el-table-column
                prop="score"
                :label="$t('m.Score')">
                <template slot-scope="scope">
                  <el-input
                    size="small"
                    :placeholder="$t('m.Score')"
                    v-model="scope.row.score"
                    :disabled="problem.rule_type !== 'OI'">
                  </el-input>
                </template>
              </el-table-column>
            </el-table>
          </el-col>
        </el-row>
         -->
        <!-- <el-form-item :label="$t('m.Source')">
          <el-input :placeholder="$t('m.Source')" v-model="problem.source"></el-input>
        </el-form-item> -->
        <save @click.native="submit()">Save</save>
      </el-form>
    </Panel>
  </div>
</template>

<script>
  import Simditor from '../../components/Simditor'
  import Accordion from '../../components/Accordion'
  import CodeMirror from '../../components/CodeMirror'
  import api from '../../api'
  export default {
    name: 'AIContest',
    components: {
      Simditor,
      Accordion,
      CodeMirror
    },
    data () {
      return {
        selected: 'Class',
        rules: {
          _id: {required: true, message: 'Display ID is required', trigger: 'blur'},
          title: {required: true, message: 'Title is required', trigger: 'blur'},
          // summary_description: {required: true, message: 'Input Description is required', trigger: 'blur'},
          contest_description: {required: true, message: 'Contest Description is required', trigger: 'blur'},
          rule_description: {required: true, message: 'Rule Description is required', trigger: 'blur'},
          schedule_description: {required: true, message: 'Schedule Description is required', trigger: 'blur'},
          start_time: {required: true, message: 'Start Time is required', trigger: 'blur'},
          end_time: {required: true, message: 'End Time is required', trigger: 'blur'},
          reward_description: {required: true, message: 'Reward Description is required', trigger: 'blur'},
          data_description: {required: true, message: 'Data Description is required', trigger: 'blur'}
          // rank: {required: false}
        },
        loadingCompile: false,
        mode: '',
        contest: {},
        problem: {
          languages: [],
          io_mode: {'io_mode': 'Standard IO', 'input': 'input.txt', 'output': 'output.txt'}
        },
        reProblem: {
          languages: [],
          io_mode: {'io_mode': 'Standard IO', 'input': 'input.txt', 'output': 'output.txt'}
        },
        testCaseUploaded: false,
        allLanguage: {},
        inputVisible: false,
        tagInput: '',
        template: {},
        title: '',
        spjMode: '',
        disableRuleType: false,
        routeName: '',
        error: {
          tags: '',
          spj: '',
          languages: '',
          testCase: ''
        },
        password: '',
        evalList: [
          {
            value: 'acc',
            label: 'Accuracy'
          },
          {
            value: 'mse',
            label: 'MSE'
          },
          {
            value: 'rmse',
            label: 'RMSE'
          },
          // {
          //   value: 'auc',
          //   label: 'AUC'
          // },
          {
            value: 'mean_f_score',
            label: 'MeanFScore'
          },
          {
            value: 'mae',
            label: 'MAE'
          },
          // {
          //   value: 'f_beta',
          //   label: 'F_{Beta}'
          // },
          {
            value: 'logloss',
            label: 'LogLoss'
          },
          {
            value: 'rmsle',
            label: 'RMSLE'
          }
          // {
          //   value: 'map@k',
          //   label: 'map@{K}'
          // }
        ],
        evalValue: null
      }
    },
    mounted () {
      this.routeName = this.$route.name
      if (this.routeName === 'edit-aiproblem' || this.routeName === 'edit-contest-problem') {
        this.mode = 'edit'
      } else {
        this.mode = 'add'
      }
      api.getLanguages().then(res => {
        this.problem = this.reProblem = {
          _id: '',
          title: '',
          contest_description: '',
          rule_description: '',
          start_time: '',
          end_time: '',
          reward_description: '',
          data_description: '',
          memory_limit: 256,
          difficulty: 'Low',
          visible: true,
          share_submission: false,
          tags: [],
          languages: [],
          template: {},
          samples: [{input: '', output: ''}],
          spj: false,
          spj_language: '',
          spj_code: '',
          spj_compile_ok: false,
          test_case_id: '',
          solution_id: '',
          data_id: '',
          test_case_score: [],
          rule_type: 'ACM',
          hint: '',
          source: '',
          io_mode: {'io_mode': 'Standard IO', 'input': 'input.txt', 'output': 'output.txt'},
          p_type: '',
          rank: [],
          password: '',
          join_contest: [],
          eval_type: ''
        }
        let contestID = this.$route.params.contestId
        if (contestID) {
          this.problem.contest_id = this.reProblem.contest_id = contestID
          this.disableRuleType = true
          api.getContest(contestID).then(res => {
            this.problem.rule_type = this.reProblem.rule_type = res.data.data.rule_type
            this.contest = res.data.data
          })
        }
        this.problem.spj_language = 'C'
        let allLanguage = res.data.data
        this.allLanguage = allLanguage
        // get problem after getting languages list to avoid find undefined value in `watch problem.languages`
        if (this.mode === 'edit') {
          this.title = '문제 수정'
          let funcName = {'edit-aiproblem': 'getAIProblem', 'edit-contest-problem': 'getContestProblem'}[this.routeName]
          console.log('mode', this.mode)
          api[funcName](this.$route.params.problemId).then(problemRes => {
            let data = problemRes.data.data
            console.log('data', data)
            // if (!data.spj_code) {
            //   data.spj_code = ''
            // }
            // data.spj_language = data.spj_language || 'C'
            this.problem = data
            // this.testCaseUploaded = true
          })
        } else {
          this.title = '문제 등록'
          for (let item of allLanguage.languages) {
            this.problem.languages.push(item.name)
          }
        }
      })
    },
    watch: {
      '$route' () {
        this.$refs.form.resetFields()
        this.problem = this.reProblem
      },
      'problem.languages' (newVal) {
        let data = {}
        // use deep copy to avoid infinite loop
        let languages = JSON.parse(JSON.stringify(newVal)).sort()
        for (let item of languages) {
          if (this.template[item] === undefined) {
            let langConfig = this.allLanguage.languages.find(lang => {
              return lang.name === item
            })
            if (this.problem.template[item] === undefined) {
              data[item] = {checked: false, code: langConfig.config.template, mode: langConfig.content_type}
            } else {
              data[item] = {checked: true, code: this.problem.template[item], mode: langConfig.content_type}
            }
          } else {
            data[item] = this.template[item]
          }
        }
        this.template = data
      },
      'problem.spj_language' (newVal) {
        this.spjMode = this.allLanguage.spj_languages.find(item => {
          return item.name === this.problem.spj_language
        }).content_type
      }
    },
    methods: {
      switchSpj () {
        if (this.testCaseUploaded) {
          this.$confirm('If you change problem judge method, you need to re-upload test cases', 'Warning', {
            confirmButtonText: 'Yes',
            cancelButtonText: 'Cancel',
            type: 'warning'
          }).then(() => {
            this.problem.spj = !this.problem.spj
            this.resetTestCase()
          }).catch(() => {
          })
        } else {
          this.problem.spj = !this.problem.spj
        }
      },
      querySearch (queryString, cb) {
        api.getProblemTagList({ keyword: queryString }).then(res => {
          let tagList = []
          for (let tag of res.data.data) {
            tagList.push({value: tag.name})
          }
          cb(tagList)
        }).catch(() => {
        })
      },
      resetTestCase () {
        this.testCaseUploaded = false
        this.problem.test_case_score = []
        this.problem.test_case_id = ''
      },
      addTag () {
        let inputValue = this.tagInput
        if (inputValue) {
          this.problem.tags.push(inputValue)
        }
        this.inputVisible = false
        this.tagInput = ''
      },
      closeTag (tag) {
        this.problem.tags.splice(this.problem.tags.indexOf(tag), 1)
      },
      addSample () {
        this.problem.samples.push({input: '', output: ''})
      },
      deleteSample (index) {
        this.problem.samples.splice(index, 1)
      },
      uploadSucceeded (response) {
        if (response.error) {
          this.$error(response.data)
          return
        }
        let fileList = response.data.info
        for (let file of fileList) {
          file.score = (100 / fileList.length).toFixed(0)
          if (!file.output_name && this.problem.spj) {
            file.output_name = '-'
          }
        }
        // console.log(response)
        this.problem.test_case_score = fileList
        this.testCaseUploaded = true
        this.problem.test_case_id = response.data.id
      },
      uploadFileSucceeded (response) {
        console.log(response)
        if (response.error) {
          this.$error(response.data)
          return
        }
        console.log(response)
        this.problem.solution_id = response.data.id
        // eval value 처리
        this.problem.eval_type = this.evalValue['value']
      },
      uploadDataSucceeded (response) {
        console.log(response)
        if (response.error) {
          this.$error(response.data)
          return
        }
        console.log(response)
        this.problem.data_id = response.data.id
        // console.log('evalValue', this.evalValue)
        // console.log('evalValue[label]', this.evalValue['label'])
        // console.log('evalValue[value]', this.evalValue['value'])
      },
      uploadFailed () {
        this.$error('Upload failed')
      },
      compileSPJ () {
        let data = {
          id: this.problem.id,
          spj_code: this.problem.spj_code,
          spj_language: this.problem.spj_language
        }
        this.loadingCompile = true
        api.compileSPJ(data).then(res => {
          this.loadingCompile = false
          this.problem.spj_compile_ok = true
          this.error.spj = ''
        }, err => {
          this.loadingCompile = false
          this.problem.spj_compile_ok = false
          const h = this.$createElement
          this.$msgbox({
            title: 'Compile Error',
            type: 'error',
            message: h('pre', err.data.data),
            showCancelButton: false,
            closeOnClickModal: false,
            customClass: 'dialog-compile-error'
          })
        })
      },
      submit () {
        // if (!this.problem.samples.length) {
        //   this.$error('Sample is required')
        //   return
        // }
        // for (let sample of this.problem.samples) {
        //   if (!sample.input || !sample.output) {
        //     this.$error('Sample input and output is required')
        //     return
        //   }
        // }
        if (!this.problem.tags.length) {
          this.error.tags = 'Please add at least one tag'
          this.$error(this.error.tags)
          return
        }
        // if (this.problem.spj) {
        //   if (!this.problem.spj_code) {
        //     this.error.spj = 'Spj code is required'
        //     this.$error(this.error.spj)
        //   } else if (!this.problem.spj_compile_ok) {
        //     this.error.spj = 'SPJ code has not been successfully compiled'
        //   }
        //   if (this.error.spj) {
        //     this.$error(this.error.spj)
        //     return
        //   }
        // }
        // if (!this.problem.languages.length) {
        //   this.error.languages = 'Please choose at least one language for problem'
        //   this.$error(this.error.languages)
        //   return
        // }
        // if (!this.testCaseUploaded) {
        //   this.error.testCase = 'Test case is not uploaded yet'
        //   this.$error(this.error.testCase)
        //   return
        // }
        // if (this.problem.rule_type === 'OI') {
        //   for (let item of this.problem.test_case_score) {
        //     try {
        //       if (parseInt(item.score) <= 0) {
        //         this.$error('Invalid test case score')
        //         return
        //       }
        //     } catch (e) {
        //       this.$error('Test case score must be an integer')
        //       return
        //     }
        //   }
        // }
        // this.problem.languages = this.problem.languages.sort()
        // this.problem.template = {}
        // for (let k in this.template) {
        //   if (this.template[k].checked) {
        //     this.problem.template[k] = this.template[k].code
        //   }
        // }
        let funcName = {
          'create-aiproblem': 'createAIProblem',
          'edit-aiproblem': 'editAIProblem',
          'create-contest-problem': 'createContestAIProblem',
          'edit-contest-problem': 'editContestAIProblem'
        }[this.routeName]
        // edit contest problem 时, contest_id会被后来的请求覆盖掉
        if (funcName === 'editContestAIProblem') {
          this.problem.contest_id = this.contest.id
        }
        api[funcName](this.problem).then(res => {
          if (this.routeName === 'create-contest-problem' || this.routeName === 'edit-contest-problem') {
            this.$router.push({name: 'contest-problem-list', params: {contestId: this.$route.params.contestId}})
          } else {
            this.$router.push({name: 'aiproblem-list'})
          }
        }).catch(() => {
        })
      }
    }
  }
</script>

<style lang="less" scoped>
  .problem {
    .difficulty-select {
      width: 120px;
    }
    .spj-radio {
      margin-left: 10px;
      &:last-child {
        margin-right: 20px;
      }
    }
    .input-new-tag {
      width: 78px;
    }
    .button-new-tag {
      height: 24px;
      line-height: 22px;
      padding-top: 0;
      padding-bottom: 0;
    }
    .tags {
      .el-tag {
        margin-right: 10px;
      }
    }
    .accordion {
      margin-bottom: 10px;
    }
    .add-samples {
      width: 100%;
      background-color: #fff;
      border: 1px dashed #aaa;
      outline: none;
      cursor: pointer;
      color: #666;
      height: 35px;
      font-size: 14px;
      &:hover {
        background-color: #f9fafc;
      }
      i {
        margin-right: 10px;
      }
    }
    .add-sample-btn {
      margin-bottom: 10px;
    }
  }
</style>

<style>
  .problem-tag-poper {
    width: 200px !important;
  }
  .dialog-compile-error {
    width: auto;
    max-width: 80%;
    overflow-x: scroll;
  }
</style>