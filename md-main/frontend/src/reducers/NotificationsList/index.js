import Immutable from "immutable";
import { handleActions } from "redux-actions";
import Constants from "Constants";

import { State } from "./State";

export default handleActions({
  [Constants.NOTIFICATIONS_LIST.NEW_MESSAGE]: (state, action) => {
    return state.addNotification(action.payload);
  },

  [Constants.NOTIFICATIONS_LIST.CLOSE_NOTIFICATION]: (state, action) => {
    return state.removeNotification(action.payload);
  },

  [Constants.NOTIFICATIONS_LIST.NEW_MESSAGE_CLICK]: (state, action) => {
    return state.removeNotification(action.payload.id);
  }
}, new State());

