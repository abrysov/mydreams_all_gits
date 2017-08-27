import Routes from "routes";
import React from 'react';
import { connect } from 'react-redux';

import _ from "lodash";

import Message from "./Message";
import ScrollView from "./ScrollView";
import TextBox from "./TextBox";

import {
  sendMessage,
  loadPreviousMessages,
  mainAreaScroll
} from "../Actions";

class MainArea extends React.Component {
  render() {
    const { dispatch, state } = this.props;

    const currentConversation = state.messenger.getCurrentConversation()
    const current_dreamer = state.user.toJS().user;

    if (currentConversation) {
      const messages = currentConversation.messages;
      const dreamer = currentConversation.getDreamer().toJS();
      const scrollBottom = currentConversation.scrollBottom;

      const dreamerUrl = Routes.d_path(dreamer.id);

      return (
        <div className="main">
          <div className="header">
            <a className="dreamer-link" href={dreamerUrl}>{dreamer.full_name}</a>
            {dreamer.online ? <span className="status">online</span> : "" }
          </div>

          <ScrollView className="messages-list" key={currentConversation.id}
            scrollBottom={scrollBottom}
            onScrollTop={() => dispatch(loadPreviousMessages())}
            onScroll={() => dispatch(mainAreaScroll())}
            collection={messages}
            itemRenderer={(m) => <Message key={m.get('id')} {...m.toJS()} current_dreamer={current_dreamer}  />}>
          </ScrollView>

          <TextBox onSubmit={(text) => dispatch(sendMessage(text))} />
        </div>
      );

    } else {
      return (
        <div className="main">
          <div className="dialog-info">Пожалуйста, выберите&nbsp;диалог</div>
        </div>
      );
    }
  }
}

export default connect(
  (state, ownProps) => ({
    location: ownProps.location,
    state: state
  })
)(MainArea);
