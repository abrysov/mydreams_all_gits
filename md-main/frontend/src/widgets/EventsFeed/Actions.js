import Routes from 'routes';
import { requestJson, getJson }  from 'lib/ajax';
import { createAction } from 'redux-actions';

import Constants from 'Constants';

const _loadEventsStart = createAction(Constants.EVENTS_FEED.LOAD_EVENTS_START);
const _loadEventsSuccess = createAction(Constants.EVENTS_FEED.LOAD_EVENTS_SUCCESS);
const _loadNextEventsSuccess = createAction(Constants.EVENTS_FEED.LOAD_NEXT_EVENTS_SUCCESS);
const _loadEventsFailed = createAction(Constants.EVENTS_FEED.LOAD_EVENTS_FAILED);

export function loadEvents() {
  return (dispatch, getState) => {
    const eventsFeedState = getState().eventsFeed;
    const url = Routes.api_web_feedbacks_path({ page: 1 });

    if (eventsFeedState.isLoadStarted) { return; }

    dispatch(_loadEventsStart());

    getJson(url)
      .then(
        (r) => dispatch(_loadEventsSuccess(r)),
        (xhr, status, error) => dispatch(_loadEventsFailed())
      );
  }
}

export function loadNextEvents() {
  return (dispatch, getState) => {
    const eventsFeedState = getState().eventsFeed;
    const url = Routes.api_web_feedbacks_path({ page: eventsFeedState.currentPage + 1 });

    if (eventsFeedState.isLoadStarted) { return; }

    dispatch(_loadEventsStart());

    getJson(url)
      .then(
        (r) => dispatch(_loadNextEventsSuccess(r)),
        (xhr, status, error) => dispatch(_loadEventsFailed())
      );
  }
}
