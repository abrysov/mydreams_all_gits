import React from "react";
import ReactDOM from "react-dom";
import { Provider } from "react-redux";
import { Router, Route } from "react-router";

import Root from "./components/Root";
import UploadPhotos from "./components/UploadPhotos";

import UserCard from "lib/components/UserCard";

export default {
  init(listSelector, sideboardSelector, params) {
    const { store, history } = require("AppStore");

    const state = store.getState();
    const currentUserId = state.user.getCached('id');
    const widgetUserId = params.userId;

    ReactDOM.render(
      <Provider store={store}>
        <Router history={history}>
          <Route path={window.location.pathname}
                 component={Root}
                 userId={widgetUserId} />
        </Router>
      </Provider>,
      document.querySelector(listSelector)
    );

    if (currentUserId === widgetUserId) {

      ReactDOM.render(
        <Provider store={store}>
          <Router history={history}>
            <Route path={window.location.pathname}
                   component={UploadPhotos} />
          </Router>
        </Provider>,
        document.querySelector(sideboardSelector)
      );
    }
  }
}
