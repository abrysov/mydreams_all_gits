import React from "react";
import ReactDOM from "react-dom";
import { Provider } from "react-redux";

import Root from "./components/Root";

export default {
  init(selector, params) {
    const { store, history } = require("AppStore");

    ReactDOM.render(
      <Provider store={store}>
        <Root />
      </Provider>,
      document.querySelector(selector)
    );
  }
}
