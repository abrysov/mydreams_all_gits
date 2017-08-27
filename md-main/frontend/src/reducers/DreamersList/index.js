import Immutable from "immutable";
import { handleActions } from "redux-actions";
import Constants from "Constants";

import { State } from "./State";

export default handleActions({
  [Constants.DREAMERS_LIST.INIT_WIDGET]: (state: State, action) => {
    return state.handleInitWidget(action.payload);
  },
  [Constants.DREAMERS_LIST.LOAD_DREAMERS_START]: (state: State, action) => {
    return state.set('isLoadStarted', true);
  },
  [Constants.DREAMERS_LIST.LOAD_DREAMERS_FAILED]: (state: State, action) => {
    return state.set('isLoadStarted', false);
  },
  [Constants.DREAMERS_LIST.LOAD_DREAMERS_SUCCESS]: (state, action) => {
    return state.handleLoadDreamersSuccess(action.payload);
  },
  [Constants.DREAMERS_LIST.LOAD_NEXT_DREAMERS_SUCCESS]: (state: State, action) => {
    return state.handleLoadNextDreamersSuccess(action.payload);
  },
  [Constants.DREAMERS_LIST.ADD_FRIEND_CLICK]: (state: State, action) => {
    return state.handleAddFriendClick(action.payload);
  },
  [Constants.DREAMERS_LIST.REMOVE_FRIEND_CLICK]: (state: State, action) => {
    return state.handleRemoveFriendClick(action.payload);
  },
  [Constants.DREAMERS_LIST.APPROVE_FRIEND_CLICK]: (state: State, action) => {
    return state.handleApproveFriendClick(action.payload);
  },
  [Constants.DREAMERS_LIST.REJECT_FRIEND_CLICK]: (state: State, action) => {
    return state.handleRejectFriendClick(action.payload);
  },
}, new State());



