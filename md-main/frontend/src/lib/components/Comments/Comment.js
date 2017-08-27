import React from "react";
import DateTime from "lib/datetime";

export default class Comment extends React.Component {
  render() {
    const {
      body,
      created_at,
      id,
      dreamer_id,
      dreamer_first_name,
      dreamer_last_name,
      dreamer_avatar,
      dreamer_full_name
    } = this.props;

    const dreamerUrl = Routes.d_path(dreamer_id);
    const fullName = dreamer_full_name || `${dreamer_first_name} ${dreamer_last_name}`;

    return (
      <div className="comment row">
        <div className="avatar-col">
          <a className="avatar size-s" href={dreamerUrl}>
            <img alt={fullName} src={dreamer_avatar} />
          </a>
        </div>
        <div className="content-col">
          <div className="username-row">
            <a href={dreamerUrl}>{fullName}</a>
          </div>
          <div className="icon-text time">
            <div className="icon size-8 time"></div>
            <div className="text">{DateTime.formatCommentDate(created_at)}</div>
          </div>
          <p>
            {body}
          </p>
        </div>
      </div>
    );
  }
}
