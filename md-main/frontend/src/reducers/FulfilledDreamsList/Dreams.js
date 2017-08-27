import Immutable from "immutable";
import { handleActions } from "redux-actions";
import Constants from "Constants";

const initialState = {
  isLoadStarted: false,
  isLikeProcessing: false,
  dreams: [],
  currentPage: 1,
  sortBy: 'new'
};

export class State extends Immutable.Record(initialState) {}

export default handleActions({
  [Constants.FULFILLED_DREAMS_LIST.LOAD_DREAMS_START]: (state: State, action) => {
    return state.set('isLoadStarted', true);
  },
  [Constants.FULFILLED_DREAMS_LIST.LOAD_DREAMS_FAILED]: (state: State, action) => {
    return state.set('isLoadStarted', false);
  },

  [Constants.FULFILLED_DREAMS_LIST.LOAD_DREAMS_SUCCESS]: (state: State, action) => {
    const sortBy = action.payload.sortBy || state.get('sortBy');
    return state.set('dreams', Immutable.fromJS(action.payload.dreams))
                .set('currentPage', action.payload.meta.page)
                .set('sortBy', sortBy)
                .set('isLoadStarted', false);
  },

  [Constants.FULFILLED_DREAMS_LIST.LOAD_NEXT_DREAMS_SUCCESS]: (state: State, action) => {
    if (action.payload.dreams.length > 0) {
      const currentDreamsIds = state.dreams.map((d) => d.get('id'));

      const addDreams = Immutable.fromJS(action.payload.dreams)
                        .filter((d) => !currentDreamsIds.contains(d.get('id')));

      return state.update('dreams', (d) => d.concat(addDreams))
                  .set('currentPage', action.payload.meta.page)
                  .set('isLoadStarted', false);
    }

    return state.set('isLoadStarted', false);
  },

  [Constants.FULFILLED_DREAMS_LIST.LIKE_CLICK_START]: (state: State, action) => {
    return state.set('isLikeProcessing', true);
  },
  [Constants.FULFILLED_DREAMS_LIST.LIKE_CLICK_FAILED]: (state: State, action) => {
    return state.set('isLikeProcessing', false);
  },
  [Constants.FULFILLED_DREAMS_LIST.LIKE_CLICK_SUCCESS]: (state: State, action) => {
    const id = action.payload.dreamId;
    const index = state.dreams.findIndex((elem) => elem.get('id') === id);
    return state.setIn(['dreams', index, 'liked_by_me'], true)
      .setIn(['dreams', index, 'likes_count'], state.getIn(['dreams', index, 'likes_count']) + 1)
      .set('isLikeProcessing', false);
  },

  [Constants.FULFILLED_DREAMS_LIST.UNLIKE_CLICK_START]: (state: State, action) => {
    return state.set('isLikeProcessing', true);
  },
  [Constants.FULFILLED_DREAMS_LIST.UNLIKE_CLICK_FAILED]: (state: State, action) => {
    return state.set('isLikeProcessing', false);
  },
  [Constants.FULFILLED_DREAMS_LIST.UNLIKE_CLICK_SUCCESS]: (state: State, action) => {
    const id = action.payload.dreamId;
    const index = state.dreams.findIndex((elem) => elem.get('id') === id);
    return state.setIn(['dreams', index, 'liked_by_me'], false)
      .setIn(['dreams', index, 'likes_count'], state.getIn(['dreams', index, 'likes_count']) - 1)
      .set('isLikeProcessing', false);
  },

  [Constants.FULFILLED_DREAMS_LIST.HANDLE_ADD_DREAM_SUCCESS]: (state: State, action) => {
    const dream = Immutable.Map(action.payload.dream);
    return state.set('dreams', state.dreams.unshift(dream));
  }
}, new State());
