export default {
  User: [
    {
      user_id: 1,
      name: 'user1',
      created_at: '2018-09-11 11:42:11'
    },
    {
      user_id: 2,
      name: 'user2',
      created_at: '2018-09-11 11:42:11'
    },
    {
      user_id: 3,
      name: 'user3',
      created_at: '2018-09-11 11:42:11'
    }
  ],
  Content: [
    {
      content_id: 1,
      user_id: 1,
      title: 'title1',
      context: 'content1',
      created_at: '2019-01-01 13:11:42',
      updated_at: null
    },
    {
      content_id: 2,
      user_id: 3,
      title: 'title2',
      context: 'content2',
      created_at: '2019-01-02 13:11:42',
      updated_at: null
    },
    {
      content_id: 3,
      user_id: 2,
      title: 'title3',
      context: 'content3',
      created_at: '2019-03-29 13:11:42',
      updated_at: null
    }
  ],
  Comment: [
    {
      comment_id: 1,
      user_id: 1,
      content_id: 3,
      context: 'comment 1',
      created_at: '2019-03-29 14:11:11',
      updated_at: null
    },
    {
      comment_id: 2,
      user_id: 3,
      content_id: 3,
      context: 'comment 2',
      created_at: '2019-03-29 16:11:11',
      updated_at: null
    },
    {
      comment_id: 3,
      user_id: 2,
      content_id: 1,
      context: 'comment 3',
      created_at: '2019-03-29 14:11:11',
      updated_at: null
    }
  ],
  SubComment: [
    {
      subcomment_id: 1,
      comment_id: 3,
      user_id: 1,
      context: 'subcomment 1',
      created_at: '2019-03-29 16:22:11',
      updated_at: null
    }
  ]
}
