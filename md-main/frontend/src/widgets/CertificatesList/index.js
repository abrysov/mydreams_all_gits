import React from "react";
import ReactDOM from "react-dom";
import { Provider } from "react-redux";
import { Router, Route } from "react-router";

import SortBy from "lib/components/SortBy";

import Root from "./components/Root";
import Filter from "./components/Filter";

import {
  buildRouterCertificatesUrl
} from "lib/routerUrlBuilders";

export default {
  init(listSelector, sortBySelector, filterSelector, params) {
    const { store, history } = require("AppStore");
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

    // ReactDOM.render(
    //   <Provider store={store}>
    //     <Router history={history}>
    //       <Route path={window.location.pathname}
    //              component={SortBy}
    //              urlBuildingMethod={buildRouterCertificatesUrl}
    //              optionsMap={{
    //                 'liked': 'По статусу',
    //                 'new': 'По дате'
    //              }} />
    //     </Router>
    //   </Provider>,
    //   document.querySelector(sortBySelector)
    // );

    ReactDOM.render(
      <Provider store={store}>
        <Router history={history}>
          <Route path={window.location.pathname} component={Filter} />
        </Router>
      </Provider>,
      document.querySelector(filterSelector)
    );
  }
}