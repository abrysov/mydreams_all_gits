import Routes from 'routes';
import { requestJson }  from 'lib/ajax';
import { createAction } from 'redux-actions';

import Constants from 'Constants';

import utils from "lib/utils";

export const closeNotification = createAction(Constants.NOTIFICATIONS_LIST.CLOSE_NOTIFICATION);

export const _handleNewMessage = createAction(Constants.NOTIFICATIONS_LIST.NEW_MESSAGE);
export const handleNewMessage = (payload) => (dispatch, getState) => {
  const isConversationOpened = getState().messenger.isConversationOpened(payload.conversation_id);
  const isCurrentUser = getState().user.getId() == payload.dreamer_id;

  const showNotification = !(isConversationOpened || isCurrentUser);

  if (showNotification) {
    dispatch(_handleNewMessage(payload));
  }
};


export const _handleNewMessageClick = createAction(Constants.NOTIFICATIONS_LIST.NEW_MESSAGE_CLICK);
export const handleNotificationClick = (id) => (dispatch, getState) => {
  const notification = getState().notificationsList.getById(id);

  if (notification) {
    dispatch(_handleNewMessageClick(notification));
  }
};


