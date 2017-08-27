import React from 'react';
import cx from "classnames";

import DP from "presenters/Dreamer";

import ImageUpload from "./ImageUpload";

export default class Avatar extends React.Component {
  constructor(props) {
    super(props);
    this.state = { imageUrl: DP.avatar(props.dreamer, 'medium') };
  }

  render() {
    const { isCurrentUser, dreamer } = this.props;

    const { imageUrl } = this.state;

    const avatarWrapperCx = cx('avatar-wrapper', { online: dreamer.is_online });

    return (
      <div className={avatarWrapperCx}>
        <div className="avatar size-xl" onClick={this.onClick.bind(this)}>
          <img alt="avatar" src={imageUrl} />
        </div>
        <ImageUpload
          ref="imageUpload"
          url={Routes.api_web_profile_path()}
          fieldName="avatar"
          cropperType="avatar"
          onSuccess={(profile) => this.setState({ imageUrl: DP.avatar(profile, 'medium') })} />
      </div>
    );
  }

  onClick() {
    this.refs.imageUpload.openFileSelect();
  }
}

