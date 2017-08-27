import Immutable from "immutable";
import { handleActions } from "redux-actions";
import Constants from "Constants";
import cacheService from "../../lib/cacheService";

const initialState = {
  leaders: Immutable.fromJS(cacheService.getOrDefault('leadersBar_leaders', [])),
  isModalOpened: false
};

export class State extends Immutable.Record(initialState) {
  getCached(key) {
    const data = this.get(key);

    const cacheKey = `leadersBar_${key}`;
    cacheService.set(cacheKey, data);
    return data;
  }
}

export default handleActions({
  [Constants.LEADERS_BAR.LOAD_LEADERS_SUCCESS]: (state, action) => {
    return state.set('leaders', Immutable.fromJS(action.payload.leaders));
  },
  [Constants.LEADERS_BAR.SHOW_ADD_MODAL]: (state, action) => {
    return state.set('isModalOpened', true);
  },
  [Constants.LEADERS_BAR.CLOSE_ADD_MODAL]: (state, action) => {
    return state.set('isModalOpened', false);
  },
  [Constants.LEADERS_BAR.ADD_PHOTO_SUCCESS]: (state, action) => {
    const leader = Immutable.fromJS(action.payload.dreamer_photobar);
    return state
      .set('leaders', state.leaders.unshift(leader))
      .set('isModalOpened', false);
  }
}, new State());
