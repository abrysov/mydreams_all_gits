import $ from "jquery";
import React from "react";

function getOffset(scrollableSelector, contentSelector) {
  const scrollableEl = document.querySelector(scrollableSelector); // body
  const contentEl = document.querySelector(contentSelector); // .content-body

  const scrollableOffset = scrollableEl.scrollTop;
  const contentOffset = contentEl.scrollHeight - contentEl.offsetHeight;

  return Math.abs(contentOffset - scrollableOffset);
}

export default class extends React.Component {
  constructor(props) {
    super(props);
    this.state = { currentOffsetDiff: getOffset('body', '.content-body') };
  }
  handleScroll(e) {
    const offset = getOffset('body', '.content-body');

    //NOTE: Magic number
    if (offset < 100 && offset < this.state.currentOffsetDiff) {
      this.props.onScrollEnd(e);
    }

    this.setState({ currentOffsetDiff: offset });
  }

  componentDidMount() {
    this.handleScroll = this.handleScroll.bind(this);

    $(window).on('scroll', this.handleScroll);
  }

  componentWillUnmount() {
    $(window).off('scroll', this.handleScroll);
  }

  render() {
    const { isLoading, className, children } = this.props;
    return (
      <div>
        <div className={className}>{children}</div>
        <div className="preloader" style={{ opacity: isLoading ? 1 : 0 }} />
      </div>
    );
  }
}
