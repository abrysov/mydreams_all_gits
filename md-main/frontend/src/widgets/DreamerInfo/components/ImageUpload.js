import React from "react";
import { request }  from 'lib/ajax';

import ImageCropperModal from "lib/components/ImageCropperModal";
import FileUpload from "lib/components/FileUpload";

export default class extends React.Component {
  constructor(props) {
    super(props);
    this.state = this._getInitialState();
  }

  _getInitialState() {
    return {
      isCropperOpened: false,
      photo: {
        file: null,
        dataURI: null
      }
    };
  }

  openFileSelect() {
    this.refs.fileUpload.open();
  }

  render() {
    const { isCropperOpened, photo } = this.state;

    return (
      <div>
        { isCropperOpened ?
          <ImageCropperModal
            type={this.props.cropperType}
            image={photo.dataURI}
            onSave={(e) => this.handleCropperSave(e)}
            onClose={(e) => this.handleCropperClose(e)} />
          : ""}
          <div style={{display: 'none'}}>
            <FileUpload ref="fileUpload" onSelect={(e) => this.handlePhotoSelect(e)} />
          </div>
      </div>
    );
  }

  handlePhotoSelect(e) {
    this.setState({
      photo: e,
      isCropperOpened: true
    });
  }

  handleCropperSave(e) {
    this.savePhoto(e)
    .then(({ profile }) => this.props.onSuccess(profile))
    .then(() => this.resetState());
  }

  handleCropperClose(e) {
    this.resetState();
  }

  resetState() {
    this.setState(this._getInitialState());
  }

  savePhoto(croppedPhoto) {
    const formData = this.buildFormData(croppedPhoto);
    const url = this.props.url;
    return request(url, 'PUT', formData)
            .then((r) => r.json());
  }

  buildFormData(croppedPhoto) {
    const fieldName = this.props.fieldName;

    const state = this.state;
    const formData = new FormData();
    formData.append(fieldName, state.photo.file);
    formData.append(`${fieldName}_crop_x`, croppedPhoto.rect.x);
    formData.append(`${fieldName}_crop_y`, croppedPhoto.rect.y);
    formData.append(`${fieldName}_crop_w`, croppedPhoto.rect.width);
    formData.append(`${fieldName}_crop_h`, croppedPhoto.rect.height);
    return formData;
  }
}

