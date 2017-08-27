import Routes from "routes";
import React from 'react';
import DateTime from "lib/datetime";
import Content from "widgets/PostsFeed/components/Post/Content";
import ImageGrid from "widgets/PostsFeed/components/Post/ImageGrid";
import DreamerAvatar from "lib/components/DreamerAvatar";

export default class extends React.Component {
  render() {
    const {
      initiator,
      resource,
      created_at
    } = this.props;

    const post = resource.post;
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
                <span className="icon action comment"></span>
                Прокомментировал Ваш пост&nbsp;
              </span>
            </div>
            <div className="icon-text time">
              <div className="icon size-8 time"></div>
              <div className="text">{DateTime.formatUpdateDate(created_at)}</div>
            </div>
          </div>
        </div>
        <div className="row">
          <Content content={post.content} />
          <ImageGrid photos={post.photos} />
        </div>
      </div>
    );
  }
}
