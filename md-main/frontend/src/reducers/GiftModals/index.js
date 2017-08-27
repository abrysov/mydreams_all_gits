import Immutable from "immutable";
import { handleActions } from "redux-actions";
import Constants from "Constants";

import { State } from "./State";

export default handleActions({
  [Constants.GIFT_MODALS.BUY_MARKS]: (state, action) => state.handleBuyMarks(action.payload),
  [Constants.GIFT_MODALS.PRESENT_MARKS]: (state, action) => state.handlePresentMarks(action.payload),
  [Constants.GIFT_MODALS.BUY_GIFTS]: (state, action) => state.handleBuyGifts(action.payload),
  [Constants.GIFT_MODALS.PRESENT_GIFTS]: (state, action) => state.handlePresentGifts(action.payload),
  [Constants.GIFT_MODALS.CLOSE]: (state, action) => state.handleClose(),
}, new State());

