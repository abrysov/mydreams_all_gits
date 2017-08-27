import React from "react";

import { requestJson, getJson } from "lib/ajax";
import DreamerAvatar from "lib/components/DreamerAvatar";

import {
  buildApiLikeUrl,
  buildApiUnlikeUrl
} from "lib/apiUrlsBuilders";

import DP from "presenters/Dreamer";

export default class LikesBlock extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      entityId: props.entityId,
      entityType: props.entityType,
      likedByMe: props.likedByMe || false,
      likesCount: props.likesCount || 0,
      lastLikes: props.lastLikes || [],
      currentUser: props.currentUser
    };
  }

  componentWillReceiveProps(nextProps) {
    this.setState({
      entityId: nextProps.entityId,
      entityType: nextProps.entityType,
      likedByMe: nextProps.likedByMe,
      likesCount: nextProps.likesCount,
      lastLikes: nextProps.lastLikes,
      currentUser: nextProps.currentUser
    });
  }

  like() {
    requestJson(buildApiLikeUrl(this.props.entityType, this.props.entityId), 'POST')
      .then((r) => r.json())
      .then(
        (r) => {
          var newLastLikes = this.state.lastLikes;
          newLastLikes.unshift(r.like);
          this.setState({
            likedByMe: true,
            likesCount: this.state.likesCount + 1,
            lastLikes: newLastLikes
          })
        },
        (xhr, status, error) => {}
      );
  }

  unlike() {
    requestJson(buildApiUnlikeUrl(this.props.entityType, this.props.entityId), 'DELETE')
      .then(
        (r) => this.setState({
          likedByMe: false,
          likesCount: this.state.likesCount - 1,
          lastLikes: this.state.lastLikes.filter((like) => (like.dreamer.id !== this.state.currentUser.id))
        }),
        (xhr, status, error) => {}
      );
  }

  onLikeClick() {
    if (this.state.likedByMe) {
      this.unlike();
    } else {
      this.like();
    }
  }

  onShowLikesClick() {
    MyDreams.LikesModal.open(this.props.entityType, this.props.entityId);
  }

  render() {
    return (
      <div className="likes-block">
        <div className="like-button icon-text">
          <div className={"icon like" + (this.state.likedByMe ? " active" : "")}
               onClick={this.onLikeClick.bind(this)}></div>
          <div className="text" onClick={this.onShowLikesClick.bind(this)}>
            Нравится
            <strong> {this.state.likesCount} </strong>
          </div>
        </div>
        <div className="like-list">
          {this.state.lastLikes.map((like) => {
            var dreamer = like.dreamer;
            return (
              <DreamerAvatar dreamer={dreamer} size="xs" key={`dreamer-avatar-${dreamer.id}`} />
            );
          })}
        </div>
      </div>
    );
  }
}


