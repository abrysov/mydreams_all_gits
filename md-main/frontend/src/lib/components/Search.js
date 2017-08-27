import React from "react";

export default class Search extends React.Component {
  onKeyPress(e) {
    if (e.key === 'Enter') {
      this.props.onEnter(this.refs.input.value);
    }
  }

  render() {
    const { value } = this.props;
    return (
      <div className="input circle icon-right">
        <input ref="input" type="text" placeholder="Поиск" onKeyPress={this.onKeyPress.bind(this)} />
        <span className="icon size-10 search-purple"></span>
      </div>
    );
  }
}
