import Routes from "routes";
import React from 'react';
import { connect } from 'react-redux';

import _ from "lodash";

import {
  closeMessenger,
  handleMessengerOpened,
  handleConversationIdForOpenChanged,
  loadNextConversations,
  openConversation
} from "../Actions";

import InfinityScroll from "lib/components/InfinityScroll";

import ConversationItem from "./ConversationItem";

class ConversationsArea extends React.Component {
  componentDidMount() {
    this.props.dispatch(handleMessengerOpened());
  }

  componentWillReceiveProps(newProps) {
    const oldConversationIdForOpen = this.props.state.conversationIdForOpen;
    const newConversationIdForOpen = newProps.state.conversationIdForOpen;
    if (oldConversationIdForOpen != newConversationIdForOpen
        && newConversationIdForOpen > 0) {
      this.props.dispatch(handleConversationIdForOpenChanged());
    }
  }

  render() {
    const { state, dispatch } = this.props;
    const {
      conversationsList,
      totalConversationsCount,
      isConversationsListLoadStarted,
      currentConversationId
    } = state;

    return (
      <div className="right">
        <div className="header">
          Диалоги
          <span className="dialog-count">{totalConversationsCount}</span>
          <div className="close" onClick={() => dispatch(closeMessenger())}></div>
        </div>

        <InfinityScroll
          className="dialog-list"
          isLoading={isConversationsListLoadStarted}
          onScrollBottom={(e) => dispatch(loadNextConversations())}>
          {conversationsList.map((c) => {
            const id = c.get('id');
            const isActive = id == currentConversationId;
            const onClick = (id) => dispatch(openConversation(id));
            return <ConversationItem {...c.toJS()} key={id} onClick={onClick} isActive={isActive} />;
          })}
        </InfinityScroll>

      </div>
    );
  }
}

export default connect(
  (state, ownProps) => ({
    state: state.messenger
  })
)(ConversationsArea);
