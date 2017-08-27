import Routes from "routes";
import React from 'react';
import { connect } from 'react-redux';

import {
  loadUser,
  messagesClick
} from "../Actions";

class Root extends React.Component {
  componentDidMount() {
    this.props.dispatch(loadUser());
  }

  onMessagesClick(e) {
    e.preventDefault();
    this.props.dispatch(messagesClick());
  }

  render() {
    const { dispatch, userState } = this.props;
    const dreamer_id = userState.getCached('id');
    const avatarUrl = userState.getCached('avatar/small');
    const unreadMessagesCount = userState.getCached('unreaded_messages_count');

    const dreambookUrl = Routes.d_path(dreamer_id);
    const dreambookDreamsUrl = Routes.d_dreams_path(dreamer_id);
    const dreambookFulfilledDreamsUrl = Routes.d_fulfilled_dreams_path(dreamer_id);
    const dreambookCertificatesUrl = Routes.d_certificates_path(dreamer_id);
    const dreambookFriendsUrl = Routes.d_friends_path(dreamer_id);
    const dreambookFollowersUrl = Routes.d_followers_path(dreamer_id);
    const dreambookPhotosUrl = Routes.d_photos_path(dreamer_id);

    return (
      <div className="align-right">
        <ul className="vertical-menu main">
          <li>
            <a className="user-card" href={dreambookUrl}>
              <div className="avatar size-s">
                <img alt="avatar" src={avatarUrl} />
              </div>
              <div className="description">
                <span>Мой Dreambook</span>
              </div>
            </a>
          </li>
          <li className="messages">
            <a href="#" onClick={this.onMessagesClick.bind(this)}>Сообщения</a>
            { unreadMessagesCount > 0 ?
            <i className="button noti-count purple">{unreadMessagesCount}</i>
            : ""}
          </li>
          <li className="dreams">
            <a href={dreambookDreamsUrl}>Мечты</a>
          </li>
          <li className="fulfilled_dreams">
            <a href={dreambookFulfilledDreamsUrl}>Сбывшиеся</a>
          </li>
          <li className="stamps">
            <a href={dreambookCertificatesUrl}>Марки</a>
          </li>
          <li className="photos">
            <a href={dreambookPhotosUrl}>Фотографии</a>
          </li>
          <li className="friends">
            <a href={dreambookFriendsUrl}>Друзья</a>
          </li>
          <li className="subscribers">
            <a href={dreambookFollowersUrl}>Подписчики</a>
          </li>
          <li className="notification">
            <a href={Routes.events_path()}>События</a>
            <span className="eye" />
          </li>
          <li className="news">
            <a href={Routes.feed_path()}>Новоcти</a>
          </li>
          <li className="settings">
            <a href={Routes.profile_settings_path()}>Настройки</a>
          </li>
        </ul>

      </div>
    );
  }

}

export default connect(
  (state, ownProps) => ({
    location: ownProps.location,
    userState: state.user
  })
)(Root);

