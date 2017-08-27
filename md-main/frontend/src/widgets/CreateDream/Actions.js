import Routes from 'routes';
import { request, requestJson, getJson }  from 'lib/ajax';
import { createAction } from 'redux-actions';

import Constants from 'Constants';

export const handleMenuBtnClick = createAction(Constants.CREATE_DREAM.HANDLE_MENU_BTN_CLICK);
export const handleCloseBtnClick = createAction(Constants.CREATE_DREAM.HANDLE_CLOSE_BTN_CLICK);
export const handleCertificateSelect = createAction(Constants.CREATE_DREAM.HANDLE_CERTIFICATE_SELECT);
export const handleAddDreamSuccess = createAction(Constants.CREATE_DREAM.ADD_DREAM_SUCCESS);

const _handleLoadCertificatesSuccess = createAction(Constants.CREATE_DREAM.LOAD_CERTIFICATES_SUCCESS);
export function loadCertificates() {
  return (dispatch, getState) => {
    const url = Routes.api_web_products_path({ certificates: true });

    getJson(url)
    .then((r) => dispatch(_handleLoadCertificatesSuccess(r)));
  }
}

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


export function handleLaunchDream() {
  return (dispatch, getState) => {
    const state = getState().createDream;
    const url = Routes.api_web_dreams_path();

    const formData = buildFormData(state);

    request(url, 'POST', formData)
    .then((r) => r.json())
    .then((r) => {
      const url = Routes.api_web_purchases_certificates_path();

      return requestJson(url, 'POST', {
        destination_id: r.dream.id,
        product_id: state.currentCertificateId
      });
    })
    .then((r) => r.json())
    .then((r) => dispatch(handleAddDreamSuccess(r.dream)));
  }
}

export function handleAddDream() {
  return (dispatch, getState) => {
    const state = getState().createDream;
    const url = Routes.api_web_dreams_path();

    const formData = buildFormData(state);

    request(url, 'POST', formData)
    .then((r) => r.json())
    .then((r) => dispatch(handleAddDreamSuccess(r.dream)));
  }
}

const _handleSelectPhoto = createAction(Constants.CREATE_DREAM.HANDLE_SELECT_PHOTO);
export function handleSelectPhoto(data) {
  return (dispatch, getState) => {
    dispatch(_handleSelectPhoto(data));
  }
}

const _handleFieldChange = createAction(Constants.CREATE_DREAM.HANDLE_FIELD_CHANGE);
export function handleFieldChange(fieldName, e) {
  return (dispatch, getState) => {
    dispatch(_handleFieldChange({ fieldName, value: e.target.value}));
  }
}

export const handleSaveImageCropperModal = createAction(Constants.CREATE_DREAM.HANDLE_SAVE_IMAGE_CROPPER_MODAL);
export const handleCloseImageCropperModal = createAction(Constants.CREATE_DREAM.HANDLE_CLOSE_IMAGE_CROPPER_MODAL);
