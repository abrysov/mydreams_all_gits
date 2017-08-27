import Immutable from "immutable";
import { handleActions } from "redux-actions";
import Constants from "Constants";
import moment from "moment";

import {
  ConversationState,
  State
} from "./State";

export default handleActions({
  [Constants.USER.MESSAGES_CLICK]: (state, action) => state.set('isVisible', true),

  [Constants.NOTIFICATIONS_LIST.NEW_MESSAGE_CLICK]: (state, action) => {
    return state.set('isVisible', true)
                .set('conversationIdForOpen', action.payload.conversation_id);
  },
  [Constants.DREAMERS_LIST.SEND_MESSAGE_CLICK]: (state, action) => {
    return state.set('isVisible', true)
    .set('conversationIdForOpen', action.payload.id);
  },
  [Constants.DREAMER_INFO.SEND_MESSAGE_CLICK]: (state, action) => {
    return state.set('isVisible', true)
    .set('conversationIdForOpen', action.payload.id);
  },

  //NOTE: reset messenger state
  [Constants.MESSENGER.CLOSE_CLICK]: (state, action) => new State(),

  [Constants.MESSENGER.LOAD_CONVERSATIONS_START]: (state, action) => state.set('isConversationsListLoadStarted', true),
  [Constants.MESSENGER.LOAD_CONVERSATIONS_FAILED]: (state, action) => state.set('isConversationsListLoadStarted', false),

  [Constants.MESSENGER.LOAD_CONVERSATIONS_SUCCESS]: (state, action) => {
    var adds = Immutable.fromJS(action.payload.conversations);

    return state.set('conversationsList', adds)
                .set('currentConversationPage', action.payload.meta.page)
                .set('isConversationsListLoadStarted', false)
                .set('totalConversationsCount', action.payload.meta.total_count);
  },

  [Constants.MESSENGER.LOAD_NEXT_CONVERSATIONS_SUCCESS]: (state, action) => {
    if (action.payload.conversations.length > 0) {
      const currentIds = state.conversationsList.map((d) => d.get('id'));

      const adds = Immutable.fromJS(action.payload.conversations)
                        .filter((d) => !currentIds.contains(d.get('id')));

      const newConversations = state.conversationsList.concat(adds);

      return state.set("conversationsList", newConversations)
                  .set('currentConversationPage', action.payload.meta.page)
                  .set("totalConversationsCount", action.payload.meta.total_count)
                  .set("isConversationsListLoadStarted", false);
    }

    return state.set('isConversationsListLoadStarted', false);
  },



  [Constants.MESSENGER.OPEN_CONVERSATION]: (state, action) => {
    return state.openConversation(action.payload);
  },

  [Constants.MESSENGER.MAIN_AREA_SCROLL]: (state, action) => {
    if (state.isVisible) {
      return state.setIn(["conversations", state.currentConversationId, "scrollBottom"], false);
    }
    return state;
  },

  [Constants.MESSENGER.LOAD_PREVIOUS_MESSAGES]: (state, action) => {
    return state.setIn(["conversations", state.currentConversationId, "isLoadingPrevious"], true);
  },

  [Constants.MESSENGER.NEW_MESSAGE]: (state, action) => {
    const message = action.payload;
    const conversationId = message.conversation_id;
    const isMessageConversationOpened = conversationId == state.currentConversationId;
    var state1 = state;

    //Main area
    if (isMessageConversationOpened) {
      state1 = state1.addMessageInConversation(conversationId, message);
    }

    // Conversations area
    state1 = state1.updateLastMessageFor(conversationId, message)
                   .sortConversationsList();

    if (!isMessageConversationOpened && !message.read) {
      state1 = state1.incrementUnreadedMessagesCountFor(conversationId);
    }

    return state1;
  },

  [Constants.MESSENGER.LOAD_MESSAGES_LIST]: (state, action) => {
    const conversationId = action.payload.conversation_id;
    const sinceId = action.payload.since_id;
    const messages = Immutable.fromJS(action.payload.messages).reverse();

    var state1 = state;
    //Main area
    if (sinceId == 0) {
      state1 = state1.setIn(['conversations', conversationId, 'messages'], messages)
                     .setIn(['conversations', conversationId, 'scrollBottom'], true);
    } else {
      state1 = state1.updateIn(['conversations', conversationId, 'messages'], (m) => messages.concat(m))
                     .setIn(['conversations', conversationId, 'isLoadingPrevious'], false);
    }

    //Conversations Area
    const decrementCount = state1.getUnreadedMessagesCountFor(conversationId);
    state1 = state1.decrementUnreadedMessagesCountFor(conversationId, decrementCount);

    return state1.updateIn(['conversations', conversationId, 'messages'], (list) => {
      return list.map((m) => m.set('read', true));
    });
  }
}, new State());
