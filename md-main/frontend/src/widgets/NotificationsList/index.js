import Routes from "routes";
import React from "react";
import ReactDOM from "react-dom";
import { Provider } from 'react-redux';

import messengerWs from "lib/messengerWs";

import {
  handleNewMessage
} from "./Actions";

import Root from './components/Root';

export default {
  init(selector) {
    const { store, history } = require("AppStore");

    messengerWs.on('im.message', (data) => {
      return store.dispatch(handleNewMessage(data.payload));
    });

    ReactDOM.render(
      <Provider store={store}>
        <Root />
      </Provider>,
      document.querySelector(selector)
    );
  }
};


