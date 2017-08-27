import Immutable from "immutable";
import { handleActions } from "redux-actions";
import Constants from "Constants";

import { State } from "./State";

export default handleActions({
  [Constants.LIKES_MODAL.CLOSE]: (state, action) => new State(),
  [Constants.LIKES_MODAL.SHOW_MODAL]: (state, action) => state.handleShowModal(action.payload),
  [Constants.LIKES_MODAL.LOAD_LIKES_SUCCESS]: (state, action) => state.handleLoadLikesSuccess(action.payload),
  [Constants.LIKES_MODAL.LOAD_NEXT_LIKES_SUCCESS]: (state, action) => state.handleLoadNextLikesSuccess(action.payload),
  [Constants.LIKES_MODAL.SET_PAGE]: (state, action) => state.handleSetPage(action.payload),
}, new State());
