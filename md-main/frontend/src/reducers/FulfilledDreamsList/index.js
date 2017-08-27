import { combineReducers } from 'redux';

import createDream from "./CreateDream";
import dreams from "./Dreams";

export default combineReducers({
  createDream,
  dreams
});

