webpackJsonp([5],{"1Jov":function(t,e){},WQH6:function(t,e,s){"use strict";Object.defineProperty(e,"__esModule",{value:!0});var i=s("fZjL"),a=s.n(i),o=s("mvHQ"),n=s.n(o),r=s("Dd8w"),l=s.n(r),c=s("NYxO"),m=s("IcnI"),u=s("jj1A"),p=s("VKKs"),_=s("y2MC"),d=s("FN8c"),h=s("8Q2T"),v={AC:{color:"#19be6b"},WA:{color:"#ed3f14"},TLE:{color:"#ff9300"},MLE:{color:"#f7de00"},RE:{color:"#ff6104"},CE:{color:"#80848f"},PAC:{color:"#2d8cf0"}};function b(t){return v[t.name].color}var g={legend:{left:"center",top:"10",orient:"horizontal",data:["AC","WA"]},series:[{name:"Summary",type:"pie",radius:"80%",center:["50%","55%"],itemStyle:{normal:{color:b}},data:[{value:0,name:"WA"},{value:0,name:"AC"}],label:{normal:{position:"inner",show:!0,formatter:"{b}: {c}\n {d}%",textStyle:{fontWeight:"bold"}}}}]},f={legend:{left:"center",top:"10",orient:"horizontal",itemGap:20,data:["AC","RE","WA","TLE","PAC","MLE"]},series:[{name:"Detail",type:"pie",radius:["45%","70%"],center:["50%","55%"],itemStyle:{normal:{color:b}},data:[{value:0,name:"RE"},{value:0,name:"WA"},{value:0,name:"TLE"},{value:0,name:"AC"},{value:0,name:"MLE"},{value:0,name:"PAC"}],label:{normal:{formatter:"{b}: {c}\n {d}%"}},labelLine:{normal:{}}},{name:"Summary",type:"pie",radius:"30%",center:["50%","55%"],itemStyle:{normal:{color:b}},data:[{value:"0",name:"WA"},{value:0,name:"AC",selected:!0}],label:{normal:{position:"inner",formatter:"{b}: {c}\n {d}%"}}}]},C=["-1","-2","0","1","2","3","4","8"],I={name:"Problem",components:{CodeMirror:u.a},mixins:[_.a],data:function(){return{statusVisible:!1,captchaRequired:!1,graphVisible:!1,submissionExists:!1,captchaCode:"",captchaSrc:"",contestID:"",problemID:"",submitting:!1,code:"",language:"C++",theme:"solarized",submissionId:"",submitted:!1,result:{result:9},problem:{title:"",description:"",testhint:"",my_status:"",template:{},languages:[],created_by:{username:""},tags:[],io_mode:{io_mode:"Standard IO"}},pie:g,largePie:f,largePieInitOpts:{width:"500",height:"480"}}},beforeRouteEnter:function(t,e,s){var i=p.a.get(Object(d.j)(t.params.problemID,t.params.contestID));i?s(function(t){t.language=i.language,t.code=i.code,t.theme=i.theme}):s()},mounted:function(){this.$store.commit(m.b.CHANGE_CONTEST_ITEM_VISIBLE,{menu:!1}),this.init()},methods:l()({},Object(c.mapActions)(["changeDomTitle"]),{init:function(){var t=this;this.$Loading.start(),this.contestID=this.$route.params.contestID,this.problemID=this.$route.params.problemID;var e="problem-details"===this.$route.name?"getProblem":"getContestProblem";h.a[e](this.problemID,this.contestID).then(function(e){t.$Loading.finish();var s=e.data.data;if(t.changeDomTitle({title:s.title}),h.a.submissionExists(s.id).then(function(e){t.submissionExists=e.data.data}),s.languages=s.languages.sort(),t.problem=s,t.changePie(s),""===t.code){t.language=t.problem.languages[0];var i=t.problem.template;i&&i[t.language]&&(t.code=i[t.language])}},function(){t.$Loading.error()})},changePie:function(t){for(var e in t.statistic_info)-1===C.indexOf(e)&&delete t.statistic_info[e];var s=t.accepted_number,i=[{name:"WA",value:t.submission_number-s},{name:"AC",value:s}];this.pie.series[0].data=i;var o=JSON.parse(n()(i));o[1].selected=!0,this.largePie.series[1].data=o;var r=a()(t.statistic_info).map(function(t){return d.e[t].short});0===r.length&&r.push("AC","WA"),this.largePie.legend.data=r;var l=t.statistic_info[0];delete t.statistic_info[0];var c=[];a()(t.statistic_info).forEach(function(e){c.push({name:d.e[e].short,value:t.statistic_info[e]})}),c.push({name:"AC",value:l}),this.largePie.series[0].data=c},handleRoute:function(t){this.$router.push(t)},onChangeLang:function(t){this.problem.template[t]&&""===this.code.trim()&&(this.code=this.problem.template[t]),this.language=t},onChangeTheme:function(t){this.theme=t},onResetToTemplate:function(){var t=this;this.$Modal.confirm({content:this.$i18n.t("m.Are_you_sure_you_want_to_reset_your_code"),onOk:function(){var e=t.problem.template;e&&e[t.language]?t.code=e[t.language]:t.code=""}})},checkSubmissionStatus:function(){var t=this;this.refreshStatus&&clearTimeout(this.refreshStatus);this.refreshStatus=setTimeout(function e(){var s=t.submissionId;h.a.getSubmission(s).then(function(s){t.result=s.data.data,0!==a()(s.data.data.statistic_info).length?(t.submitting=!1,t.submitted=!1,clearTimeout(t.refreshStatus),t.init()):t.refreshStatus=setTimeout(e,2e3)},function(e){t.submitting=!1,clearTimeout(t.refreshStatus)})},2e3)},submitCode:function(){var t=this;if(""!==this.code.trim()){this.submissionId="",this.result={result:9},this.submitting=!0;var e={problem_id:this.problem.id,language:this.language,code:this.code,contest_id:this.contestID};this.captchaRequired&&(e.captcha=this.captchaCode);var s=function(e,s){t.statusVisible=!0,h.a.submitCode(e).then(function(e){t.submissionId=e.data.data&&e.data.data.submission_id,t.submitting=!1,t.submissionExists=!0,s?(t.submitted=!0,t.checkSubmissionStatus()):t.$Modal.success({title:t.$i18n.t("m.Success"),content:t.$i18n.t("m.Submit_code_successfully")})},function(e){t.getCaptchaSrc(),e.data.data.startsWith("Captcha is required")&&(t.captchaRequired=!0),t.submitting=!1,t.statusVisible=!1})};"OI"!==this.contestRuleType||this.OIContestRealTimePermission?s(e,!0):this.submissionExists?this.$Modal.confirm({title:"",content:"<h3>"+this.$i18n.t("m.You_have_submission_in_this_problem_sure_to_cover_it")+"<h3>",onOk:function(){setTimeout(function(){s(e,!1)},1e3)},onCancel:function(){t.submitting=!1}}):s(e,!1)}else this.$error(this.$i18n.t("m.Code_can_not_be_empty"))},onCopy:function(t){this.$success("Code copied")},onCopyError:function(t){this.$error("Failed to copy code")}}),computed:l()({},Object(c.mapGetters)(["problemSubmitDisabled","contestRuleType","OIContestRealTimePermission","contestStatus"]),{contest:function(){return this.$store.state.contest.contest},contestEnded:function(){return this.contestStatus===d.a.ENDED},submissionStatus:function(){return{text:d.e[this.result.result].name,color:d.e[this.result.result].color}},submissionRoute:function(){return this.contestID?{name:"contest-submission-list",query:{problemID:this.problemID}}:{name:"submission-list",query:{problemID:this.problemID}}}}),beforeRouteLeave:function(t,e,s){clearInterval(this.refreshStatus),this.$store.commit(m.b.CHANGE_CONTEST_ITEM_VISIBLE,{menu:!0}),p.a.set(Object(d.j)(this.problem._id,e.params.contestID),{code:this.code,language:this.language,theme:this.theme}),s()},watch:{$route:function(){this.init()}}},y={render:function(){var t=this,e=t.$createElement,s=t._self._c||e;return s("div",{staticClass:"flex-container"},[s("div",{attrs:{id:"problem-main"}},[s("Panel",{attrs:{padding:40,shadow:""}},[s("div",{attrs:{slot:"title"},slot:"title"},[t._v(t._s(t.problem.title))]),t._v(" "),s("div",{directives:[{name:"katex",rawName:"v-katex"}],staticClass:"markdown-body",attrs:{id:"problem-content"}},[s("p",{staticClass:"title"},[t._v(t._s(t.$t("m.Description")))]),t._v(" "),s("p",{staticClass:"content",domProps:{innerHTML:t._s(t.problem.description)}}),t._v(" "),s("p",{staticClass:"title"},[t._v(t._s(t.$t("m.Input"))+" "),"File IO"==t.problem.io_mode.io_mode?s("span",[t._v("("+t._s(t.$t("m.FromFile"))+": "+t._s(t.problem.io_mode.input)+")")]):t._e()]),t._v(" "),s("p",{staticClass:"content",domProps:{innerHTML:t._s(t.problem.input_description)}}),t._v(" "),s("p",{staticClass:"title"},[t._v(t._s(t.$t("m.Output"))+" "),"File IO"==t.problem.io_mode.io_mode?s("span",[t._v("("+t._s(t.$t("m.ToFile"))+": "+t._s(t.problem.io_mode.output)+")")]):t._e()]),t._v(" "),s("p",{staticClass:"content",domProps:{innerHTML:t._s(t.problem.output_description)}}),t._v(" "),t._l(t.problem.samples,function(e,i){return s("div",{key:i},[s("div",{staticClass:"flex-container sample"},[s("div",{staticClass:"sample-input"},[s("p",{staticClass:"title"},[t._v(t._s(t.$t("m.Sample_Input"))+" "+t._s(i+1)+"\n                "),s("a",{directives:[{name:"clipboard",rawName:"v-clipboard:copy",value:e.input,expression:"sample.input",arg:"copy"},{name:"clipboard",rawName:"v-clipboard:success",value:t.onCopy,expression:"onCopy",arg:"success"},{name:"clipboard",rawName:"v-clipboard:error",value:t.onCopyError,expression:"onCopyError",arg:"error"}],staticClass:"copy"},[s("Icon",{attrs:{type:"clipboard"}})],1)]),t._v(" "),s("pre",[t._v(t._s(e.input))])]),t._v(" "),s("div",{staticClass:"sample-output"},[s("p",{staticClass:"title"},[t._v(t._s(t.$t("m.Sample_Output"))+" "+t._s(i+1))]),t._v(" "),s("pre",[t._v(t._s(e.output))])])])])}),t._v(" "),t.problem.testhint?s("div",[s("p",{staticClass:"title"},[t._v(t._s(t.$t("testhint")))]),t._v(" "),s("Card",{attrs:{"dis-hover":""}},[s("div",{staticClass:"content",domProps:{innerHTML:t._s(t.problem.testhint)}})])],1):t._e(),t._v(" "),t.problem.source?s("div",[s("p",{staticClass:"title"},[t._v(t._s(t.$t("m.Source")))]),t._v(" "),s("p",{staticClass:"content"},[t._v(t._s(t.problem.source))])]):t._e()],2)]),t._v(" "),s("Card",{attrs:{padding:20,id:"submit-code","dis-hover":""}},[s("CodeMirror",{attrs:{value:t.code,languages:t.problem.languages,language:t.language,theme:t.theme},on:{"update:value":function(e){t.code=e},resetCode:t.onResetToTemplate,changeTheme:t.onChangeTheme,changeLang:t.onChangeLang}}),t._v(" "),s("Row",{attrs:{type:"flex",justify:"space-between"}},[s("Col",{attrs:{span:10}},[t.statusVisible?s("div",{staticClass:"status"},[!this.contestID||this.contestID&&t.OIContestRealTimePermission?[s("span",[t._v(t._s(t.$t("m.Status")))]),t._v(" "),s("Tag",{attrs:{type:"dot",color:t.submissionStatus.color},nativeOn:{click:function(e){return t.handleRoute("/status/"+t.submissionId)}}},[t._v("\n                "+t._s(t.$t("m."+t.submissionStatus.text.replace(/ /g,"_")))+"\n              ")])]:this.contestID&&!t.OIContestRealTimePermission?[s("Alert",{attrs:{type:"success","show-icon":""}},[t._v(t._s(t.$t("m.Submitted_successfully")))])]:t._e()],2):0===t.problem.my_status?s("div",[s("Alert",{attrs:{type:"success","show-icon":""}},[t._v(t._s(t.$t("m.You_have_solved_the_problem")))])],1):this.contestID&&!t.OIContestRealTimePermission&&t.submissionExists?s("div",[s("Alert",{attrs:{type:"success","show-icon":""}},[t._v(t._s(t.$t("m.You_have_submitted_a_solution")))])],1):t._e(),t._v(" "),t.contestEnded?s("div",[s("Alert",{attrs:{type:"warning","show-icon":""}},[t._v(t._s(t.$t("m.Contest_has_ended")))])],1):t._e()]),t._v(" "),s("Col",{attrs:{span:12}},[t.captchaRequired?[s("div",{staticClass:"captcha-container"},[t.captchaRequired?s("Tooltip",{attrs:{content:"Click to refresh",placement:"top"}},[s("img",{attrs:{src:t.captchaSrc},on:{click:t.getCaptchaSrc}})]):t._e(),t._v(" "),s("Input",{staticClass:"captcha-code",model:{value:t.captchaCode,callback:function(e){t.captchaCode=e},expression:"captchaCode"}})],1)]:t._e(),t._v(" "),s("Button",{staticClass:"fl-right",attrs:{type:"warning",icon:"edit",loading:t.submitting,disabled:t.problemSubmitDisabled||t.submitted},on:{click:t.submitCode}},[t.submitting?s("span",[t._v(t._s(t.$t("m.Submitting")))]):s("span",[t._v(t._s(t.$t("m.Submit")))])])],2)],1)],1)],1),t._v(" "),s("div",{attrs:{id:"right-column"}},[s("VerticalMenu",{on:{"on-click":t.handleRoute}},[this.contestID?[s("VerticalMenu-item",{attrs:{route:{name:"contest-problem-list",params:{contestID:t.contestID}}}},[s("Icon",{attrs:{type:"ios-photos"}}),t._v("\n          "+t._s(t.$t("m.Problems"))+"\n        ")],1),t._v(" "),s("VerticalMenu-item",{attrs:{route:{name:"contest-announcement-list",params:{contestID:t.contestID}}}},[s("Icon",{attrs:{type:"chatbubble-working"}}),t._v("\n          "+t._s(t.$t("m.Announcements"))+"\n        ")],1)]:t._e(),t._v(" "),!this.contestID||t.OIContestRealTimePermission?s("VerticalMenu-item",{attrs:{route:t.submissionRoute}},[s("Icon",{attrs:{type:"navicon-round"}}),t._v("\n         "+t._s(t.$t("m.Submissions"))+"\n      ")],1):t._e(),t._v(" "),this.contestID?[!this.contestID||t.OIContestRealTimePermission?s("VerticalMenu-item",{attrs:{route:{name:"contest-rank",params:{contestID:t.contestID}}}},[s("Icon",{attrs:{type:"stats-bars"}}),t._v("\n          "+t._s(t.$t("m.Rankings"))+"\n        ")],1):t._e(),t._v(" "),s("VerticalMenu-item",{attrs:{route:{name:"contest-details",params:{contestID:t.contestID}}}},[s("Icon",{attrs:{type:"home"}}),t._v("\n          "+t._s(t.$t("m.View_Contest"))+"\n        ")],1)]:t._e()],2),t._v(" "),s("Card",{attrs:{id:"info"}},[s("div",{staticClass:"header",attrs:{slot:"title"},slot:"title"},[s("Icon",{attrs:{type:"information-circled"}}),t._v(" "),s("span",{staticClass:"card-title"},[t._v(t._s(t.$t("m.Information")))])],1),t._v(" "),s("ul",[s("li",[s("p",[t._v("ID")]),t._v(" "),s("p",[t._v(t._s(t.problem._id))])]),t._v(" "),s("li",[s("p",[t._v(t._s(t.$t("m.Time_Limit")))]),t._v(" "),s("p",[t._v(t._s(t.problem.time_limit)+"MS")])]),t._v(" "),s("li",[s("p",[t._v(t._s(t.$t("m.Memory_Limit")))]),t._v(" "),s("p",[t._v(t._s(t.problem.memory_limit)+"MB")])]),t._v(" "),s("li"),s("li",[s("p",[t._v(t._s(t.$t("m.IOMode")))]),t._v(" "),s("p",[t._v(t._s(t.problem.io_mode.io_mode))])]),t._v(" "),s("li",[s("p",[t._v(t._s(t.$t("m.Created")))]),t._v(" "),s("p",[t._v(t._s(t.problem.created_by.username))])]),t._v(" "),t.problem.difficulty?s("li",[s("p",[t._v(t._s(t.$t("m.Level")))]),t._v(" "),s("p",[t._v(t._s(t.$t("m."+t.problem.difficulty)))])]):t._e(),t._v(" "),t.problem.total_score?s("li",[s("p",[t._v(t._s(t.$t("m.Score")))]),t._v(" "),s("p",[t._v(t._s(t.problem.total_score))])]):t._e(),t._v(" "),s("li",[s("p",[t._v(t._s(t.$t("m.Tags")))]),t._v(" "),s("p",[s("Poptip",{attrs:{trigger:"hover",placement:"left-end"}},[s("a",[t._v(t._s(t.$t("m.Show")))]),t._v(" "),s("div",{attrs:{slot:"content"},slot:"content"},t._l(t.problem.tags,function(e){return s("Tag",{key:e},[t._v(t._s(e))])}),1)])],1)])])]),t._v(" "),!this.contestID||t.OIContestRealTimePermission?s("Card",{attrs:{id:"pieChart",padding:0}},[s("div",{attrs:{slot:"title"},slot:"title"},[s("Icon",{attrs:{type:"ios-analytics"}}),t._v(" "),s("span",{staticClass:"card-title"},[t._v(t._s(t.$t("m.Statistic")))]),t._v(" "),s("Button",{attrs:{type:"ghost",size:"small",id:"detail"},on:{click:function(e){t.graphVisible=!t.graphVisible}}},[t._v("Details")])],1),t._v(" "),s("div",{staticClass:"echarts"},[s("ECharts",{attrs:{options:t.pie}})],1)]):t._e()],1),t._v(" "),s("Modal",{model:{value:t.graphVisible,callback:function(e){t.graphVisible=e},expression:"graphVisible"}},[s("div",{attrs:{id:"pieChart-detail"}},[s("ECharts",{attrs:{options:t.largePie,initOptions:t.largePieInitOpts}})],1),t._v(" "),s("div",{attrs:{slot:"footer"},slot:"footer"},[s("Button",{attrs:{type:"ghost"},on:{click:function(e){t.graphVisible=!1}}},[t._v(t._s(t.$t("m.Close")))])],1)])],1)},staticRenderFns:[]};var $=s("VU/8")(I,y,!1,function(t){s("1Jov")},"data-v-4ee7c728",null);e.default=$.exports}});