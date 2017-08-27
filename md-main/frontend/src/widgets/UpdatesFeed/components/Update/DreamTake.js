import Routes from "routes";
import React from 'react';
import DateTime from "lib/datetime";
import DreamerAvatar from "lib/components/DreamerAvatar";
import DP from "presenters/Dream";

export default class extends React.Component {
  render() {
    const {
      initiator,
      resource,
      created_at
    } = this.props;

    const { dream } = resource;

    return (
      <div className="content-items">
        <div className="row">
          <div className="avatar-col">
            <DreamerAvatar dreamer={initiator} size="m" />
          </div>
          <div className="info-col">
            <div className="username-row">
              <a className="username" href={initiator.url}>{initiator.full_name}</a>
              <span className="action-type">Добавил новую мечту</span>
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
            <img alt="" src={dream.photo.medium} />
          </div>
          <div className="description">
            <h3>
              <a href={DP.url(dream)}>{dream.title}</a>
            </h3>
            <p>{DP.description(dream, 150)}</p>
          </div>
        </div>
      </div>
    );
  }
}
