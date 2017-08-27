import Routes from "routes";
import React from "react";

import DateTime from "lib/datetime";

export default class Message extends React.Component {
  render() {
    const {
      id,
      dreamer_id,
      message,
      dreamer_first_name,
      dreamer_last_name,
      dreamer_avatar,
      created_at,
      current_dreamer
    } = this.props;

    const dreamerUrl = Routes.d_path(dreamer_id);

    return (
      <div className={"message" + (current_dreamer.id == dreamer_id ? ' outgoing' : '')}>
        <a className="avatar-link" href={dreamerUrl}>
          <div className="avatar size-s">
            <img src={dreamer_avatar} />
          </div>
        </a>
        <div className="body">
          <div className="header">
            <a href={dreamerUrl}>{dreamer_first_name} {dreamer_last_name}</a>
            <div className="date icon-text">
              <div className="icon size-8 time"></div>
              <div className="text">{DateTime.formatMessageDate(created_at)}</div>
            </div>
          </div>
          <p>{message}</p>
        </div>
      </div>
    );
  }
}
