import React from "react";

export default class extends React.Component {
  send() {
    this.props.onSubmit(this.refs.text.value);
    this.refs.text.value = "";
  }

  onSubmit(e) {
    e.preventDefault();
    this.send();
  }

  onKeyDown(e) {
    if (e.keyCode == 13 && !e.ctrlKey) {
      e.preventDefault();
      this.send();
    }
  }

  render() {
    return (
      <div className="textarea-block">
        <form className="message-textarea" onSubmit={this.onSubmit.bind(this)}>
          <textarea placeholder="Написать сообщение..." rows="3" ref="text" onKeyDown={this.onKeyDown.bind(this)}></textarea>
          <div className="control-panel">
            <input className="accent blue" type="submit" value="Отправить" />
          </div>
        </form>
      </div>
    );
  }
}
