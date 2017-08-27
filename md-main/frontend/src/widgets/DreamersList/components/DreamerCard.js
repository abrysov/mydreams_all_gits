import cx from "classnames";
import moment from 'moment';
import React from 'react';

import DP from "presenters/Dreamer";

export default class extends React.Component {
  render() {
    const dreamer = this.props;
    const {
      id,
      full_name,
      gender,
      online,
      vip,
      i_friend,
      onSendMessageClick,
      onAddFriendClick,
      onRemoveFriendClick
    } = this.props;

    const avatarCx = cx({ online, vip }, 'avatar-block');
    const genderCx = cx('icon size-8', gender);

    return (
      <div className="card dreamer">
        <div className="front">
          <div className="top">
            <a href={DP.url(dreamer)} className="picture">
              <img src={DP.dreambookBg(dreamer)} />
            </a>
            <a href={DP.url(dreamer)} className={avatarCx}>
              <div className="avatar">
                <img src={DP.avatar(dreamer, 'pre_medium')} />
              </div>
            </a>
          </div>
          <div className="actions">
            <a href="#" className="options-button"></a>
            { i_friend
              ? <a href="#"
                  className="button blue circle add-friend confirmed"
                  onClick={(e) => onRemoveFriendClick(id)}></a>
                : <a href="#"
                  className="button blue circle add-friend"
                  onClick={(e) => onAddFriendClick(id)}></a> }
          </div>
          <div className="description">
            <a href={DP.url(dreamer)}>
              <h3>{full_name}</h3>
              <div className="icon-text info">
                <div className={genderCx} />
                <span>{DP.locationInfo(dreamer)}</span>
              </div>
              <h5>{DP.status(dreamer)}</h5>
            </a>
            <a className="button blue accent" href="#" onClick={(e) => onSendMessageClick(id)}>Send Message</a>
          </div>
        </div>
      </div>
    );
  }
}
