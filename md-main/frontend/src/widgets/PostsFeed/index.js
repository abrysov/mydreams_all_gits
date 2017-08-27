import Routes from "routes";
import React from "react";
import ReactDOM from "react-dom";
import { Provider } from 'react-redux';
import { Router, Route } from 'react-router';

import Root from './components/Root';

import {
  initWithParams
} from "./Actions";

export default {
  init(selector, params) {
    const { store, history } = require("AppStore");

    store.dispatch(initWithParams(params));

    ReactDOM.render(
      <Provider store={store}>
        <Router history={history}>
          <Route path={window.location.pathname} component={Root} />
        </Router>
      </Provider>,
      document.querySelector(selector)
    );
  }
};
