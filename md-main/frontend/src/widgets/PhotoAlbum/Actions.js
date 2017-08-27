import { request, getJson, requestJson }  from 'lib/ajax';
import { createAction } from 'redux-actions';

import Constants from 'Constants';

import {
  animateBodyScrollTop
} from "lib/animations";

import {
  buildApiDreamerPhotos,
  buildApiUploadProfilePhotos
} from "lib/apiUrlsBuilders";

/** Loading list of photos */

const _loadPhotosStart = createAction(Constants.PHOTO_ALBUM.LOAD_PHOTOS_START);
const _loadPhotosSuccess = createAction(Constants.PHOTO_ALBUM.LOAD_PHOTOS_SUCCESS);
const _loadNextPhotosSuccess = createAction(Constants.PHOTO_ALBUM.LOAD_NEXT_PHOTOS_SUCCESS);
const _loadPhotosFailed = createAction(Constants.PHOTO_ALBUM.LOAD_PHOTOS_FAILED);

export const loadPhotos = (dreamerId) => (dispatch, getState) => {
  const state = getState();
  if (state.photoAlbum.photos.isLoadStarted) { return; }

  animateBodyScrollTop();

  dispatch(_loadPhotosStart());

  const url = buildApiDreamerPhotos(dreamerId, 1);

  getJson(url)
    .then(
      (r) => dispatch(_loadPhotosSuccess(r)),
      (xhr, status, error) => dispatch(_loadPhotosFailed())
    );
};

export const loadNextPhotos = (dreamerId) => (dispatch, getState) => {
  const state = getState();
  if (state.photoAlbum.photos.isLoadStarted) { return; }

  const newPage = state.photoAlbum.photos.currentPage + 1;

  dispatch(_loadPhotosStart());

  const url = buildApiDreamerPhotos(dreamerId, newPage);

  getJson(url)
    .then(
      (r) => dispatch(_loadNextPhotosSuccess(r)),
      (xhr, status, error) => dispatch(_loadPhotosFailed())
    );
};

/** Showing photos */

export const showPhoto = createAction(Constants.PHOTO_VIEWER.SHOW_PHOTO);

/** Uploading new photos */

const _uploadPhotosSuccess = createAction(Constants.PHOTO_ALBUM.UPLOAD_PHOTO_SUCCESS);

export const uploadPhoto = (photo) => (dispatch, getState) => {
  const formData = new FormData();
  formData.append('file', photo);

  const url = buildApiUploadProfilePhotos();

  request(url, 'POST', formData)
    .then((r) => r.json())
    .then(
      (r) => dispatch(_uploadPhotosSuccess(r))
    );
};