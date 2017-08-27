import _ from "lodash";
import $ from "jquery";
import messagesApi from './messengerWs/messages';
import commentsApi from './messengerWs/comments';

const options = {'disableEventSource': true, 'disableXHRPolling': true};
const userUrl = (userToken) => gon.messenger_ws_url;

const messengerBase = {
  _handlers: {
    open: [],
    close: [],
    message: [],
    heartbeat: []
  },

  on(type, handler) {
    this[type].push(handler);
  },

  off(type, handler = null) {
    if (handler) {
      _.remove(this._handlers[type], handler);
    } else {
      this._handlers[type] = [];
    }
  },

  connect(token) {
    const url = userUrl(token);
    this.bullet = $.bullet(url, options);

    this._handlers.heartbeat.push(() => {
      console.log('ping');
      this.send({ type: 'ping' });
    });

    Object.keys(this._handlers).forEach((key) => {
      this.bullet[`on${key}`] = (e) => { this._handlers[key].forEach((h) => h(e)); }
    });

    this._handlers.message.push((e) => {
      const data = JSON.parse(e.data);

      console.log("messengerWs.onMessage", data);

      if (data.type != 'pong') {
        this[`${data.type}.${data.command}`].map((h) => h(data, e));
      }
    });

    this.bullet.ondisconnect = this.bullet.onclose;
  },

  disconnect() {
    this.bullet.close();
    this.bullet = null;
  },

  send(hash) {
    console.log("messengerWs.send", hash);
    this.bullet.send(JSON.stringify(hash));
  }
};

export default Object.assign({}, messengerBase, messagesApi, commentsApi);
