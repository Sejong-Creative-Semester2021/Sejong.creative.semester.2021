<template>
  <Panel shadow :padding="10" class="size">
    <div slot="title">
      {{$t('m.FAQ')}}
    </div>
    <v-expansion-panels focusable>
      <v-expansion-panel v-for="faq in faqs" :key="faq.question">
        <v-expansion-panel-header>
          {{faq.question}}
          <template v-slot:actions>
            <v-icon right>
              {{mdiMenuDown}}
            </v-icon>
          </template>
        </v-expansion-panel-header>
        <v-expansion-panel-content v-html="faq.answer" key="answer" class="content-container">
          {{faq.answer}}
        </v-expansion-panel-content>
      </v-expansion-panel>
    </v-expansion-panels>
  </Panel>
</template>

<script src="./js/vue.js"></script>
<script src="./js/lodash.min.js"></script>

<script>
  import api from '@oj/api'
  import _ from 'lodash'
  // lodash를 이용해서 orderBy를 사용하는 것이기 때문에 위에서 script를 반드시 해줘야함
  // _(언더바)가 정의되지 않는다는 오류 발생-> lodash사용을 명시적으로 하지 않았기 때문에 생기는 에러. import를 통해서 에러 해결 가능
  import { mdiMenuDown } from '@mdi/js'

  export default {
    name: 'FAQ',
    data () {
      return {
        mdiMenuDown,
        faqs: [],
        faq: ''
      }
    },
    mounted () {
      this.init()
    },
    methods: {
      init () {
        this.getFAQList()
      },
      getFAQList () {
        api.getFAQList().then(res => {
          this.faqs = res.data.data.results
        })
      }
    },
    computed: {
      orderedFAQ: function () {
        // this.faqs.answer = this.faqs.answer.replace('\n', '<br />')
        // console.log(this.faqs)
        return _.orderBy(this.faqs, ['id'], ['asc'])
        // orderBy를 created_by를 통해서 정렬하고자 했는데 실패
        // -> 살펴보니 created_by가 단순히 숫자로만 이뤄진게 아니여서 그런듯.
        // 결국은 아이디로 정렬
      }
    }
  }
</script>

<style lang="less" scoped>
  .content-container {
    padding: 20px 20px 20px 20px;
  }
  .icon {
    order:1;
  }
  .header{
    order:0;
    text-align: left;
  }
  .size{
    margin-right: 15%;
    margin-left: 15%;
  }
</style>