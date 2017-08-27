import Routes from 'routes';
import { requestJson, getJson }  from 'lib/ajax';
import { createAction } from 'redux-actions';

import Constants from 'Constants';

export const showPhoto = createAction(Constants.PHOTO_VIEWER.SHOW_PHOTO);
export const initWithParams = createAction(Constants.POSTS_FEED.INIT_WITH_PARAMS);

const _loadPostsStart = createAction(Constants.POSTS_FEED.LOAD_POSTS_START);
const _loadPostsSuccess = createAction(Constants.POSTS_FEED.LOAD_POSTS_SUCCESS);
const _loadNextPostsSuccess = createAction(Constants.POSTS_FEED.LOAD_NEXT_POSTS_SUCCESS);
const _loadPostsFailed = createAction(Constants.POSTS_FEED.LOAD_POSTS_FAILED);

const _createPostStart = createAction(Constants.POSTS_FEED.CREATE_POST_START);
const _createPostSuccess = createAction(Constants.POSTS_FEED.CREATE_POST_SUCCESS);
const _createPostFailed = createAction(Constants.POSTS_FEED.CREATE_POST_FAILED);

export function loadPosts() {
  return (dispatch, getState) => {
    const postsFeedState = getState().postsFeed;
    const url = postsFeedState.getDataUrl();

    if (postsFeedState.isPostsListLoadStarted) { return; }

    dispatch(_loadPostsStart());

    getJson(url)
    .then(
      (r) => dispatch(_loadPostsSuccess(r)),
        (xhr, status, error) => dispatch(_loadPostsFailed())
    );
  }
}

export function loadNextPosts() {
  return (dispatch, getState) => {
    const postsFeedState = getState().postsFeed;
    const currentPage = postsFeedState.currentPage;
    const url = postsFeedState.getDataUrl({ page: currentPage + 1 });

    if (postsFeedState.isPostsListLoadStarted) { return; }

    dispatch(_loadPostsStart());

    getJson(url)
    .then(
      (r) => dispatch(_loadNextPostsSuccess(r)),
      (xhr, status, error) => dispatch(_loadPostsFailed())
    );
  }
}

export function createPost(data) {
  return (dispatch, getState) => {
    const url = Routes.api_web_posts_path();

    dispatch(_createPostStart());

    requestJson(url, 'POST', data)
      .then((r) => r.json())
      .then(
        (r) => dispatch(_createPostSuccess(r)),
        () => dispatch(_createPostFailed())
      );
  }
}

const _beginEditPost = createAction(Constants.POSTS_FEED.EDIT_POST_BEGIN);
const _cancelEditPost = createAction(Constants.POSTS_FEED.EDIT_POST_CANCEL);

const _updatePostStart = createAction(Constants.POSTS_FEED.UPDATE_POST_START);
const _updatePostFailed = createAction(Constants.POSTS_FEED.UPDATE_POST_FAILED);
const _updatePostSuccess = createAction(Constants.POSTS_FEED.UPDATE_POST_SUCCESS);

export function beginEditPost(postId) {
  return (dispatch, getState) => {
    dispatch(_beginEditPost({ postId }));
  };
}

export function updatePost(postId, data) {
  return (dispatch, getState) => {
    const url = Routes.api_web_post_path(postId);

    dispatch(_updatePostStart());

    requestJson(url, 'PUT', data)
      .then((r) => r.json())
      .then(
        (r) => dispatch(_updatePostSuccess(r)),
        () => dispatch(_updatePostFailed({ postId }))
      );
  };
}
