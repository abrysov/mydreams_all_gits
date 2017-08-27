import Routes from "routes";
import React from "react";
import ReactDOM from "react-dom";
import { Provider } from 'react-redux';

import {
  showModal
} from "./Actions";

import Root from './components/Root';

export default {
  init(selector) {
    const { store } = require("AppStore");

    ReactDOM.render(
      <Provider store={store}>
        <Root />
      </Provider>,
      document.querySelector(selector)
    );
  },

  open(entityType, entityId) {
    const { store } = require("AppStore");
    store.dispatch(showModal(entityType, entityId));
  }
};



