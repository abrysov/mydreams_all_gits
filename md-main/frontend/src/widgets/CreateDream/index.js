import Routes from "routes";
import React from "react";
import ReactDOM from "react-dom";
import { Provider } from "react-redux";

import Root from "./components/Root";

import {
  handleMenuBtnClick
} from "./Actions";

export default {
  init(selector) {
    const { store, history } = require("AppStore");

    document.querySelector('#believe-in-dream-menu-btn').addEventListener('click', (e) => {
      resizeModal();
      document.body.classList.add('scroll-disabled');

      store.dispatch(handleMenuBtnClick());
    });

    ReactDOM.render(
      <Provider store={store}>
        <Root />
      </Provider>,
      document.querySelector(selector)
    );

    resizeModal();
    window.addEventListener('resize', resizeModal);
  }
};

function resizeModal() {
  var m = document.querySelector('.belive-in-dream-modal');
  var page = document.querySelector('.row-page');
  var colWidth = document.querySelector('.col-right').clientWidth;
  var headerHeight = document.querySelector('.header-group').clientHeight;
  m.style.width = document.querySelector('.content-body').clientWidth + colWidth + 'px';
  m.style.left = page.offsetLeft + colWidth + 'px';
  m.style.top = headerHeight + 'px';
  m.style.height = window.innerHeight - headerHeight + 'px';
}
