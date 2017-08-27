import { combineReducers } from 'redux';

import profile from "./Profile";
import account from "./Account";

export default combineReducers({
  profile,
  account
});