import React from "react";
import cx from "classnames";
import DateTime from "lib/datetime";

export default class ConversationItem extends React.Component {
  render() {
    const {
      id,
      dreamers,
      dreamers_count,
      last_message,
      isActive,
      unreaded_messages_count,
      onClick
    } = this.props;

    const dreamer = dreamers[0];
    const hasUnreadMessages = unreaded_messages_count != 0;
    const dreamerUrl = Routes.d_path(dreamer.id);

    const classes = cx({ active: isActive, new: hasUnreadMessages, online: dreamer.online }, 'dialog');
    return (
      <div className={classes} onClick={() => onClick(id)}>
        <a className="avatar-link" href="#">
          <div className="avatar size-s">
            <img src={dreamer.avatar.pre_medium} />
          </div>
        </a>
        <div className="body">
          <div className="header">
            <a href="#">{dreamer.full_name}</a>
            { hasUnreadMessages ?
              <div className="button noti-count accent blue">{unreaded_messages_count}</div>
            : "" }
            { last_message ?
              <div className="date">{DateTime.formatMessageDate(last_message.created_at)}</div>
              : ""}
          </div>
          { last_message ?
          <p>{last_message.body}</p>
          : ""}
        </div>
      </div>
    );
  }
}
