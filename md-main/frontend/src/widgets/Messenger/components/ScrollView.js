import React from "react";
import _ from "lodash";

export default class ScrollView extends React.Component {
  constructor(props) {
    super(props);
    this.state = { currentOffset: 0, needScrollBottom: true, needScrollToOffset: false };
    this.onScroll = _.debounce((e) => this.props.onScroll(e), 5000);
  }

  componentDidMount() {
    $(this.refs.list).scroll(this.handleScroll.bind(this));
  }

  componentWillReceiveProps(newProps) {
    if (newProps.scrollBottom) {
      this.setState({ needScrollBottom: true });
    }

    const newCollection = newProps.collection;
    const oldCollection = this.props.collection;

    if (oldCollection.size < newCollection.size
        && oldCollection.size > 0
        && oldCollection.get(0).get('id') != newCollection.get(0).get('id')) {
      this.setState({ needScrollToOffset: true, oldHeight: this.refs.list.scrollHeight });
    }
  }

  componentDidUpdate() {
    if (this.state.needScrollBottom) {
      this.scrollBottom();
    }

    if (this.state.needScrollToOffset) {
      this.scrollToOffset();
    }
  }

  render() {
    return (
      <div ref="list" {...this.props}>{this.props.collection.map(this.props.itemRenderer)}</div>
    );
  }

  scrollToOffset() {
    this.manualScroll = true;

    const list = this.refs.list;
    list.scrollTop = list.scrollHeight - this.state.oldHeight;
    this.setState({ needScrollToOffset: false });

    this.manualScroll = false;
  }

  scrollBottom() {
    this.manualScroll = true;

    const list = this.refs.list;
    list.scrollTop = list.scrollHeight;
    this.setState({ needScrollBottom: false });

    this.manualScroll = false;
  }

  handleScroll(e) {
    if (!this.manualScroll) {
      const offset = this.refs.list.scrollTop;

      if (offset == 0) {
        this.props.onScrollTop(e);
      }

      this.onScroll(e);
    }
  }
}
