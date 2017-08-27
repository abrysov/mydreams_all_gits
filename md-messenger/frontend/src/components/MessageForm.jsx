import React from 'react';

class MessageForm extends React.Component {
  constructor(props, context) {
    super(props, context);

    this.handleTextChange = this.handleTextChange.bind(this);
    this.handleSubmit     = this.handleSubmit.bind(this);

    this.state = {text: ''};
  }

  handleTextChange(e) {
    this.setState({text: e.target.value});
  }

  handleSubmit(e) {
    e.preventDefault();
    var text = this.state.text.trim();
    if (!text) {
      return;
    }
    var message = {text};
    this.props.onMessageSubmit(message);
    this.setState({text: ''});
  }

  render() {
    return (
      <form className="messageForm" onSubmit={this.handleSubmit}>
        <input
          type="text"
          placeholder="Say something..."
          value={this.state.text}
          onChange={this.handleTextChange}
        />
        <input type="submit" value="Send" />
      </form>
    )
  }
}

export default MessageForm;
