import React from "react";
import ReactDOM from "react-dom";

export default class FileUpload extends React.Component {
  open() {
    $(this.refs.in).click();
  }

  handleFile(e) {
    const reader = new FileReader();
    const file = e.target.files[0];

    if (!file) return;

    reader.onload = (img) => {
      this.refs.in.value = '';
      this.props.onSelect({
        file,
        dataURI: img.target.result
      });
    };

    reader.readAsDataURL(file);
  }

  render() {
    return (
      <input ref="in" type="file" accept="image/*" onChange={this.handleFile.bind(this)} />
    );
  }
}
