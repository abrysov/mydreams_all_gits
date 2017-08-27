import Routes from "routes";
import React from 'react';
import DateTime from "lib/datetime";
import DreamerAvatar from "lib/components/DreamerAvatar";

export default class extends React.Component {
  render() {
    const {
      initiator,
      resource,
      created_at
    } = this.props;

    const { dreamer } = resource;

    return (
      <div className="content-items">
        <div className="row">
          <div className="avatar-col">
              <DreamerAvatar dreamer={initiator} size="m" />
          </div>
          <div className="info-col">
            <div className="username-row">
              <a className="username" href={initiator.url}>{initiator.full_name}</a>
              <span className="action-type">
                Подарил
                <strong>VIP</strong>
                статус
              </span>
            </div>
            <div className="icon-text time">
              <div className="icon size-8 time"></div>
              <div className="text">{DateTime.formatUpdateDate(created_at)}</div>
            </div>
          </div>
        </div>
        <div className="update-content get-subject">
          <div className="subject vip give"></div>
          <div className="dreamers-list">
            <div>
              <DreamerAvatar dreamer={dreamer} size="l" />
              <a className="username vip">{dreamer.full_name}</a>
            </div>
          </div>
        </div>
      </div>
    );
  }
}
