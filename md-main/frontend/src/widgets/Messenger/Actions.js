import Routes from 'routes';
import { getJson }  from 'lib/ajax';
import { createAction } from 'redux-actions';
import messengerWs from "lib/messengerWs";
import utils from "lib/utils";

import Constants from 'Constants';

export const handleMessengerOpened = () => (dispatch, getState) => {
  dispatch(loadConversations())
  .then(() => {
    const conversationId = getState().messenger.conversationIdForOpen;
    if (conversationId > 0) {
      return dispatch(openConversation(conversationId));
    }
  });
}

export const handleConversationIdForOpenChanged = () => (dispatch, getState) => {
  dispatch(loadConversations())
  .then(() => {
    const conversationId = getState().messenger.conversationIdForOpen;
    return dispatch(openConversation(conversationId))
  });
}


const loadConversationsStart = createAction(Constants.MESSENGER.LOAD_CONVERSATIONS_START);
const loadConversationsFailed = createAction(Constants.MESSENGER.LOAD_CONVERSATIONS_FAILED);

const loadConversationsSuccess = createAction(Constants.MESSENGER.LOAD_CONVERSATIONS_SUCCESS);
const loadNextConversationsSuccess = createAction(Constants.MESSENGER.LOAD_NEXT_CONVERSATIONS_SUCCESS);

export const loadConversations = () => (dispatch, getState) => {
  const state = getState();
  if (state.messenger.isConversationsListLoadStarted) { return; }

  const url = Routes.api_web_profile_conversations_path({ page: 1, per_page: 50 });

  dispatch(loadConversationsStart());
  return getJson(url)
    .then((r) => dispatch(loadConversationsSuccess(r)))
    .catch((xhr, status, error) => dispatch(loadConversationsFailed()));
}

export const loadNextConversations = () => (dispatch, getState) => {
  const state = getState();
  if (state.messenger.isConversationsListLoadStarted) { return; }

  const currentPage = state.messenger.currentConversationPage;
  const url = Routes.api_web_profile_conversations_path({ page: currentPage + 1, per_page: 50 });

  dispatch(loadConversationsStart());
  return getJson(url)
    .then((r) => dispatch(loadNextConversationsSuccess(r)))
    .catch((xhr, status, error) => dispatch(loadConversationsFailed()));
}

export const closeMessenger = () => (dispatch, getState) => {
  utils.bodyScroll();
  dispatch(createAction(Constants.MESSENGER.CLOSE_CLICK)());
}

export const openConversation = (id) => (dispatch, getState) => {
  const state = getState();
  const conversationId = state.messenger.currentConversationId;
  if (conversationId != id) {

    messengerWs.list(id);

    return dispatch(_openConversation(id));
  }
}
const _openConversation = createAction(Constants.MESSENGER.OPEN_CONVERSATION);






export const mainAreaScroll = createAction(Constants.MESSENGER.MAIN_AREA_SCROLL);

export const loadPreviousMessages = () => (dispatch, getState) => {
  const state = getState();
  const conversationId = state.messenger.currentConversationId;
  const currentConversation = state.messenger.getCurrentConversation();
  const sinceId = currentConversation.getFirstMessageId();

  if (currentConversation.isLoadingPrevious) { return; }

  messengerWs.list(conversationId, sinceId);

  dispatch(_loadPreviousMessages());
}
const _loadPreviousMessages = createAction(Constants.MESSENGER.LOAD_PREVIOUS_MESSAGES);


export const sendMessage = (message) => (dispatch, getState) => {
  const state = getState();
  const conversationId = state.messenger.currentConversationId;

  const trimmedMessage = message.trim();

  if (trimmedMessage.length > 0) {
    messengerWs.sendTextMessage(conversationId, trimmedMessage);
  }
}



export const _handleLoadMessagesList = createAction(Constants.MESSENGER.LOAD_MESSAGES_LIST);
export const _handleNewMessage = createAction(Constants.MESSENGER.NEW_MESSAGE);

export const handleLoadMessagesList = (payload) => (dispatch, getState) => {
  //TODO: send read for all unread messages if current_conversation
  const conversationId = payload.conversation_id;
  const { currentConversationId, isVisible } = getState().messenger;

  if (!isVisible) return;

  if (conversationId == currentConversationId) {
    payload.messages.forEach((m) => {
      messengerWs.markRead(conversationId, m.id);
    });
  }

  dispatch(_handleLoadMessagesList(payload));
};

export const handleNewMessage = (payload) => (dispatch, getState) => {
  const conversationId = payload.conversation_id;
  const { currentConversationId, isVisible } = getState().messenger;

  if (!isVisible) return;

  if (conversationId == currentConversationId) {
    messengerWs.markRead(conversationId, payload.id);

    payload.read = true;
  }

  dispatch(_handleNewMessage(payload));
};
