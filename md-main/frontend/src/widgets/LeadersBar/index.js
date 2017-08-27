import React from "react";
import ReactDOM from "react-dom";
import { Provider } from 'react-redux';

import Root from './components/Root';
import AddPopup from './components/AddPopup';

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

  initModal(selector) {
    const { store } = require("AppStore");

    ReactDOM.render(
      <Provider store={store}>
        <AddPopup />
      </Provider>,
      document.querySelector(selector)
    );
  }
};


