import Routes from "routes";
import React from "react";
import { connect } from "react-redux";
import DateTime from "lib/datetime";
import DreamerAvatar from "lib/components/DreamerAvatar";

import {
  beginEditPost
} from "../../Actions";

import DP from "presenters/Dreamer";

class Header extends React.Component {
  render() {
    const {
      dispatch,
      postId,
      dreamer,
      createdAt,
      currentUser
    } = this.props;

    return (
      <div className="row">
        <div className="avatar-col">
          <DreamerAvatar dreamer={dreamer} size="m" />
        </div>
        <div className="info-col">
          <div className="username-row">
            <a href={DP.url(dreamer)}>{DP.fullName(dreamer)}</a>
          </div>
          <div className="icon-text time">
            <div className="icon size-8 time"></div>
            <div className="text">{DateTime.formatPostDate(createdAt)}</div>
          </div>
        </div>
        <div className="action-buttons">
          { dreamer.id === currentUser.id ? (
            <a className="edit" onClick={(e) => dispatch(beginEditPost(postId))}>Редактировать</a>
          ) : '' }
        </div>
      </div>
    );
  }
}

export default connect(
  (state, ownProps) => ({})
)(Header);

