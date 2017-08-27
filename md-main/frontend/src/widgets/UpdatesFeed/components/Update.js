import Routes from "routes";
import React from 'react';

import PostLike from "./Update/PostLike";
import DreamTake from "./Update/DreamTake";
import DreamerDeleted from "./Update/DreamerDeleted";
import DreamLike from "./Update/DreamLike";
import PaidGiftCertificate from "./Update/PaidGiftCertificate";
import PaidSelfCertificate from "./Update/PaidSelfCertificate";
import PaidGiftVip from "./Update/PaidGiftVip";
import PaidSelfVip from "./Update/PaidSelfVip";
import FriendshipAccept from "./Update/FriendshipAccept";

export default class Update extends React.Component {
  render() {
    const {
      action
    } = this.props;

    switch(action) {
      case "post_like":
        return <PostLike {...this.props} />;
      case "dream_take":
        return <DreamTake {...this.props} />;
      case "dreamer_deleted":
        return <DreamerDeleted {...this.props} />;
      case "dream_like":
        return <DreamLike {...this.props} />;
      case "paid_gift_certificate":
        return <PaidGiftCertificate {...this.props} />;
      case "paid_self_certificate":
        return <PaidSelfCertificate {...this.props} />;
      case "paid_self_vip":
        return <PaidSelfVip {...this.props} />;
      case "paid_gift_vip":
        return <PaidGiftVip {...this.props} />;
      case "friendship_accept":
        return <FriendshipAccept {...this.props} />;
      default: throw action;
    }
  }
}
