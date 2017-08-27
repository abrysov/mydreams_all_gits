import Routes from 'routes';
import { getJson, requestJson, request }  from 'lib/ajax';
import { createAction } from 'redux-actions';
import Constants from 'Constants';


export const _loadDreamStart = createAction(Constants.DREAM_PAGE.LOAD_DREAM_START);
export const _loadDreamSuccess = createAction(Constants.DREAM_PAGE.LOAD_DREAM_SUCCESS);
export const _loadDreamFailed = createAction(Constants.DREAM_PAGE.LOAD_DREAM_FAILED);

export const loadDream = (id) => (dispatch, getState) => {
  dispatch(_loadDreamStart());
  getJson(Routes.api_web_dream_path(id))
  .then(r => dispatch(_loadDreamSuccess(r)),
        r => dispatch(_loadDreamFailed(r)));
}

export const handleBuyMarkClick = () => (dispatch, getState) => {
  const state = getState();

  const currentUserId = state.user.getCached('id');
  const dream = state.dreamPage.dream.toJS();
  const dreamerId = dream.dreamer.id;

  if (currentUserId == dreamerId) {
    dispatch(createAction(Constants.GIFT_MODALS.BUY_MARKS)(dream));
  } else {
    dispatch(createAction(Constants.GIFT_MODALS.PRESENT_MARKS)(dream));
  }
}

export const handleStartEdit = createAction(Constants.DREAM_PAGE.START_EDIT);
export const handleCancelEdit = createAction(Constants.DREAM_PAGE.CANCEL_EDIT);
export const handlePhotoChange = createAction(Constants.DREAM_PAGE.PHOTO_CHANGE);
export const handleFieldChange = createAction(Constants.DREAM_PAGE.FIELD_CHANGE);

export const _saveDreamSuccess = createAction(Constants.DREAM_PAGE.SAVE_DREAM_SUCCESS);

export const handleSave = () => (dispatch, getState) => {
  const state = getState().dreamPage;
  const dream = state.dream.toJS();
  const updatedPhoto = state.updatedPhoto;

  const formData = new FormData();
  formData.append('title', dream.title);
  formData.append('description', dream.description);

  if (updatedPhoto.photo) {
    formData.append('photo', updatedPhoto.photo);
    formData.append('photo_crop[x]', updatedPhoto.rect.x);
    formData.append('photo_crop[y]', updatedPhoto.rect.y);
    formData.append('photo_crop[width]', updatedPhoto.rect.width);
    formData.append('photo_crop[height]', updatedPhoto.rect.height);
  }

  request(Routes.api_web_dream_path(dream.id), "PUT", formData)
    .then((r) => r.json())
    .then(r => dispatch(_saveDreamSuccess(r)));
};

export const handleRemove = () => (dispatch, getState) => {
};
