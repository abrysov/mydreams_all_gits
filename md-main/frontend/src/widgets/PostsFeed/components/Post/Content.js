import Routes from "routes";
import React from "react";

import HyperText from "lib/components/HyperText";

const TRUNCATE_LENGTH = 200;

export default class Content extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      isExpandable: props.content.length > TRUNCATE_LENGTH,
      isExpanded: false,
      shortContent: props.content.substr(0, TRUNCATE_LENGTH) + "..."
    };
  }

  render() {
    return (
      <div>
        {this.renderContent()}
        <line></line>
        {this.renderToggleButton()}
      </div>
    );
  }

  renderContent() {
    if (!this.state.isExpandable || this.state.isExpanded) {
      return <HyperText>{this.props.content}</HyperText>;
    } else {
      return <HyperText>{this.state.shortContent}</HyperText>;
    }
  }

  renderToggleButton() {
    if (this.state.isExpandable) {
      return <div className="show-more" onClick={this.onToggle.bind(this)}>{
        this.state.isExpanded
          ? "Скрыть"
          : "Показать полностью..."
      }</div>
    }
  }

  onToggle() {
    this.setState({ isExpanded: !this.state.isExpanded });
  }
}
