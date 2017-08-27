import React from "react";
import ReactDOM from "react-dom";

import ImageCropper from "./ImageCropper";

export default class ImageCropperModal extends React.Component {
  constructor(props) {
    super(props);
    this.state = { scale: 1.0 };
  }

  onSave() {
    const croppedImage = this.refs.cropper.getImage().toDataURL();
    const rect = this.refs.cropper.getCroppingRect2();

    this.props.onSave({croppedImage, rect});
  }

  onClose() {
    this.props.onClose();
  }

  onScale() {
    const scale = parseFloat(this.refs.scale.value);
    this.setState({scale});
  }

  getDimensions() {
    switch(this.props.type) {
      case "dream":
        return { width: 353, height: 353 };
      case "avatar":
        return { width: 353, height: 353 };
      case "header": // Dreambook Bg
        return { width: 612, height: 224 };
    }
  }

  render() {
    const { image, type } = this.props;

    const { width, height } = this.getDimensions();

    return (
      <div className="popup-container">
        <div className="popup popup-crop">
          <div className="close" onClick={this.onClose.bind(this)}></div>
          <h3>Редактировать</h3>

          <div className={`crop-area for-${type}`}>
            <ImageCropper
              ref="cropper"
              width={width}
              height={height}
              borderRadius={0}
              image={image}
              scale={this.state.scale}
            />
          </div>
          <div className="zoom-range">
            <div className="icon little"></div>
            <div className="control">
            <input name="scale"
              style={{ width: "100%" }}
              type="range"
              ref="scale"
              onChange={this.onScale.bind(this)}
              min="0.5" max="3" step="0.05" defaultValue="1" />
            </div>
            <div className="icon big"></div>
          </div>
          <button className="accent blue" onClick={this.onSave.bind(this)}>Сохранить</button>
        </div>
      </div>
    );
  }
}
