import cx from "classnames";
import moment from 'moment';
import React from 'react';

import DP from "presenters/Dreamer";

export default class extends React.Component {
  render() {
    const {
      sender,
      onApproveFriendClick,
      onRejectFriendClick
    } = this.props;
    const dreamer = this.props.sender;
    const {
      id,
      full_name,
      status,
      gender,
      online,
      vip,
      i_friend
    } = dreamer;

    const cardCx = cx({ online, vip }, "card dreamer");
    const avatarCx = cx({ online, vip }, 'avatar-block');
    const genderCx = cx('icon size-8', gender);

    return (
      <div className={cardCx}>
        <div className="front">
          <div className="top">
            { DP.hasDreambookBg(dreamer)
              ? <a className="picture" href={DP.url(dreamer)}>
                <img src={DP.dreambookBg(dreamer)} />
              </a>
              : "" }
            <a href={DP.url(dreamer)} className={avatarCx}>
              <div className="avatar">
                <img src={DP.avatar(dreamer, 'pre_medium')} />
              </div>
            </a>
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
          </div>
          <div className="button-group">
            <a className="button blue accent" href="#" onClick={(e) => onApproveFriendClick(id)}>Добавить</a>
            <a className="button blue" href="#" onClick={(e) => onRejectFriendClick(id)}>Отклонить</a>
          </div>
        </div>
      </div>
    );
  }
}
