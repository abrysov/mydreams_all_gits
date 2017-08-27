import React from "react";
import { request }  from 'lib/ajax';

import DP from "presenters/Dreamer";

import ImageUpload from "./ImageUpload";

export default class extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      imageUrl: DP.dreambookBg(props.dreamer),
    };
  }

  render() {
    const { isCurrentUser, imageUrl } = this.state;

    return (
      <div>
        <div className="image-box size-l" style={{ backgroundImage: `url(${imageUrl})`}} onClick={this.onClick.bind(this)} />
        <ImageUpload
          ref="imageUpload"
          url={Routes.api_web_profile_path()}
          fieldName="dreambook_bg"
          cropperType="header"
          onSuccess={(profile) => this.setState({ imageUrl: DP.dreambookBg(profile) })} />
      </div>
    );
  }

  onClick() {
    this.refs.imageUpload.openFileSelect();
  }
}
