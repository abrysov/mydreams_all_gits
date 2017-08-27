import Routes from "routes";
import React from 'react';

import DreamCommented from "./Event/DreamCommented";
import PostCommented from "./Event/PostCommented";
import DreamLiked from "./Event/DreamLiked";
import PostLiked from "./Event/PostLiked";
import FriendshipRequested from "./Event/FriendshipRequested";
import FriendshipAccept from "./Event/FriendshipAccept";

export default class Event extends React.Component {
  render() {
    const {
      action
    } = this.props;

    switch (action) {
      case 'dream_commented':
        return <DreamCommented {...this.props} />;
      case 'post_commented':
        return <PostCommented {...this.props} />;
      case 'dream_liked':
        return <DreamLiked {...this.props} />;
      case 'post_liked':
        return <PostLiked {...this.props} />;
      case 'friendship_requested':
        return <FriendshipRequested {...this.props} />;
      case 'friendship_accept':
        return <FriendshipAccept {...this.props} />;
      default:
        throw action;
    }
  }
}
