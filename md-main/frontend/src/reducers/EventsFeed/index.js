// WARNING : though the widget is named EventsFeed, the API method for it is `Routes.api_web_feedbacks_path`.

import Immutable from "immutable";
import { handleActions } from "redux-actions";
import Constants from "Constants";

import { State } from "./State";

export default handleActions({
  [Constants.EVENTS_FEED.LOAD_EVENTS_START]: (state, action) => {
    return state.set('isLoadStarted', true);
  },
  [Constants.EVENTS_FEED.LOAD_EVENTS_FAILED]: (state, action) => {
    return state.set('isLoadStarted', false);
  },

  [Constants.EVENTS_FEED.LOAD_EVENTS_SUCCESS]: (state, action) => {
    return state.handleLoadEventsSuccess(action.payload);
  },

  [Constants.EVENTS_FEED.LOAD_NEXT_EVENTS_SUCCESS]: (state, action) => {
    return state.handleLoadNextEventsSuccess(action.payload);
  }
}, new State());

