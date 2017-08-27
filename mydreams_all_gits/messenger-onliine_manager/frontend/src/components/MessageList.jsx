import React from 'react';
import Message from './Message';

class MessageList extends React.Component {
  render() {
    var messageNodes = this.props.data.map(message => {
      return (
        <Message from={message.from} key={message.id}>
          {message.text}
        </Message>
      );
    });
    return (
      <div className="messageList">
        {messageNodes}
      </div>
    )
  }
}

export default MessageList;
