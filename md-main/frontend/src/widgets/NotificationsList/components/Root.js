import Routes from "routes";
import React from 'react';
import { connect } from 'react-redux';

import Notification from "./Notification";

import {
  handleNotificationClick,
  closeNotification
} from "../Actions";

class Root extends React.Component {
  render() {
    const { state, dispatch } = this.props;

    const actions = {
      onClick: (id) => dispatch(handleNotificationClick(id)),
      onClose: (id) => dispatch(closeNotification(id))
    };

    return (
      <div className="notification-list">
        {state.notifications.map((n) => <Notification key={n.get('id')} {...n.toJS()} {...actions} />)}
      </div>
    );
  }
}

export default connect(
  (state, ownProps) => ({
    state: state.notificationsList
  })
)(Root);


