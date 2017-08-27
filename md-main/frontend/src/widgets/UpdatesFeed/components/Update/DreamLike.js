import Routes from "routes";
import React from 'react';
import DateTime from "lib/datetime";
import DreamerAvatar from "lib/components/DreamerAvatar";

export default class extends React.Component {
  render() {
    const {
      created_at
    } = this.props;

    return (
      <div className="content-items">
        Dream Like
      </div>
    );
  }
}
