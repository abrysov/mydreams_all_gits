import Routes from 'routes';
import { getJson, requestJson }  from 'lib/ajax';
import { createAction } from 'redux-actions';

import Constants from 'Constants';

export const loadLeadersSuccess = createAction(Constants.LEADERS_BAR.LOAD_LEADERS_SUCCESS);
export const showAddModal = createAction(Constants.LEADERS_BAR.SHOW_ADD_MODAL);
export const closeAddModal = createAction(Constants.LEADERS_BAR.CLOSE_ADD_MODAL);
export const addPhotoSuccess = createAction(Constants.LEADERS_BAR.ADD_PHOTO_SUCCESS);

export const loadLeaders = () => (dispatch, getState) => {
  getJson(Routes.api_web_leaders_path())
  .then(r => dispatch(loadLeadersSuccess(r)));
};

export const addPhoto = (photo_id, message) => (dispatch, getState) => {
  requestJson(Routes.api_web_leaders_path(), "POST", {
    photo_id,
    message
  })
  .then((r) => r.json())
  .then((r) => dispatch(addPhotoSuccess(r)));
}
