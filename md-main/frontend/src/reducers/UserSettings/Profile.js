import Immutable from "immutable";
import { handleActions } from "redux-actions";
import Constants from "Constants";

class ProfileSettings extends Immutable.Record({
  avatar: null,
  first_name: '',
  last_name: '',
  birthday: '',
  gender: '',
  countryId: null,
  cityId: null,

  photo: null,
  photoDataURI: null,
  crop: null,
  croppedPhoto: null
}) { }

const initialState = {
  isProcessing: false,
  isImageCropperModalOpened: false,
  currentAvatar: '',
  settings: new ProfileSettings()
};

export class State extends Immutable.Record(initialState) {
  handleSelectPhoto(data) {
    return this
      .setIn(['settings', 'photo'], data.file)
      .setIn(['settings', 'photoDataURI'], data.dataURI)
      .set('isImageCropperModalOpened', true);
  }

  handleSaveImageCropperModal({ croppedImage, rect }) {
    return this
      .setIn(['settings', 'crop'], rect)
      .setIn(['settings', 'croppedPhoto'], croppedImage)
      .set('isImageCropperModalOpened', false);
  }

  handleCloseImageCropperModal() {
    return this
      .setIn(['settings', 'photo'], null)
      .setIn(['settings', 'photoDataURI'], null)
      .setIn(['settings', 'croppedPhoto'], null)
      .set('isImageCropperModalOpened', false);
  }
}

export default handleActions({
  [Constants.USER_PROFILE_SETTINGS.LOAD_SETTINGS_START]: (state:State, action) => {
    return state.set('isProcessing', true);
  },
  [Constants.USER_PROFILE_SETTINGS.LOAD_SETTINGS_FAILED]: (state:State, action) => {
    return state.set('isProcessing', false);
  },
  [Constants.USER_PROFILE_SETTINGS.LOAD_SETTINGS_SUCCESS]: (state:State, action) => {
    const d = action.payload.dreamer;
    const currentAvatar = (d.avatar && d.avatar.medium) ? d.avatar.medium : '';
    return state.setIn(['settings', 'first_name'], d.first_name)
                .setIn(['settings', 'last_name'], d.last_name)
                .setIn(['settings', 'birthday'], d.birthday)
                .setIn(['settings', 'gender'], d.gender)
                .setIn(['settings', 'countryId'], d.country.id)
                .setIn(['settings', 'cityId'], d.city.id)
                .set('currentAvatar', currentAvatar)
                .set('isProcessing', false);
  },

  [Constants.USER_PROFILE_SETTINGS.HANDLE_SELECT_PHOTO]: (state, action) => {
    return state.handleSelectPhoto(action.payload);
  },
  [Constants.USER_PROFILE_SETTINGS.HANDLE_SAVE_IMAGE_CROPPER_MODAL]: (state, action) => {
    return state.handleSaveImageCropperModal(action.payload);
  },
  [Constants.USER_PROFILE_SETTINGS.HANDLE_CLOSE_IMAGE_CROPPER_MODAL]: (state, action) => {
    return state.handleCloseImageCropperModal();
  },

  [Constants.USER_PROFILE_SETTINGS.CHANGE_FIELD]: (state:State, action) => {
    return state.setIn(['settings', action.payload.fieldName], action.payload.value);
  },

  [Constants.USER_PROFILE_SETTINGS.SAVE_SETTINGS_START]: (state:State, action) => {
    return state.set('isProcessing', true);
  },
  [Constants.USER_PROFILE_SETTINGS.SAVE_SETTINGS_FAILED]: (state:State, action) => {
    return state.set('isProcessing', false);
  },
  [Constants.USER_PROFILE_SETTINGS.SAVE_SETTINGS_SUCCESS]: (state:State, action) => {
    return state.set('isProcessing', false);
  }
}, new State());