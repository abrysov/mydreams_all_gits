import Immutable from "immutable";
import { handleActions } from "redux-actions";
import Constants from "Constants";

import { State } from "./State";

export default handleActions({
  [Constants.UPDATES_FEED.LOAD_UPDATES_START]: (state, action) => {
    return state.set('isLoadStarted', true);
  },
  [Constants.UPDATES_FEED.LOAD_UPDATES_FAILED]: (state, action) => {
    return state.set('isLoadStarted', false);
  },

  [Constants.UPDATES_FEED.LOAD_UPDATES_SUCCESS]: (state, action) => {
    return state.handleLoadUpdatesSuccess(action.payload);
  },

  [Constants.UPDATES_FEED.LOAD_NEXT_UPDATES_SUCCESS]: (state, action) => {
    return state.handleLoadNextUpdatesSuccess(action.payload);
  }
}, new State());

