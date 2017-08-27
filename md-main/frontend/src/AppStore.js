import { combineReducers } from 'redux';
import { browserHistory } from 'react-router';
import { syncHistoryWithStore, routerReducer, routerMiddleware } from 'react-router-redux';

import configureStore from 'lib/configureStore';

import reducers from "./reducers";


const reducer = combineReducers({
  ...reducers,
  routing: routerReducer
});

export const store = configureStore(reducer, [routerMiddleware(browserHistory)]);
export const history = syncHistoryWithStore(browserHistory, store);

