import Immutable from "immutable";
import { handleActions } from "redux-actions";
import Constants from "Constants";

class FormData extends Immutable.Record({
  title: "",
  description: "",
  restriction_level: "public", // public | private | friends
  came_true: true,

  photo: null,
  photoDataURI: null,
  crop: null,
  croppedPhoto: null
}) { }

const initialState = {
  isVisible: false,
  isSending: false,
  isImageCropperModalOpened: false,
  formData: new FormData()
};

export class State extends Immutable.Record(initialState) {
  handleFieldChange(fieldName, value) {
    return this.setIn(['formData', fieldName], value);
  }

  handleSelectPhoto(data) {
    return this
      .setIn(['formData', 'photo'], data.file)
      .setIn(['formData', 'photoDataURI'], data.dataURI)
      .set('isImageCropperModalOpened', true);
  }

  handleSaveImageCropperModal({ croppedImage, rect }) {
    return this
      .setIn(['formData', 'crop'], rect)
      .setIn(['formData', 'croppedPhoto'], croppedImage)
      .set('isImageCropperModalOpened', false);
  }

  handleCloseImageCropperModal() {
    return this
      .setIn(['formData', 'photo'], null)
      .setIn(['formData', 'photoDataURI'], null)
      .setIn(['formData', 'croppedPhoto'], null)
      .set('isImageCropperModalOpened', false);
  }
}

export default handleActions({
  [Constants.FULFILLED_DREAMS_LIST.HANDLE_CREATE_DREAM_CLICK]: (state: State, action) => {
    return state.set('isVisible', true);
  },
  [Constants.FULFILLED_DREAMS_LIST.HANDLE_CLOSE_DREAM_CLICK]: (state: State, action) => {
    return state.set('isVisible', false);
  },

  [Constants.FULFILLED_DREAMS_LIST.HANDLE_FIELD_CHANGE]: (state, action) => {
    return state.handleFieldChange(action.payload.fieldName, action.payload.value);
  },
  [Constants.FULFILLED_DREAMS_LIST.HANDLE_SELECT_PHOTO]: (state, action) => {
    return state.handleSelectPhoto(action.payload);
  },
  [Constants.FULFILLED_DREAMS_LIST.HANDLE_SAVE_IMAGE_CROPPER_MODAL]: (state, action) => {
    return state.handleSaveImageCropperModal(action.payload);
  },
  [Constants.FULFILLED_DREAMS_LIST.HANDLE_CLOSE_IMAGE_CROPPER_MODAL]: (state, action) => {
    return state.handleCloseImageCropperModal();
  },

  [Constants.FULFILLED_DREAMS_LIST.HANDLE_ADD_DREAM_START]: (state, action) => {
    return state.set('isSending', true);
  },
  [Constants.FULFILLED_DREAMS_LIST.HANDLE_ADD_DREAM_FAILED]: (state, action) => {
    // TODO : message about error.
    return state.set('isSending', false);
  },
  [Constants.FULFILLED_DREAMS_LIST.HANDLE_ADD_DREAM_SUCCESS]: (state, action) => {
    return new State();
  }
}, new State());
