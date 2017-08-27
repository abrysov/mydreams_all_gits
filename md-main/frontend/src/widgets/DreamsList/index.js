import Routes from "routes";
import React from "react";
import ReactDOM from "react-dom";
import { Provider } from 'react-redux';
import { Router, Route } from 'react-router';

import SortBy from "lib/components/SortBy";

import Root from './components/Root';
import Filter from './components/Filter';

import {
  buildRouterDreamsUrl
} from "lib/routerUrlBuilders";

export default {
  init(listSelector, filterSelector, params) {
    const { store, history } = require("AppStore");

    params = params || {};

    ReactDOM.render(
      <Provider store={store}>
        <Router history={history}>
          <Route path={window.location.pathname}
                 component={Root}
                 onlyMyDreams={params.onlyMyDreams}
                 userId={params.userId} />
        </Router>
      </Provider>,
      document.querySelector(listSelector)
    );

    if (params.onlyMyDreams) {

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
        document.querySelector(filterSelector)
      );

    } else {

      ReactDOM.render(
        <Provider store={store}>
          <Router history={history}>
            <Route path={window.location.pathname} component={Filter}/>
          </Router>
        </Provider>,
        document.querySelector(filterSelector)
      );

    }
  }
};
