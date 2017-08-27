import Routes from 'routes';
import { getJson }  from 'lib/ajax';
import { createAction } from 'redux-actions';

import Constants from 'Constants';

export const closeModal = createAction(Constants.LIKES_MODAL.CLOSE);

const _loadLikesSuccess = createAction(Constants.LIKES_MODAL.LOAD_LIKES_SUCCESS);
const _loadNextLikesSuccess = createAction(Constants.LIKES_MODAL.LOAD_NEXT_LIKES_SUCCESS);
const _showModal = createAction(Constants.LIKES_MODAL.SHOW_MODAL);
const _setPage = createAction(Constants.LIKES_MODAL.SET_PAGE);

function fetchLikes(getState, page = 1) {
  const state = getState().likesModal;
  const { entityType, entityId, per } = state;

  return getJson(Routes.api_web_likes_path({
    entity_type: entityType,
    entity_id: entityId,
    page,
    per
  }));
}

export const showModal = (entityType, entityId) => (dispatch, getState) => {
  const page = 1;
  const perPage = getState().likesModal.per;

  dispatch(_showModal({ entityType, entityId }));

  fetchLikes(getState, page)
    .then((r) => dispatch(_loadLikesSuccess(r)));
};

export const handleUpClick = () => (dispatch, getState) => {
  const state = getState().likesModal;
  if (!state.isUpButtonEnabled()) return;

  const displayPage = state.displayPage - 1;
  dispatch(_setPage(displayPage));
};

export const handleDownClick = () => (dispatch, getState) => {
  const state = getState().likesModal;
  if (!state.isDownButtonEnabled()) return;

  const displayPage = state.displayPage + 1;

  if (state.getLoadedPagesCount() < displayPage) {
    fetchLikes(getState, state.page + 1)
      .then((r) => dispatch(_loadNextLikesSuccess(r)));
  } else {
    dispatch(_setPage(displayPage));
  }
};
