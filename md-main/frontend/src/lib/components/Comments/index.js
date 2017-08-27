import React from "react";
import { requestJson, getJson } from "lib/ajax";

import messengerWs from "lib/messengerWs";
import Comment from "./Comment";
import Form from "./Form";

function convertRailsComments(list) {
  return list.map((i) => ({
    id: i.id,
    dreamer_id: i.dreamer.id,
    body: i.body,
    dreamer_full_name: i.dreamer.full_name,
    dreamer_avatar: i.dreamer.avatar.small,
    created_at: i.created_at
  }));
}

export default class Comments extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      comments: convertRailsComments(props.lastComments || []),
      resourceId: props.resourceId,
      resourceType: props.resourceType,
      totalCommentsCount: props.totalCommentsCount
    };

    messengerWs.onCommentsList(this.getWsKey(), (payload, key) => {
      this.setState({
        comments: payload.comments,
        totalCommentsCount: payload.comments.length
      });
    });

    messengerWs.onNewComment(this.getWsKey(), (payload, key) => {
      this.setState({
        comments: this.state.comments.concat([payload]),
        totalCommentsCount: this.state.totalCommentsCount + 1
      });
    });
  }

  componentDidMount() {
    messengerWs.sendCommentsSubscribe(this.getWsKey());
  }

  componentWillUnmount() {
    messengerWs.sendCommentsUnsubscribe(this.getWsKey());
  }

  getWsKey() {
    return { resourceId: this.state.resourceId, resourceType: this.state.resourceType };
  }

  render() {
    const {
      comments,
      totalCommentsCount
    } = this.state;

    const isShowMoreCommentsButtonVisible = comments.length < totalCommentsCount;

    return (
      <div>
        { isShowMoreCommentsButtonVisible ?
          <div className="load-more-comments"
            onClick={this.onShowMoreClick.bind(this)}>
            Показать все <strong> {totalCommentsCount} </strong> комментариев
          </div>
        : "" }

        <div className="comments-list">
          {comments.map((c) => <Comment key={`comment-${c.id}`} {...c} />)}
        </div>

        <Form onSubmit={this.onSubmit.bind(this)} />
      </div>
    );
  }

  onSubmit({ value }) {
    messengerWs.sendCreateComment(this.getWsKey(), value);
  }

  onShowMoreClick() {
    messengerWs.sendRequestComments(this.getWsKey(), 0, this.state.totalCommentsCount);
  }
}
