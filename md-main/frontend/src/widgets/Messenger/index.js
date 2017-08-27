import Routes from "routes";
import React from "react";
import ReactDOM from "react-dom";
import { Provider } from 'react-redux';

import Root from './components/Root';

import messengerWs from "lib/messengerWs";

import {
  handleLoadMessagesList,
  handleNewMessage
} from "./Actions";

export default {
  init(selector) {
    const { store, history } = require("AppStore");

    messengerWs.on('im.list', (data) => {
      return store.dispatch(handleLoadMessagesList(data.payload));
    });

    messengerWs.on('im.message', (data) => {
      return store.dispatch(handleNewMessage(data.payload));
    });

    ReactDOM.render(
      <Provider store={store}>
        <Root />
      </Provider>,
      document.querySelector(selector)
    );

    resizeMessengerModal();
    window.addEventListener('resize', resizeMessengerModal);
    document.querySelector('.photo-feed-toggler').addEventListener('click', resizeMessengerModal);
  }
};

function resizeMessengerModal() {
  var m = document.querySelector('.messages-modal');
  if (m) {
    var page = document.querySelector('.row-page');
    var colWidth = document.querySelector('.col-right').clientWidth;
    var headerHeight = document.querySelector('.header-group').clientHeight;
    m.style.width = document.querySelector('.content-body').clientWidth + colWidth + 'px';
    m.style.left = page.offsetLeft + colWidth + 'px';
    m.style.top = headerHeight + 'px';
    m.style.height = window.innerHeight - headerHeight + 'px'
  }
}
