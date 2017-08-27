import Routes from 'routes';
import { getJson, requestJson }  from 'lib/ajax';
import { createAction } from 'redux-actions';
import Constants from 'Constants';


export const _loadDreamerInfoSuccess = createAction(Constants.DREAMER_INFO.LOAD_DREAMER_INFO_SUCCESS);
export const _loadDreamerInfoFailed = createAction(Constants.DREAMER_INFO.LOAD_DREAMER_INFO_FAILED);

export const loadDreamerInfo = (id) => (dispatch, getState) => {
  getJson(Routes.api_web_dreamer_path({ id }))
    .then(r => dispatch(_loadDreamerInfoSuccess(r)));
}

const _handleSendMessageClick = createAction(Constants.DREAMER_INFO.SEND_MESSAGE_CLICK);
export const handleSendMessageClick = () => (dispatch, getState) => {
  const id = getState().dreamerInfo.dreamer.get('id');
  const conversationInfoUrl = Routes.api_web_profile_conversations_path();

  requestJson(conversationInfoUrl, 'POST', { id })
  .then((r) => r.json())
  .then((r) => dispatch(_handleSendMessageClick(r.conversation)));
}

const _handleAddFriendClick = createAction(Constants.DREAMER_INFO.ADD_FRIEND_CLICK);
export const handleAddFriendClick = (dreamerId) => (dispatch, getState) => {
  const url = Routes.api_web_profile_friendship_requests_path();
  requestJson(url, 'POST', { id: dreamerId })
  .then((r) => r.json())
  .then((r) => dispatch(_handleAddFriendClick(dreamerId)));
}

const _handleRemoveFriendClick = createAction(Constants.DREAMER_INFO.REMOVE_FRIEND_CLICK);
export const handleRemoveFriendClick = (dreamerId) => (dispatch, getState) => {
  const url = Routes.api_web_profile_friendship_request_path(dreamerId);
  requestJson(url, 'DELETE')
  .then((r) => r.json())
  .then((r) => dispatch(_handleRemoveFriendClick(dreamerId)));
}

const _handleUpdateStatus = createAction(Constants.DREAMER_INFO.UPDATE_STATUS);
export const handleUpdateStatus = (status) => (dispatch, getState) => {
  const url = Routes.api_web_profile_path();
  requestJson(url, 'PATCH', { status })
  .then((r) => r.json())
  .then((r) => dispatch(_handleUpdateStatus(status)));
}

export const handleBuyGift = () => (dispatch, getState) => {
  const dreamer = getState().dreamerInfo.dreamer.toJS();
  dispatch(createAction(Constants.GIFT_MODALS.BUY_GIFTS)(dreamer));
}

export const handlePresentGift = () => (dispatch, getState) => {
  const dreamer = getState().dreamerInfo.dreamer.toJS();

  dispatch(createAction(Constants.GIFT_MODALS.PRESENT_GIFTS)(dreamer));
}
