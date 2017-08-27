import React from 'react';
import ReactDOM from 'react-dom';

export default class ContentEditable extends React.Component {
  constructor(props) {
    super(props);
    this.state = {};
  }

  render() {
    const {
      element = 'div',
        children,
        className
    } = this.props;

    const reactEl = React.createFactory(element);

    return reactEl({
      onClick: this.onClick.bind(this),
      onInput: this.emitChange.bind(this),
      onBlur: this.emitChange.bind(this),
      contentEditable: true,
      className,
      children
    });
  }

  shouldComponentUpdate(nextProps) {
    return nextProps.children !== ReactDOM.findDOMNode(this).innerText;
  }

  emitChange() {
    var html = ReactDOM.findDOMNode(this).innerText;
    if (html === '') {
      html = this.state.defaultValue;
      ReactDOM.findDOMNode(this).innerText = html;
    } else if (this.props.onChange && html !== this.lastHtml) {
      this.props.onChange({
        target: { value: html }
      });
    }
    this.lastHtml = html;
  }

  onClick() {
    if (this.props.eraseOnClick) {
      this.eraseDefaultContent();
    }
  }

  eraseDefaultContent() {
    const currentValue = ReactDOM.findDOMNode(this).innerText;
    if (!this.state.defaultValue) {
      this.setState({ defaultValue: currentValue });
      ReactDOM.findDOMNode(this).innerText = '';
    } else if (this.state.defaultValue === currentValue) {
      ReactDOM.findDOMNode(this).innerText = '';
    }
  }

  getValue() {
    ReactDOM.findDOMNode(this).innerText;
  }
}
