import Immutable from "immutable";
import { handleActions } from "redux-actions";
import Constants from "Constants";

import { State } from "./State";

export default handleActions({
  [Constants.DREAMER_INFO.LOAD_DREAMER_INFO_SUCCESS]: (state, action) => {
    return state.set('dreamer', Immutable.fromJS(action.payload.dreamer));
  },
  [Constants.DREAMER_INFO.ADD_FRIEND_CLICK]: (state, action) => {
    return state.setIn(['dreamer', 'i_friend'], true);
  },
  [Constants.DREAMER_INFO.REMOVE_FRIEND_CLICK]: (state, action) => {
    return state.setIn(['dreamer', 'i_friend'], false);
  },
  [Constants.DREAMER_INFO.UPDATE_STATUS]: (state, action) => {
    return state.setIn(['dreamer', 'status'], action.payload);
  },
}, new State());


