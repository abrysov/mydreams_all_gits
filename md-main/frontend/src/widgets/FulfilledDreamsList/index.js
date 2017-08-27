import Routes from "routes";
import React from "react";
import ReactDOM from "react-dom";
import { Provider } from "react-redux";
import { Router, Route } from "react-router";

import SortBy from "lib/components/SortBy";
import UserCard from "lib/components/UserCard";

import Root from "./components/Root";
import Filter from "./components/Filter";
import CreateDream from "./components/CreateDream";

import {
  buildRouterDreamsUrl
} from "lib/routerUrlBuilders";

export default {
  init(selectors, params) {
    const { store, history } = require("AppStore");

    const state = store.getState();

    const currentUserId = state.user.getCached('id');
    const widgetUserId = params.userId || -1;

    ReactDOM.render(
      <Provider store={store}>
        <Router history={history}>
          <Route path={window.location.pathname}
                 component={Root}
                 widgetType={params.type}
                 userId={widgetUserId} />
        </Router>
      </Provider>,
      document.querySelector(selectors.dreamsList)
    );

    if (params.type === 'all_dreamers') {

      ReactDOM.render(
        <Provider store={store}>
          <Router history={history}>
            <Route path={window.location.pathname} component={Filter}/>
          </Router>
        </Provider>,
        document.querySelector(selectors.dreamsFilter)
      );

    } else {

      ReactDOM.render(
        <Provider store={store}>
          <Router history={history}>
            <Route path={window.location.pathname}
                   component={SortBy}
                   urlBuildingMethod={buildRouterDreamsUrl}
                   optionsMap={{
                    'new': 'По дате',
                    'liked': 'По статусу'
                   }} />
          </Router>
        </Provider>,
        document.querySelector(selectors.dreamsSortBy)
      );

      if (currentUserId === widgetUserId) {
        ReactDOM.render(
          <Provider store={store}>
            <CreateDream />
          </Provider>,
          document.querySelector(selectors.dreamsCreateFulfilledDream)
        );

      }
    }
  }
};
