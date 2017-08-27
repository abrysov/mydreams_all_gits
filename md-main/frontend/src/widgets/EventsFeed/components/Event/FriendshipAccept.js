import Routes from "routes";
import React from 'react';
import DateTime from "lib/datetime";
import DreamerAvatar from "lib/components/DreamerAvatar";

export default class extends React.Component {
  render() {
    const {
      initiator,
      created_at
    } = this.props;

    const initiatorUrl = Routes.d_path(initiator.id);

    return (
      <div className="content-items">
        <div className="row">
          <div className="avatar-col">
            <DreamerAvatar dreamer={initiator} size="m" />
          </div>
          <div className="info-col">
            <div className="username-row">
              <a href={initiatorUrl}>{initiator.full_name}</a>
              <span className="action-type">Принял Ваше приглашение в друзья</span>
            </div>
            <div className="icon-text time">
              <div className="icon size-8 time"></div>
              <div className="text">{DateTime.formatUpdateDate(created_at)}</div>
            </div>
          </div>
        </div>
      </div>
    );
  }
}
