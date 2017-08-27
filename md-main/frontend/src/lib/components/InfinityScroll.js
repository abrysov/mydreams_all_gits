import $ from "jquery";
import React from "react";
import _ from "lodash";

export default class extends React.Component {
  onScroll(e) {
    const {
      onScrollTop = _.noop,
      onScrollBottom = _.noop,
      onScroll = _.noop
    } = this.props;

    const list = this.refs.list;

    if (list.scrollTop == 0) {
      onScrollTop(e);
    }

    if (list.scrollTop - list.scrollHeight - list.offsetHeight < 5) {
      onScrollBottom(e);
    }

    onScroll(e);
  }

  render() {
    const { isLoading, className, children } = this.props;
    return (
      <div ref="list" className={className} onScroll={this.onScroll.bind(this)}>
        {children}
        <div className="preloader" style={{ opacity: isLoading ? 1 : 0 }} />
      </div>
    );
  }
}
