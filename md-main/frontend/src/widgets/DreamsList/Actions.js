import { getJson, requestJson } from 'lib/ajax';
import { createAction } from 'redux-actions';
import { push } from 'react-router-redux';

import Constants from 'Constants';

import {
  animateBodyScrollTop
} from "lib/animations";

import {
  buildApiDreamsUrl,
  buildApiDreamerDreamsUrl,
  buildApiDreamLikesUrl,
  buildApiLikeDreamUrl,
  buildApiUnlikeDreamUrl
} from "lib/apiUrlsBuilders";

import {
  buildRouterDreamsUrl,
  buildRouterDreamerDreamsUrl
} from "lib/routerUrlBuilders";

function getDreamerDreamsUrl(props = {}, query = {}, page = 1) {
  return props.onlyMyDreams ?
    buildApiDreamerDreamsUrl(query, props.userId, page) :
    buildApiDreamsUrl(query, page);
}

export const loadDreamsStart = createAction(Constants.DREAMS_LIST.LOAD_DREAMS_START);
export const loadDreamsSuccess = createAction(Constants.DREAMS_LIST.LOAD_DREAMS_SUCCESS);
export const loadNextDreamsSuccess = createAction(Constants.DREAMS_LIST.LOAD_NEXT_DREAMS_SUCCESS);
export const loadDreamsFailed = createAction(Constants.DREAMS_LIST.LOAD_DREAMS_FAILED);

export const likeDreamStart = createAction(Constants.DREAMS_LIST.LIKE_CLICK_START);
export const likeDreamFailed = createAction(Constants.DREAMS_LIST.LIKE_CLICK_FAILED);
export const likeDreamSuccess = createAction(Constants.DREAMS_LIST.LIKE_CLICK_SUCCESS);

export const unlikeDreamStart = createAction(Constants.DREAMS_LIST.UNLIKE_CLICK_START);
export const unlikeDreamFailed = createAction(Constants.DREAMS_LIST.UNLIKE_CLICK_FAILED);
export const unlikeDreamSuccess = createAction(Constants.DREAMS_LIST.UNLIKE_CLICK_SUCCESS);

export const loadDreams = (props) => (dispatch, getState) => {
  const state = getState();
  if (state.dreamsList.dreams.isLoadStarted) { return; }

  animateBodyScrollTop();

  dispatch(loadDreamsStart());

  const url = getDreamerDreamsUrl(props, state.routing.locationBeforeTransitions.query, 1);

  getJson(url)
    .then(
      (r) => dispatch(loadDreamsSuccess(r)),
      (xhr, status, error) => dispatch(loadDreamsFailed())
    );
};

export const loadNextDreams = (props) => (dispatch, getState) => {
  const state = getState();
  if (state.dreamsList.dreams.isLoadStarted) { return; }

  const currentPage = state.dreamsList.dreams.currentPage;
  const newPage = state.dreamsList.dreams.currentPage + 1;

  dispatch(loadDreamsStart());

  const url = getDreamerDreamsUrl(props, state.routing.locationBeforeTransitions.query, newPage);

  getJson(url)
    .then(
      (r) => dispatch(loadNextDreamsSuccess(r)),
      (xhr, status, error) => dispatch(loadDreamsFailed())
    );
};

export const handleSortBy = (newSortBy, props) => (dispatch, getState) => {
  const state  = getState();
  if (state.dreamsList.dreams.isLoadStarted) { return; }

  const currentSortBy = state.dreamsList.dreams.sortBy;

  if (newSortBy === currentSortBy) { return; }

  animateBodyScrollTop();

  dispatch(loadDreamsStart());

  const query = state.routing.locationBeforeTransitions.query;
  delete query[currentSortBy];
  query[newSortBy] = true;

  const url = getDreamerDreamsUrl(props, query, 1);

  getJson(url)
    .then(
      (r) => {
        r.sortBy = newSortBy;
        dispatch(loadDreamsSuccess(r));
      },
      (xhr, status, error) => dispatch(loadDreamsFailed())
    );
};

export const handleSearchEnter = (search) => (dispatch, getState) => {
  const state = getState();
  const { query } = state.routing.locationBeforeTransitions;

  const url = buildRouterDreamsUrl(query, { search });
  dispatch(push(url));
};

export const likeDream = (id) => (dispatch, getState) => {
  const state = getState();
  if (state.dreamsList.dreams.isLikeProcessing) { return; }

  dispatch(likeDreamStart());

  const url = buildApiLikeDreamUrl(id);

  requestJson(url, 'POST')
    .then(
      (r) => {
        r.dreamId = id;
        dispatch(likeDreamSuccess(r));
      },
      (xhr, status, error) => dispatch(likeDreamFailed())
    );
};

export const unlikeDream = (id) => (dispatch, getState) => {
  const state = getState();
  if (state.dreamsList.dreams.isLikeProcessing) { return; }

  dispatch(unlikeDreamStart());

  const url = buildApiUnlikeDreamUrl(id);

  requestJson(url, 'DELETE')
    .then(
      (r) => {
        r.dreamId = id;
        dispatch(unlikeDreamSuccess(r));
      },
      (xhr, status, error) => dispatch(unlikeDreamFailed())
    );
};
