import Immutable from "immutable";
import moment from "moment";

export class ConversationState extends Immutable.Record({
  id: -1,
  messages: Immutable.List(),
  dreamers: Immutable.List(),
  scrollBottom: true,
  isLoadingPrevious: false
}) {
  getDreamer() {
    return this.dreamers.get(0);
  }

  getFirstMessageId() {
    const msg = this.messages.first();
    return msg ? msg.get('id'): -1;
  }
}

export class State extends Immutable.Record({
  isVisible: false,
  conversationIdForOpen: -1,
  isConversationsListLoadStarted: false,
  conversationsList: Immutable.List(),
  currentConversationPage: 1,
  totalConversationsCount: 0,

  currentConversationId: -1,
  conversations: Immutable.Map()
}) {
  isConversationOpened(id) {
    return this.isVisible && this.currentConversationId == id;
  }

  getConversationsList() {
    return this.conversationsList;
  }
  getCurrentConversation() {
    return this.conversations.get(this.currentConversationId);
  }

  getCurrentMessages() {
    return this.conversations.get(this.currentConversationId);
  }

  getUnreadedMessagesCountFor(conversationId) {
    return this.getIn(['conversations', conversationId, 'messages'])
                .filter((m) => !m.get('read'))
                .count();
  }

  updateLastMessageFor(conversationId, message) {
    const idx = this.conversationsList.findIndex((c) => c.get('id') == conversationId);
    return this.updateIn(['conversationsList', idx, 'last_message'], (m) => {
      if (m == null) {
        m = Immutable.Map();
      }
      return m.set("id", message.id)
              .set("body", message.message)
              .set("created_at", message.created_at)
              .setIn(["sender", "id"], message.dreamer_id)
              .setIn(["sender", "full_name"], message.first_name + " " + message.last_name)
              .setIn(["sender", "online"], true)
              .setIn(["sender", "avatar", "small"], message.dreamer_avatar);
    }).setIn(['conversationsList', idx, 'updated_at'], moment().format());
  }

  sortConversationsList() {
    return this.update('conversationsList', (list) => {
      return list.sortBy((c) => c.get('updated_at'),
                         (a, b) => moment(b).diff(a));
    });
  }

  incrementUnreadedMessagesCountFor(conversationId, count = 1) {
    const idx = this.conversationsList.findIndex((c) => c.get('id') == conversationId);
    return this.updateIn(['conversationsList', idx, 'unreaded_messages_count'], (v) => v + count);
  }
  decrementUnreadedMessagesCountFor(conversationId, count = 1) {
    const idx = this.conversationsList.findIndex((c) => c.get('id') == conversationId);
    return this.updateIn(['conversationsList', idx, 'unreaded_messages_count'], (v) => v < count ? 0 : v - count);
  }

  resetUnreadedMessagesCountFor(conversationId) {
    const idx = this.conversationsList.findIndex((c) => c.get('id') == conversationId);
    return this.setIn(['conversationsList', idx, 'unreaded_messages_count'], 0);
  }

  addMessageInConversation(conversationId, message) {
    return this.updateIn(['conversations', conversationId], (c) => {
      const c1 = c.update('messages', (m) => m.push(Immutable.fromJS(message)));
      const c2 = c1.set('scrollBottom', true);
      return c2;
    });
  }

  openConversation(id) {
    const conversation = this.conversationsList.find((c) => c.get("id") == id);
    const dreamers = conversation.get("dreamers");

    return this.set('currentConversationId', id)
                .setIn(['conversations', id], new ConversationState({ dreamers, id }))
                .set('conversationIdForOpen', -1);
  }
}

