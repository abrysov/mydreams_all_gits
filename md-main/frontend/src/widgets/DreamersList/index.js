import Routes from "routes";
import React from "react";
import ReactDOM from "react-dom";
import { Provider } from 'react-redux';
import { Router, Route } from 'react-router';

import Root from './components/Root';
import Filter from './components/Filter';

import {
  initWidget
} from "./Actions";

export default {
  init(listSelector, filterSelector, params) {
    const {
      // all_dreamers        - /dreamers
      // dreambook_friends   - /d1/friends
      // dreambook_followers - /d1/followers
      // dreambook_followees  - /d1/followees
      // dreambook_friendships  - /d1/friendships
      type
    } = params;

    const { store, history } = require("AppStore");

    store.dispatch(initWidget(params));

    ReactDOM.render(
      <Provider store={store}>
        <Router history={history}>
          <Route path={window.location.pathname} component={Root} />
        </Router>
      </Provider>,
      document.querySelector(listSelector)
    );

    ReactDOM.render(
      <Provider store={store}>
        <Router history={history}>
          <Route path={window.location.pathname} component={Filter} />
        </Router>
      </Provider>,
      document.querySelector(filterSelector)
    );
  }
};

