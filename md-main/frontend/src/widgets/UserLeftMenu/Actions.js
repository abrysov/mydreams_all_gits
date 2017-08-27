import Routes from 'routes';
import { requestJson }  from 'lib/ajax';
import { createAction } from 'redux-actions';

import Constants from 'Constants';

import utils from "lib/utils";

export const loadUserSuccess = createAction(Constants.USER.LOAD_USER_SUCCESS);

export const messagesClick = () => (dispatch, getState) => {
  utils.bodyScroll(false);
  dispatch(createAction(Constants.USER.MESSAGES_CLICK)());
}

export const loadUser = () => (dispatch, getState) => {
  requestJson(Routes.api_web_me_path())
    .then(r => r.json())
    .then(r => dispatch(loadUserSuccess(r)));
}

