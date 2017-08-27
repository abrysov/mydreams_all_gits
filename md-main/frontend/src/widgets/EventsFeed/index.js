// WARNING : though the widget is named EventsFeed, the API method for it is `Routes.api_web_feedbacks_path`.

import Routes from "routes";
import React from "react";
import ReactDOM from "react-dom";
import { Provider } from 'react-redux';
import { Router, Route } from 'react-router';

import Root from './components/Root';

export default {
  init(selector, params) {
    const { store, history } = require("AppStore");

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

