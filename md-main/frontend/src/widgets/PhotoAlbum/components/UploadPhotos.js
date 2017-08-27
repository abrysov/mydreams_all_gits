import React from "react";
import { connect } from "react-redux";

import {
  uploadPhoto
} from "../Actions";

class UploadPhotos extends React.Component {
  handlePhotos(e) {
    const photos = e.target.files;

    if (!photos || photos.length === 0) return;

    for (let ph of photos) {
      this.props.dispatch(uploadPhoto(ph));
    }

    this.refs.photos.value = '';
  }

  render() {
    return (
      <div className="top">
        <div className="wrapper">
          <div className="button purple filearea">
            Выбрать файлы
            <input ref="photos" accept="image/*" type="file" multiple={true} onChange={this.handlePhotos.bind(this)} />
          </div>
        </div>
      </div>
    );
  }
}

export default connect(
  (state, ownProps) => ({
    ownProps
  })
)(UploadPhotos);