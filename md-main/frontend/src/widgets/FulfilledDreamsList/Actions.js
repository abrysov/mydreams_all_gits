import { request, getJson, requestJson }  from 'lib/ajax';
import { createAction } from 'redux-actions';
import { push } from 'react-router-redux';

import Constants from 'Constants';

import {
  animateBodyScrollTop
} from "lib/animations";

import {
  buildApiFulfilledDreamsUrl,
  buildApiDreamerFulfilledDreamsUrl,
  buildApiLikeDreamUrl,
  buildApiUnlikeDreamUrl
} from "lib/apiUrlsBuilders";

import {
  buildRouterDreamsUrl
} from "lib/routerUrlBuilders";

import utils from "lib/utils";

function getDreamsUrl(dreamerId, query, page) {
  if (utils.isValidId(dreamerId)) {
    return buildApiDreamerFulfilledDreamsUrl(dreamerId, query, page);
  } else {
    return buildApiFulfilledDreamsUrl(query, page);
  }
}

/** Dream list actions */

export const loadDreamsStart = createAction(Constants.FULFILLED_DREAMS_LIST.LOAD_DREAMS_START);
export const loadDreamsSuccess = createAction(Constants.FULFILLED_DREAMS_LIST.LOAD_DREAMS_SUCCESS);
export const loadNextDreamsSuccess = createAction(Constants.FULFILLED_DREAMS_LIST.LOAD_NEXT_DREAMS_SUCCESS);
export const loadDreamsFailed = createAction(Constants.FULFILLED_DREAMS_LIST.LOAD_DREAMS_FAILED);

export const likeDreamStart = createAction(Constants.FULFILLED_DREAMS_LIST.LIKE_CLICK_START);
export const likeDreamFailed = createAction(Constants.FULFILLED_DREAMS_LIST.LIKE_CLICK_FAILED);
export const likeDreamSuccess = createAction(Constants.FULFILLED_DREAMS_LIST.LIKE_CLICK_SUCCESS);

export const unlikeDreamStart = createAction(Constants.FULFILLED_DREAMS_LIST.UNLIKE_CLICK_START);
export const unlikeDreamFailed = createAction(Constants.FULFILLED_DREAMS_LIST.UNLIKE_CLICK_FAILED);
export const unlikeDreamSuccess = createAction(Constants.FULFILLED_DREAMS_LIST.UNLIKE_CLICK_SUCCESS);

export const loadDreams = (dreamerId) => (dispatch, getState) => {
  const state = getState();
  if (state.fulfilledDreamsList.dreams.isLoadStarted) { return; }

  animateBodyScrollTop();

  dispatch(loadDreamsStart());

  const url = getDreamsUrl(dreamerId, state.routing.locationBeforeTransitions.query, 1);

  getJson(url)
  .then(
    (r) => dispatch(loadDreamsSuccess(r)),
    (xhr, status, error) => dispatch(loadDreamsFailed())
  );
};

export const loadNextDreams = (dreamerId) => (dispatch, getState) => {
  const state = getState();
  if (state.fulfilledDreamsList.dreams.isLoadStarted) { return; }

  const currentPage = state.fulfilledDreamsList.dreams.currentPage;
  const newPage = state.fulfilledDreamsList.dreams.currentPage + 1;

  dispatch(loadDreamsStart());

  const url = getDreamsUrl(dreamerId, state.routing.locationBeforeTransitions.query, newPage);

  getJson(url)
  .then(
    (r) => dispatch(loadNextDreamsSuccess(r)),
    (xhr, status, error) => dispatch(loadDreamsFailed())
  );
};

export const likeDream = (id) => (dispatch, getState) => {
  const state = getState();
  if (state.fulfilledDreamsList.dreams.isLikeProcessing) { return; }

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
  if (state.fulfilledDreamsList.dreams.isLikeProcessing) { return; }

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

export const handleSearchEnter = (search) => (dispatch, getState) => {
  const state = getState();
  const { query } = state.routing.locationBeforeTransitions;

  const url = buildRouterDreamsUrl({ ...query, search });
  dispatch(push(url));
};

/** Create dream actions */

export const handleCreateDreamClick = createAction(Constants.FULFILLED_DREAMS_LIST.HANDLE_CREATE_DREAM_CLICK);
export const handleCloseDreamClick = createAction(Constants.FULFILLED_DREAMS_LIST.HANDLE_CLOSE_DREAM_CLICK);

export const handleSaveImageCropperModal = createAction(Constants.FULFILLED_DREAMS_LIST.HANDLE_SAVE_IMAGE_CROPPER_MODAL);
export const handleCloseImageCropperModal = createAction(Constants.FULFILLED_DREAMS_LIST.HANDLE_CLOSE_IMAGE_CROPPER_MODAL);

const _handleAddDreamStart = createAction(Constants.FULFILLED_DREAMS_LIST.HANDLE_ADD_DREAM_START);
const _handleAddDreamFailed = createAction(Constants.FULFILLED_DREAMS_LIST.HANDLE_ADD_DREAM_FAILED);
const _handleAddDreamSuccess = createAction(Constants.FULFILLED_DREAMS_LIST.HANDLE_ADD_DREAM_SUCCESS);

const _handleFieldChange = createAction(Constants.FULFILLED_DREAMS_LIST.HANDLE_FIELD_CHANGE);
const _handleSelectPhoto = createAction(Constants.FULFILLED_DREAMS_LIST.HANDLE_SELECT_PHOTO);

function buildFormData(state) {
  const formData = new FormData();
  formData.append('title', state.formData.title);
  formData.append('description', state.formData.description);
  formData.append('restriction_level', state.formData.restriction_level);
  formData.append('came_true', state.formData.came_true);
  formData.append('photo', state.formData.photo);
  formData.append('photo_crop[x]', state.formData.crop.x);
  formData.append('photo_crop[y]', state.formData.crop.y);
  formData.append('photo_crop[width]', state.formData.crop.width);
  formData.append('photo_crop[height]', state.formData.crop.height);
  return formData;
}

export const handleAddDream = () => {
  return (dispatch, getState) => {
    const state = getState().fulfilledDreamsList.createDream;
    const url = Routes.api_web_dreams_path();

    const formData = buildFormData(state);

    dispatch(_handleAddDreamStart());

    request(url, 'POST', formData)
      .then((r) => r.json())
      .then(
        (r) => dispatch(_handleAddDreamSuccess(r)),
        (xhr, status, error) => dispatch(_handleAddDreamFailed())
      );
  }
};

export const handleFieldChange = (fieldName, e) => {
  return (dispatch, getState) => {
    dispatch(_handleFieldChange({ fieldName, value: e.target.value }));
  };
};

export function handleSelectPhoto(data) {
  return (dispatch, getState) => {
    dispatch(_handleSelectPhoto(data));
  };
}
