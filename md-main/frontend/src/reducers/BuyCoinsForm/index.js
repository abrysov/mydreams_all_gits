import Immutable from "immutable";
import { handleActions } from "redux-actions";
import Constants from "Constants";

import { State } from "./State";

export default handleActions({
  [Constants.BUY_COINS_FORM.HANDLE_FIELD_CHANGE]: (state, action) => {
    return state.handleFieldChange(action.payload.name, action.payload.value);
  },
  [Constants.BUY_COINS_FORM.LOAD_PRODUCTS_SUCCESS]: (state, action) => {
    return state.handleLoadProductsSuccess(action.payload);
  },
}, new State());

