import React from "react";
import ReactDOM from "react-dom";
import { Provider } from "react-redux";
import { Router, Route } from "react-router";

import AccountSettings from "./components/AccountSettings";
import ProfileSettings from "./components/ProfileSettings";

export default {
  init(settingsSelector, params) {
    const { store, history } = require("AppStore");

    if (params.type === 'account') {

      ReactDOM.render(
        <Provider store={store}>
          <Router history={history}>
            <Route path={window.location.pathname}
                   component={AccountSettings} />
          </Router>
        </Provider>,
        document.querySelector(settingsSelector)
      );

    } else if (params.type === 'profile') {

      ReactDOM.render(
        <Provider store={store}>
          <Router history={history}>
            <Route path={window.location.pathname}
                   component={ProfileSettings} />
          </Router>
        </Provider>,
        document.querySelector(settingsSelector)
      );

    }
  }
}