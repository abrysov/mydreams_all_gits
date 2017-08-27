import React from 'react';
import cx from "classnames";

export default class StatusField extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      text: props.text ? props.text : "Введите статус...",
      isEditable: false
    };
  }

  componentWillReceiveProps(newProps) {
    if (newProps.text && newProps.text != this.state.text) {
      this.setState({ text: newProps.text });
    }
  }

  render() {
    const {
      text,
      isEditable
    } = this.state;

    if (isEditable) {
      return (
        <input type="text" defaultValue={text} onKeyDown={this.onKeyDown.bind(this)} onBlur={this.onBlur.bind(this)} />
      );
    } else {
      return (
        <span onClick={this.onTextClick.bind(this)}>{text}</span>
      );
    }
  }

  onTextClick() {
    if (this.props.isCurrentUser) {
      this.setState({ isEditable: true });
    }
  }

  onKeyDown(e) {
    const { onEnter } = this.props;
    if (e.keyCode == 13 && !e.ctrlKey) {
      e.preventDefault();
      this.handleNewText(e.tagret.value);
    }
  }

  onBlur(e) {
    this.handleNewText(e.target.value);
  }

  handleNewText(text) {
    if (text != this.state.text) {
      this.props.onEnter(text);
      this.setState({ text, isEditable: false });
    }
  }
}
