import Immutable from "immutable";
import { handleActions } from "redux-actions";
import Constants from "Constants";

import { State } from "./State";

export default handleActions({
  [Constants.CREATE_DREAM.HANDLE_MENU_BTN_CLICK]: (state, action) => {
    return state.set('isVisible', true);
  },
  [Constants.CREATE_DREAM.HANDLE_CLOSE_BTN_CLICK]: (state, action) => {
    return new State();
  },
  [Constants.CREATE_DREAM.LOAD_CERTIFICATES_SUCCESS]: (state, action) => {
    return state.handleLoadCertificatesSuccess(action.payload);
  },
  [Constants.CREATE_DREAM.HANDLE_CERTIFICATE_SELECT]: (state, action) => {
    return state.handleCertificateSelect(action.payload);
  },
  [Constants.CREATE_DREAM.HANDLE_SELECT_PHOTO]: (state, action) => {
    return state.handleSelectPhoto(action.payload);
  },
  [Constants.CREATE_DREAM.HANDLE_FIELD_CHANGE]: (state, action) => {
    return state.handleFieldChange(action.payload.fieldName, action.payload.value);
  },
  [Constants.CREATE_DREAM.HANDLE_SAVE_IMAGE_CROPPER_MODAL]: (state, action) => {
    return state.handleSaveImageCropperModal(action.payload);
  },
  [Constants.CREATE_DREAM.HANDLE_CLOSE_IMAGE_CROPPER_MODAL]: (state, action) => {
    return state.handleCloseImageCropperModal();
  },
  [Constants.CREATE_DREAM.ADD_DREAM_SUCCESS]: (state, action) => {
    return new State();
  }
}, new State());

