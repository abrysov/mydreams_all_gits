import React from "react";
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
    if (this.props.isEditing) {
      this.refs.fileUpload.open();
    }
  }

  render() {
    const { isCropperOpened, photo } = this.state;
    const pictureStyles = {
      backgroundImage: `url(${this.props.image})`,
      backgroundSize: 'cover'
    };

    return (
      <div className="image">
        { isCropperOpened ?
          <ImageCropperModal
            type="dream"
            image={photo.dataURI}
            onSave={(e) => this.handleCropperSave(e)}
            onClose={(e) => this.handleCropperClose(e)} />
          : ""}
          <img alt="" src={this.props.image} onClick={() => this.openFileSelect()} />
          <div style={{display: 'none'}}>
            <FileUpload ref="fileUpload" onSelect={(e) => this.handlePhotoSelect(e)} />
          </div>
        </div>
    );
  }

  handlePhotoSelect(e) {
    this.setState({ photo: e, isCropperOpened: true });
  }

  handleCropperSave({ rect, croppedImage }) {
    this.props.onSelect({ photo: this.state.photo.file, rect, croppedDataURI: croppedImage });
    this.resetState();
  }

  handleCropperClose(e) {
    this.resetState();
  }

  resetState() {
    this.setState(this._getInitialState());
  }
}
