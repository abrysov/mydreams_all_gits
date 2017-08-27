import { request, getJson, requestJson }  from 'lib/ajax';
import { createAction } from 'redux-actions';

import Constants from 'Constants';

import {
  buildApiCertificatesUrl
} from "lib/apiUrlsBuilders";

/** Profile */

const _loadProfileSettingsStart = createAction(Constants.USER_PROFILE_SETTINGS.LOAD_SETTINGS_START);
const _loadProfileSettingsFailed = createAction(Constants.USER_PROFILE_SETTINGS.LOAD_SETTINGS_FAILED);
const _loadProfileSettingsSuccess = createAction(Constants.USER_PROFILE_SETTINGS.LOAD_SETTINGS_SUCCESS);

const _saveProfileSettingsStart = createAction(Constants.USER_PROFILE_SETTINGS.SAVE_SETTINGS_START);
const _saveProfileSettingsFailed = createAction(Constants.USER_PROFILE_SETTINGS.SAVE_SETTINGS_FAILED);
const _saveProfileSettingsSuccess = createAction(Constants.USER_PROFILE_SETTINGS.SAVE_SETTINGS_SUCCESS);

export const loadProfileSettings = () => (dispatch, getState) => {
  const state = getState();
  if (state.userSettings.profile.isProcessing) { return; }

  dispatch(_loadProfileSettingsStart());

  const url = Routes.api_web_me_path();

  getJson(url)
    .then(
      (r) => dispatch(_loadProfileSettingsSuccess(r)),
      () => dispatch(_loadProfileSettingsFailed())
    );
};

export const handleSelectPhoto = createAction(Constants.USER_PROFILE_SETTINGS.HANDLE_SELECT_PHOTO);
export const handleSaveImageCropperModal = createAction(Constants.USER_PROFILE_SETTINGS.HANDLE_SAVE_IMAGE_CROPPER_MODAL);
export const handleCloseImageCropperModal = createAction(Constants.USER_PROFILE_SETTINGS.HANDLE_CLOSE_IMAGE_CROPPER_MODAL);

export const changeProfileField = createAction(Constants.USER_PROFILE_SETTINGS.CHANGE_FIELD);

function createProfileFormData(settings) {
  const form = new FormData();
  form.append('avatar', settings.croppedPhoto);
  form.append('first_name', settings.first_name);
  form.append('last_name', settings.last_name);
  form.append('birthday', settings.birthday);
  form.append('gender', settings.gender);
  form.append('country_id', settings.countryId);
  form.append('city_id', settings.cityId);
  return form;
}

export const saveProfileSettings = () => (dispatch, getState) => {
  const state = getState();
  if (state.userSettings.profile.isProcessing) { return; }

  dispatch(_saveProfileSettingsStart());

  const data = createProfileFormData(state.userSettings.profile.settings);
  const url = Routes.api_web_profile_path();

  request(url, 'PUT', data)
    .then((r) => r.json())
    .then(
      (r) => dispatch(_saveProfileSettingsSuccess(r)),
      () => dispatch(_saveProfileSettingsFailed())
    );
};

/** Account */

const _loadAccountSettingsStart = createAction(Constants.USER_ACCOUNT_SETTINGS.LOAD_SETTINGS_START);
const _loadAccountSettingsFailed = createAction(Constants.USER_ACCOUNT_SETTINGS.LOAD_SETTINGS_FAILED);
const _loadAccountSettingsSuccess = createAction(Constants.USER_ACCOUNT_SETTINGS.LOAD_SETTINGS_SUCCESS);

const _loadLanguagesSuccess = createAction(Constants.USER_ACCOUNT_SETTINGS.LOAD_LANGUAGES);

export const changeAccountField = createAction(Constants.USER_ACCOUNT_SETTINGS.CHANGE_FIELD);

const _saveAccountEmailStart = createAction(Constants.USER_ACCOUNT_SETTINGS.SAVE_EMAIL_START);
const _saveAccountEmailFailed = createAction(Constants.USER_ACCOUNT_SETTINGS.SAVE_EMAIL_FAILED);
const _saveAccountEmailSuccess = createAction(Constants.USER_ACCOUNT_SETTINGS.SAVE_EMAIL_SUCCESS);

const _saveAccountPasswordStart = createAction(Constants.USER_ACCOUNT_SETTINGS.SAVE_PASSWORD_START);
const _saveAccountPasswordFailed = createAction(Constants.USER_ACCOUNT_SETTINGS.SAVE_PASSWORD_FAILED);
const _saveAccountPasswordSuccess = createAction(Constants.USER_ACCOUNT_SETTINGS.SAVE_PASSWORD_SUCCESS);

export const loadAccountSettings = () => (dispatch, getState) => {
  const state = getState();
  if (state.userSettings.account.isProcessing) { return; }

  dispatch(_loadAccountSettingsStart());

  const url = Routes.api_web_me_path();

  getJson(url)
    .then(
      (r) => dispatch(_loadAccountSettingsSuccess(r)),
      () => dispatch(_loadAccountSettingsFailed())
    );
};

export const loadLanguages = () => (dispatch, getState) => {
  // const languageUrl = Routes.api_web_languages_path();
  // getJson(countryUrl)
  //   .then((r) => dispatch(_loadCountriesSuccess(r)));
};

function createEmailFormData(settings) {
  const form = new FormData();
  form.append('email', settings.email);
  return form;
}

function createPasswordFormData(settings) {
  const form = new FormData();
  form.append('current_password', settings.current_password);
  form.append('password', settings.password);
  form.append('password_confirmation', settings.password_confirmation);
  return form;
}

export const saveAccountSettings = () => (dispatch, getState) => {
  const state = getState();
  if (state.userSettings.profile.isProcessing) { return; }

  const settings = state.userSettings.account.settings;

  if (settings.email) {
    const changeEmailUrl = Routes.change_email_api_web_profile_settings_path();
    const emailData = createEmailFormData();

    dispatch(_saveAccountEmailStart());
    request(changeEmailUrl, 'POST', emailData)
      .then(
        () => dispatch(_saveAccountEmailSuccess()),
        () => dispatch(_saveAccountEmailFailed())
      );
  }

  if (settings.password) {
    const changePasswordUrl = Routes.change_password_api_web_profile_settings_path();
    const passwordData = createPasswordFormData();

    dispatch(_saveAccountPasswordStart());
    request(changePasswordUrl, 'POST', passwordData)
      .then(
        () => dispatch(_saveAccountPasswordSuccess()),
        () => dispatch(_saveAccountPasswordFailed())
      );
  }
};
