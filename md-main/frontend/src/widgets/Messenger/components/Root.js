import Routes from "routes";
import React from 'react';
import { connect } from 'react-redux';

import cx from "classnames";

import {
  loadUser
} from "../Actions";

import MainArea from "./MainArea";
import ConversationsArea from "./ConversationsArea";

class Root extends React.Component {
  render() {
    const { state, dispatch }  = this.props;
    const { isVisible } = state;

    const classes = cx('modal messages-modal', { visible: isVisible });

    if (isVisible) {
      return (
        <div className={classes}>
          <MainArea />
          <ConversationsArea />
        </div>
      );
    } else {
      return <div className={classes} />;
    }
  }
}

export default connect(
  (state, ownProps) => ({
    location: ownProps.location,
    state: state.messenger
  })
)(Root);

