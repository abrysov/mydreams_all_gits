import { request, getJson, requestJson }  from 'lib/ajax';
import { createAction } from 'redux-actions';

import Constants from 'Constants';

import {
  buildApiDreamerPhotos
} from "lib/apiUrlsBuilders";

export const hidePhoto = createAction(Constants.PHOTO_VIEWER.HIDE_PHOTO);

const _flipLeft = createAction(Constants.PHOTO_VIEWER.FLIP_LEFT);
export const flipLeft = () => (dispatch, getState) => {
  const photoViewerState = getState().photoViewer.state;
  const currentIndex = photoViewerState.photos.findIndex((p) => p.get('id') === photoViewerState.currentPhotoId);

  dispatch(_flipLeft());
  if (currentIndex - 1 < 0 && photoViewerState.canUploadNext) {
    dispatch(loadNextPhotos());
  }
};

const _flipRight = createAction(Constants.PHOTO_VIEWER.FLIP_RIGHT);
export const flipRight = () => (dispatch, getState) => {
  const photoViewerState = getState().photoViewer.state;
  const currentIndex = photoViewerState.photos.findIndex((p) => p.get('id') === photoViewerState.currentPhotoId);

  dispatch(_flipRight());
  if (currentIndex + 1 >= photoViewerState.photos.size - 3 && photoViewerState.canUploadNext) {
    dispatch(loadNextPhotos());
  }
};

const _pickById = createAction(Constants.PHOTO_VIEWER.PICK_BY_ID);
export const pickById = (id) => (dispatch, getState) => {
  const photoViewerState = getState().photoViewer.state;
  const newIndex = photoViewerState.photos.findIndex((p) => p.get('id') === id);

  dispatch(_pickById(id));
  if (newIndex >= photoViewerState.photos.size - 3 && photoViewerState.canUploadNext) {
    dispatch(loadNextPhotos());
  }
};

const _loadPhotosStart = createAction(Constants.PHOTO_VIEWER.LOAD_PHOTOS_START);
const _loadPhotosFailed = createAction(Constants.PHOTO_VIEWER.LOAD_PHOTOS_FAILED);
const _loadPhotosSuccess = createAction(Constants.PHOTO_VIEWER.LOAD_PHOTOS_SUCCESS);

export const loadNextPhotos = () => (dispatch, getState) => {
  const photoViewerState = getState().photoViewer.state;
  if (photoViewerState.isLoadStarted) { return; }

  const dreamerId = photoViewerState.dreamerId;
  const newPage = photoViewerState.currentPage + 1;

  dispatch(_loadPhotosStart());

  const url = buildApiDreamerPhotos(dreamerId, newPage);

  getJson(url)
    .then(
      (r) => dispatch(_loadPhotosSuccess(r)),
      (xhr, status, error) => dispatch(_loadPhotosFailed())
    );
};
