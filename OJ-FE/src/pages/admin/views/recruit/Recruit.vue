<template>
  <div class="recruit">

    <Panel :title="title">
      <el-form ref="form" :model="recruit" :rules="rules" label-position="top" label-width="70px">
        <el-row :gutter="20">
          <el-col :span="6">
            <el-form-item prop="C_name" :label="$t('m.Company_Name')">
              <el-input :placeholder="$t('m.Company_Name')" v-model="recruit.C_name"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="18">
            <el-form-item prop="title" :label="$t('m.Recruit_Title')" required>
              <el-input :placeholder="$t('m.Recruit_Title')" v-model="recruit.title"></el-input>
            </el-form-item>
          </el-col>
        </el-row>

        <el-row :gutter="20">
          
          <el-col :span="5">
            <el-form-item :label="$t('m.job')" required>
              <el-checkbox-group v-model="recruit.job" v-for="job in jobList" :key="job">
                  <el-checkbox :label="job"></el-checkbox>
              </el-checkbox-group>
            </el-form-item>
          </el-col>

          <el-col :span="5">
            <el-form-item :label="$t('m.location')" required>
              <el-checkbox-group v-model="recruit.location" v-for="location in locationList" :key="location">
                  <el-checkbox :label="location"></el-checkbox>
              </el-checkbox-group>
            </el-form-item>
          </el-col>

          <el-col :span="5">
            <el-form-item :label="$t('m.career')" required>
              <el-checkbox-group v-model="recruit.career" v-for="career in careerList" :key="career">
                  <el-checkbox :label="career"></el-checkbox>
              </el-checkbox-group>
            </el-form-item>
          </el-col>

          <el-col :span="5">
            <el-form-item :label="$t('m.work')" required>
              <el-checkbox-group v-model="recruit.work" v-for="work in workList" :key="work">
                  <el-checkbox :label="work"></el-checkbox>
              </el-checkbox-group>
            </el-form-item>
          </el-col>
        </el-row>
        
      
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
    name: 'Recruit',
    components: {
      Simditor,
      Accordion,
      CodeMirror
    },
    data () {
      return {
        jobList: ['서버/백엔드', '프론트엔드', '웹 풀스택', '안드로이드', 'ios', '머신러닝', '인공지능(AI)', '시트템/네트워크', '사물인터넷(IoT)', '블록체인', '인터넷 보안', '게임 서버', '게임 클라이언트', '모바일 게임', '데이터 엔지니어'],
        locationList: ['서울', '인천', '대전', '광주', '울산', '부산', '대구', '경기도', '충청북도', '충청남도', '경상남도', '경상북도', '전라남도', '전라북도', '강원도', '제주'],
        careerList: ['신입', '경력'],
        workList: ['정규직', '인턴', '전환형 인턴', '계약직'],
        rules: {
          C_name: {required: true, message: 'Company Name is required', trigger: 'blur'},
          title: {required: true, message: 'Title is required', trigger: 'blur'}
        },
        recruit: {
          job: [],
          location: [],
          career: [],
          work: []
        },
        title: ''
      }
    },
    mounted () {
      api.getLanguages().then(res => {
        this.problem = this.reProblem = {
          _id: '',
          title: '',
          description: '',
          input_description: '',
          output_description: '',
          time_limit: 1000,
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
          test_case_score: [],
          rule_type: 'ACM',
          hint: '',
          source: '',
          io_mode: {'io_mode': 'Standard IO', 'input': 'input.txt', 'output': 'output.txt'}
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
          this.title = this.$i18n.t('m.Edit_Problem')
          let funcName = {'edit-problem': 'getProblem', 'edit-contest-problem': 'getContestProblem'}[this.routeName]
          api[funcName](this.$route.params.problemId).then(problemRes => {
            let data = problemRes.data.data
            if (!data.spj_code) {
              data.spj_code = ''
            }
            data.spj_language = data.spj_language || 'C'
            this.problem = data
            this.testCaseUploaded = true
          })
        } else {
          this.title = 'Recruit'
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

