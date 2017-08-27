import Immutable from "immutable";
import { handleActions } from "redux-actions";
import Constants from "Constants";

import { State } from "./State";

export default handleActions({
  [Constants.POSTS_FEED.INIT_WITH_PARAMS]: (state, action) => {
    return state.setParams(action.payload);
  },

  [Constants.POSTS_FEED.LOAD_POSTS_START]: (state, action) => {
    return state.set('isPostsListLoadStarted', true);
  },
  [Constants.POSTS_FEED.LOAD_POSTS_FAILED]: (state, action) => {
    return state.set('isPostsListLoadStarted', false);
  },

  [Constants.POSTS_FEED.LOAD_POSTS_SUCCESS]: (state, action) => {
    return state.handleLoadPostsSuccess(action.payload);
  },

  [Constants.POSTS_FEED.LOAD_NEXT_POSTS_SUCCESS]: (state, action) => {
    return state.handleLoadNextPostsSuccess(action.payload);
  },

  [Constants.POSTS_FEED.CREATE_POST_SUCCESS]: (state, action) => {
    return state.handleCreatePostSuccess(action.payload);
  },

  [Constants.POSTS_FEED.EDIT_POST_BEGIN]: (state, action) => {
    return state.handleEditPostBegin(action.payload.postId);
  },

  [Constants.POSTS_FEED.UPDATE_POST_SUCCESS]: (state, action) => {
    return state.handleUpdatePostSuccess(action.payload.post);
  },

  [Constants.POSTS_FEED.UPDATE_POST_FAILED]: (state, action) => {
    return state.handleUpdatePostFailed(action.payload.postId);
  }
}, new State());
