export default {
  'im.list': [],
  'im.message': [],

  list(conversationId, sinceId = 0, params = { count: 20 }) {
    this.send({
      type: "im",
      command: "list",
      conversation_id: conversationId,
      since_id: sinceId,
      count: params.count
    });
  },

  markRead(conversationId, messageId) {
    this.send({
      type: "im",
      command: "mark_read",
      conversation_id: conversationId,
      message_id: messageId
    });
  },

  sendTextMessage(conversationId, text) {
    this.send({
      type: "im",
      command: "send",
      conversation_id: conversationId,
      message: text
    });
  }
}
