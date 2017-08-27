import Immutable from "immutable";
import { handleActions } from "redux-actions";
import Constants from "Constants";
import cacheService from "../../lib/cacheService";

const initialState = {
  user: Immutable.fromJS({
    id: cacheService.getOrDefault('current_user_id', -1),
    'avatar/small': cacheService.getOrDefault('current_user_avatar/small', ""),
    'coins_count': cacheService.getOrDefault('coins_count', 0)
  })
};

export class State extends Immutable.Record(initialState) {
  getCached(key) {
    const data = this.user.get(key);

    const cacheKey = `current_user_${key}`;
    cacheService.set(cacheKey, data);
    return data;
  }

  getId() {
    return this.user.get('id');
  }
}

export default handleActions({
  [Constants.USER.LOAD_USER_SUCCESS]: (state, action) => {
    const user = action.payload.dreamer;
    return state.update('user', (u) => {
      return u.set('id', user.id)
              .set('avatar/small', user.avatar.small)
              .set('coins_count', user.coins_count);
    });
  }
}, new State());

