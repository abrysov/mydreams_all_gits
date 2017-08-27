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

    const dream = resource.dream;
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
              <span className="action-type">
                <span className="icon action like"></span>
                Понравилась Ваша Мечта
              </span>
            </div>
            <div className="icon-text time">
              <div className="icon size-8 time"></div>
              <div className="text">{DateTime.formatUpdateDate(created_at)}</div>
            </div>
          </div>
        </div>
        <div className="update-content new-dream">
          <div className="dream">
            <div className="label presidential">PRESIDENTIAL</div>
            <img alt={dream.title} src={dream.photo.medium} />
          </div>
          <div className="description">
            <h3>{dream.title}</h3>
            <p>{dream.description}</p>
          </div>
        </div>
      </div>
    );
  }
}
