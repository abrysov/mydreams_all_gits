import { getJson, requestJson }  from 'lib/ajax';
import { createAction } from 'redux-actions';
import { push } from 'react-router-redux';

import Constants from 'Constants';

import {
  animateBodyScrollTop
} from "lib/animations";

import {
  buildApiDreamersUrl
} from "lib/apiUrlsBuilders";

import {
  buildRouterDreamersUrl
} from "lib/routerUrlBuilders";

export const initWidget = createAction(Constants.DREAMERS_LIST.INIT_WIDGET);
export const loadDreamersStart = createAction(Constants.DREAMERS_LIST.LOAD_DREAMERS_START);
export const loadDreamersSuccess = createAction(Constants.DREAMERS_LIST.LOAD_DREAMERS_SUCCESS);
export const loadNextDreamersSuccess = createAction(Constants.DREAMERS_LIST.LOAD_NEXT_DREAMERS_SUCCESS);
export const loadDreamersFailed = createAction(Constants.DREAMERS_LIST.LOAD_DREAMERS_FAILED);
export const filterChange = createAction(Constants.DREAMERS_LIST.FILTER_CHANGE);

export const loadDreamers = () => (dispatch, getState) => {
  const state = getState();
  if (state.dreamersList.isLoadStarted) { return; }

  animateBodyScrollTop();

  const additionalParams = {
    widgetType: state.dreamersList.getType(),
    dreamerId: state.dreamersList.getDreamerId()
  };

  const url = buildApiDreamersUrl(state.routing.locationBeforeTransitions.query, 1, additionalParams);
  dispatch(loadDreamersStart());

  getJson(url).then((r) => {
    dispatch(loadDreamersSuccess(r));
  }, (xhr, status, error) => {
    dispatch(loadDreamersFailed());
  });
}

export const loadNextDreamers = () => (dispatch, getState) => {
  const state = getState();
  if (state.dreamersList.isLoadStarted) { return; }

  const currentPage = state.dreamersList.currentPage;
  const newPage = state.dreamersList.currentPage + 1;

  dispatch(loadDreamersStart());

  const additionalParams = {
    widgetType: state.dreamersList.getType(),
    dreamerId: state.dreamersList.getDreamerId()
  };

  const url = buildApiDreamersUrl(state.routing.locationBeforeTransitions.query, 1, additionalParams);
  getJson(url)
  .then((r) => {
    dispatch(loadNextDreamersSuccess(r));
  }, (xhr, status, error) => {
    dispatch(loadDreamersFailed());
  });
};

export const handleFilterSelect = (newData) => (dispatch, getState) => {
  const { query } = getState().routing.locationBeforeTransitions;

  const url = buildRouterDreamersUrl(query, newData);

  dispatch(push(url));
};

const _handleSendMessageClick = createAction(Constants.DREAMERS_LIST.SEND_MESSAGE_CLICK);
export const handleSendMessageClick = (dreamerId) => (dispatch, getState) => {
  const conversationInfoUrl = Routes.api_web_profile_conversations_path();
  requestJson(conversationInfoUrl, 'POST', {
    id: dreamerId
  })
  .then((r) => r.json())
  .then((r) => dispatch(_handleSendMessageClick(r.conversation)));
}

const _handleAddFriendClick = createAction(Constants.DREAMERS_LIST.ADD_FRIEND_CLICK);
export const handleAddFriendClick = (dreamerId) => (dispatch, getState) => {
  const url = Routes.api_web_profile_friendship_requests_path();
  requestJson(url, 'POST', { id: dreamerId })
  .then((r) => r.json())
  .then((r) => dispatch(_handleAddFriendClick(dreamerId)));
}

const _handleRemoveFriendClick = createAction(Constants.DREAMERS_LIST.REMOVE_FRIEND_CLICK);
export const handleRemoveFriendClick = (dreamerId) => (dispatch, getState) => {
  const url = Routes.api_web_profile_friendship_request_path(dreamerId);
  requestJson(url, 'DELETE')
  .then((r) => r.json())
  .then((r) => dispatch(_handleRemoveFriendClick(dreamerId)));
}

const _handleApproveFriendClick = createAction(Constants.DREAMERS_LIST.APPROVE_FRIEND_CLICK);
export const handleApproveFriendClick = (dreamerId) => (dispatch, getState) => {
  const url = Routes.accept_api_web_profile_friendship_requests_path();
  requestJson(url, 'POST', { id: dreamerId })
  .then((r) => r.json())
  .then((r) => dispatch(_handleApproveFriendClick(dreamerId)));
}

const _handleRejectFriendClick = createAction(Constants.DREAMERS_LIST.REJECT_FRIEND_CLICK);
export const handleRejectFriendClick = (dreamerId) => (dispatch, getState) => {
  const url = Routes.reject_api_web_profile_friendship_request_path(dreamerId);
  requestJson(url, 'DELETE')
  .then((r) => r.json())
  .then((r) => dispatch(_handleRejectFriendClick(dreamerId)));
}
