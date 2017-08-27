import Routes from "routes";
import { connect } from "react-redux";
import { request } from "lib/ajax";
import React from "react";
import * as PhotoUploadManager from "managers/PhotoUpload";

import {
  updatePost
} from "../../Actions";

class EditForm extends React.Component {
  constructor(props) {
    super(props);
    this.state = { photos: this.props.photos };
  }
  onSubmit() {
    const content = this.refs.content.value.trim();
    if (content !== '') {
      this.props.dispatch(updatePost(this.props.postId, {
        content,
        post_photos_ids: this.state.photos.map(p => p.id)
      }));
    }
  }

  render() {
    const {
      postId,
      currentUser,
      content,
    } = this.props;

    const { photos } = this.state;

    const url = Routes.d_path(currentUser.id);

    return (
      <div>
        <div className="row">
          <div className="avatar-col">
            <a className="avatar size-m" href={url}>
              <img alt="" src={currentUser['avatar/small']} />
            </a>
          </div>
          <div className="info-col">
            <div className="textarea-wrapper">
              <textarea ref="content" defaultValue={content}></textarea>
              <div className="attach-button filearea">
                <input type="file" accept="image/*" multiple onChange={this.onFilesSelect.bind(this)} />
              </div>
            </div>
            <div className="attach-list">
              {photos.map((p) => (
                <div className="img" key={`photo-${p.id}`} style={ { backgroundImage: `url(${p.photo.medium})` } }>
                  <div className="close" onClick={() => this.onPhotoDelete(p.id)}></div>
                </div>
              ))}
            </div>
          </div>
        </div>
        <div className="actions">
          <button className="blue accent" onClick={this.onSubmit.bind(this)}>Сохранить изменения</button>
        </div>
      </div>
    );
  }

  onFilesSelect(e) {
    PhotoUploadManager.uploadPostPhotos(e.target.files, (photo) => {
      this.setState({ photos: this.state.photos.concat(photo)});
    });
  }

  onPhotoDelete(id) {
    this.setState({ photos: this.state.photos.filter(p => p.id != id) });
  }
}

export default connect(
  (state, ownProps) => ({})
)(EditForm);

