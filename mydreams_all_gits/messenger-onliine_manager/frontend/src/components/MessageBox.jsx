import React from 'react';
import MessageList from './MessageList';
import MessageForm from './MessageForm';
import {dispatch} from '../flux-infra/MessengerDispatcher';

class MessageBox extends React.Component {
  constructor(props, context) {
    super(props, context);
    this.handleMessageSubmit = this.handleMessageSubmit.bind(this);
  }

  handleMessageSubmit(message) {
    dispatch({type: 'send_message', message})
  }

  render() {
    return (
      <div className="MessageBox">
        <h1>Messages</h1>
        <MessageForm onMessageSubmit={this.handleMessageSubmit} />
        <MessageList data={this.props.data} />
      </div>
    )
  }
}

export default MessageBox;
