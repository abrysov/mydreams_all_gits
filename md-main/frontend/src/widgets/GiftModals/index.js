import Routes from "routes";
import React from "react";
import ReactDOM from "react-dom";
import { Provider } from "react-redux";

import Root from "./components/Root";

import {
} from "./Actions";

export default {
  init(selector) {
    const { store, history } = require("AppStore");

    return ReactDOM.render(
      <Provider store={store}>
        <Root />
      </Provider>,
      document.querySelector(selector)
    );
  }
};
