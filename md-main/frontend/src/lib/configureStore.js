import { createStore, applyMiddleware } from "redux";
import thunk from "redux-thunk";
import createLogger from "redux-logger";
import promise from "redux-promise";

import _ from "lodash";



export default function configureStore(reducer, middlewares = [], initialState = {}) {
  const basicMiddlewares = [
    thunk,
    promise
  ];

  const stateTransformer = (state) => {
    return _.mapValues(state, (v, k) => v.__root ? v.toJS() : v);
  };

  // if (process.env.NODE_ENV === 'development') {
    basicMiddlewares.push(createLogger({ stateTransformer }));
  // }

  const finalMiddlewares = basicMiddlewares.concat(middlewares);

  const createStoreWithMiddleware = applyMiddleware(...finalMiddlewares)(createStore);

  const store = createStoreWithMiddleware(reducer, initialState);
  return store;
}

