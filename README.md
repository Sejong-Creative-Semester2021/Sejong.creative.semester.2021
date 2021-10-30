# 세종대 창의학기제 Repository
- 멤버 : 김주연, 노주현, 신민경, 조동현
- 이슈를 통해서 일정 공유 및 문제 상황 공유

Notion
------------------------------------------
- 구체적인 내용 공유
- https://sejong-creative-semester-2021-2.notion.site/OnlineJudge-4c7f3d6808324136919d1b5b75a9a081


실행방법
```
git clone https://github.com/Sejong-Creative-Semester2021/Sejong.creative.semester.2021.git
cd Sejong-Creative-Semester2021
cd JudgeServer
docker build -t judgeserver1:1.0 .
cd ..
cd OJ-BE
docker build -t onlinejudge1:1.0 .
cd ..
docker-compose up -d
```
onlinejudge_default의 gateway 값 가져오기
```
docker network list
docker network inspect ~~~~~~~~
```
```
cd OJ-FE
npm install
export NODE_ENV=development
npm run build:dll
export TARGET=위에 가져온 gateway 값 (ex: http://172.21.0.1)
npm run dev
```
