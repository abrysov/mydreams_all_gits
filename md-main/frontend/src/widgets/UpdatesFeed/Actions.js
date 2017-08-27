import Routes from 'routes';
import { requestJson, getJson }  from 'lib/ajax';
import { createAction } from 'redux-actions';

import Constants from 'Constants';

const _loadUpdatesStart = createAction(Constants.UPDATES_FEED.LOAD_UPDATES_START);
const _loadUpdatesSuccess = createAction(Constants.UPDATES_FEED.LOAD_UPDATES_SUCCESS);
const _loadNextUpdatesSuccess = createAction(Constants.UPDATES_FEED.LOAD_NEXT_UPDATES_SUCCESS);
const _loadUpdatesFailed = createAction(Constants.UPDATES_FEED.LOAD_UPDATES_FAILED);

export function loadUpdates() {
  return (dispatch, getState) => {
    const updatesFeedState = getState().updatesFeed;
    const url = Routes.api_web_feed_updates_path({ page: 1 });

    if (updatesFeedState.isLoadStarted) { return; }

    dispatch(_loadUpdatesStart());

    getJson(url)
    .then(
      (r) => dispatch(_loadUpdatesSuccess(r)),
        (xhr, status, error) => dispatch(_loadUpdatesFailed())
    );
  }
}

export function loadNextUpdates() {
  return (dispatch, getState) => {
    const updatesFeedState = getState().updatesFeed;
    const url = Routes.api_web_feed_updates_path({ page: updatesFeedState.currentPage + 1 });

    if (updatesFeedState.isLoadStarted) { return; }

    dispatch(_loadUpdatesStart());

    getJson(url)
    .then(
      (r) => dispatch(_loadNextUpdatesSuccess(r)),
      (xhr, status, error) => dispatch(_loadUpdatesFailed())
    );
  }
}
