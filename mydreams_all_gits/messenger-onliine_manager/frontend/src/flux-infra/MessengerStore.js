import Immutable from 'immutable';
import {ReduceStore} from 'flux/utils';
import MessengerDispatcher from './MessengerDispatcher';

const options = {'disableEventSource': true, 'disableXHRPolling': true};
const conversationId = 1;

var userUrl = (userToken) => {
  return `ws://${window.location.host}/bullet?token=${userToken}`;
};

var connect = (state) => {
  var userToken = state.get('userToken');
  if(!userToken) {
    console.log(`Wrong token: [${userToken}]`);
    return state;
  }
  var url = userUrl(userToken);
  console.log(url, options);
  var bullet = $.bullet(url, options);

  bullet.onopen = () => {
    console.log('bullet.onopen');
    MessengerDispatcher.dispatch({type: 'bullet/open'});
  };

  bullet.onclose = () => {
    console.log('bullet.onclose');
    MessengerDispatcher.dispatch({type: 'bullet/close'});
  };

  bullet.ondisconnect = bullet.onclose;

  bullet.onmessage = (e) => {
    MessengerDispatcher.dispatch({type: 'bullet/message', data: e.data});
  };

  bullet.onheartbeat = () => {
    console.log('ping');
    bullet.send(JSON.stringify({type: 'ping'}));
  };

  return state.set('bullet', bullet);
};

var disconnect = (state) => {
  console.log('disconnect');
  var bullet = state.get('bullet');
  if (bullet) {
    bullet.close();
  }
  return state.set('bullet', null);
};


var changeUser = (state, userToken) => {
  return state.set('userToken', userToken);
}

var unshiftMessages = (state, newMessages) => {
  return state.updateIn(['messages'], messages => {
    return newMessages.concat(messages)
  })
};

var handleIncomingMessage = (state, data) => {
  console.log(data);
  var incomingMessage = JSON.parse(data);
  switch (incomingMessage.type) {

    case 'last_messages':
      return state.set('messages', incomingMessage.messages);

    case 'message':
      return unshiftMessages(state, [incomingMessage.message]);

    case 'user_status':
      console.log(`User#${incomingMessage.user_id} is ${incomingMessage.status}`);
      break;

    default:
      return state;

  }

  return state;
};

var requestLastMessages = (state) => {
  var bullet = state.get('bullet');
  var outgoingMessage = JSON.stringify({
      type: 'last_messages',
      conversation_id: conversationId
  });
  if(bullet) {
    bullet.send(outgoingMessage);
  }
};

var requestOnlineList = (state) => {
  var bullet = state.get('bullet');
  var outgoingMessage = JSON.stringify({
      type: 'online_list',
      conversation_id: conversationId
  });
  if(bullet) {
    bullet.send(outgoingMessage);
  }
}

var sendMessage = (state, message) => {
  var bullet = state.get('bullet');
  var outgoingMessage = JSON.stringify({
      type: 'message',
      text: message.text,
      conversation_id: conversationId
  });
  if(bullet) {
    bullet.send(outgoingMessage);
  }
  // message.id = Date.now();
  // message.from = 'Me';
  // return unshiftMessages(state, [message]);
  return state;
};

class MessengerStore extends ReduceStore {
  getInitialState() {
    return Immutable.Map({
      bullet: null,
      messages: [],
      userToken: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoxfQ.rpWgOBaCjeZW-34cmFQLmbJQ1gRbTyy-bycPYXc5Zts',
      connection_status: 'offline'
    });
  }

  connection_status() {
    return this.getState().get('connection_status');
  }

  messages() {
    return this.getState().get('messages');
  }

  userToken() {
    return this.getState().get('userToken');
  }

  reduce (state, action) {
    switch (action.type) {
      case 'connect':
        return connect(state);

      case 'disconnect':
        return disconnect(state);

      case 'change_user':
        return changeUser(state, action.userToken);

      case 'change_receiver':
        return changeReceiver(state, action.receiverId);

      case 'send_message':
        return sendMessage(state, action.message);

      case 'bullet/open':
        requestLastMessages(state);
        requestOnlineList(state);
        return state.set('connection_status', 'online');

      case 'bullet/close':
        return state.set('connection_status', 'offline');

      case 'bullet/message':
        return handleIncomingMessage(state, action.data)

      default:
        return state;
    }
  }
}

const instance = new MessengerStore(MessengerDispatcher);
export default instance;
