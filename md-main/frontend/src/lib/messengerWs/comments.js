const _commentsListSubscribers = {};
const _commentsCommentSubscribers = {};

function getKey({ resourceId, resourceType }) {
  //FIXME: Don't hard code resourceType, use Constantize like in Rails
  return `Post_${resourceId}`;
}

function createHandler(map) {
  return (data) => {
    const key = getKey({ resourceId: data.payload.resource_id, resourceType: data.payload.resource_type });
    if (map[key]) {
      const handler = map[key];
      handler(data.payload, key);
    }
  };
}

export default {
  'comments.list': [createHandler(_commentsListSubscribers)],
  'comments.comment': [createHandler(_commentsCommentSubscribers)],

  sendRequestComments({ resourceId, resourceType }, sinceId = 0, count = 10) {
    this.send({
      type: 'comments',
      command: 'list',
      resource_id: resourceId,
      resource_type: resourceType,
      since_id: sinceId,
      count
    });
  },

  sendCommentsSubscribe({ resourceId, resourceType }) {
    this.send({
      type: 'comments',
      command: 'subscribe',
      resource_id: resourceId,
      resource_type: resourceType,
    });
  },

  sendCommentsUnsubscribe({ resourceId, resourceType }) {
    this.send({
      type: 'comments',
      command: 'unsubscribe',
      resource_id: resourceId,
      resource_type: resourceType,
    });
  },

  sendCreateComment({ resourceId, resourceType }, body) {
    this.send({
      type: 'comments',
      command: 'post',
      resource_id: resourceId,
      resource_type: resourceType,
      body
    });
  },

  onCommentsList(key, handler) {
    _commentsListSubscribers[getKey(key)] = handler;
  },

  onNewComment(key, handler) {
    _commentsCommentSubscribers[getKey(key)] = handler;
  },

  offComments(key) {
    delete _commentsListSubscribers[getKey(key)];
    delete _commentsCommentSubscribers[getKey(key)];
  }
}
