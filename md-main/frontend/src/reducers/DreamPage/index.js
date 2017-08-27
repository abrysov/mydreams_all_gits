import Immutable from "immutable";
import { handleActions } from "redux-actions";
import Constants from "Constants";

import { State } from "./State";

export default handleActions({
  [Constants.DREAM_PAGE.LOAD_DREAM_START]: (state, action) => state.handleLoadDreamStart(),
  [Constants.DREAM_PAGE.LOAD_DREAM_FAILED]: (state, action) => state.handleLoadDreamFailed(),
  [Constants.DREAM_PAGE.LOAD_DREAM_SUCCESS]: (state, action) => state.handleLoadDreamSuccess(action.payload),
  [Constants.DREAM_PAGE.START_EDIT]: (state, action) => state.handleStartEdit(),
  [Constants.DREAM_PAGE.CANCEL_EDIT]: (state, action) => state.handleCancelEdit(),
  [Constants.DREAM_PAGE.PHOTO_CHANGE]: (state, action) => state.handlePhotoChange(action.payload),
  [Constants.DREAM_PAGE.FIELD_CHANGE]: (state, action) => state.handleFieldChange(action.payload),
  [Constants.DREAM_PAGE.SAVE_DREAM_SUCCESS]: (state, action) => state.handleSaveDreamSuccess(action.payload),
}, new State());


