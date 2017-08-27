import Routes from "routes";
import React from "react";

export default class ImageGrid extends React.Component {
  render() {
    const {
      photos = [],
      onClick
    } = this.props;

    return (
      <div className="image-grid">
        <div className="row">
          {photos.map((p) => {
            return (
              <div
                onClick={() => onClick(p.id)}
              key={p.id}
              className="img"
              style={{ 'backgroundImage': `url(${p.photo.large})` }}
            ></div>
            );
          })}
        </div>
      </div>
    );
  }
}




