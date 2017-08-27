import React from "react";
import { connect } from "react-redux";
import { push } from 'react-router-redux';

import cx from "classnames";

import {
  hidePhoto,
  flipLeft,
  flipRight,
  pickById
} from "../Actions";

class PhotoViewer extends React.Component {
  render() {
    const { dispatch, state } = this.props;
    if (!state.isVisible) return null;

    const index = state.photos.findIndex((p) => p.get('id') === state.currentPhotoId);
    const currentPhoto = state.getIn(['photos', index]).toJSON();

    const previewWidth = 168;
    const padding = (previewWidth / 2) + (previewWidth * index);

    return (
      <div className="photoalbum-popup visible">
        <div className="left" onClick={() => dispatch(flipLeft())}></div>
        <div className="body" onClick={() => dispatch(hidePhoto())}>
          <div className="view-box">
            <img src={currentPhoto.photo} alt={currentPhoto.caption} />
            <div className="close" onClick={() => dispatch(hidePhoto())}></div>
            <div className="delete">Удалить</div>
          </div>
          <div className="gallery">
            <div className="btn icon-left"></div>
            <div className="btn icon-right"></div>
            <div className="mask">
              <div className="tape" style={{ marginLeft: `-${padding}px` }}>
                {state.photos.map((p) => {
                  const photo = p.toJSON();
                  const selected = (photo.id === state.currentPhotoId);
                  const style = { backgroundImage: 'url(' + photo.preview + ')' };
                  return (
                    <div key={photo.id}
                         className={cx('photo', selected ? 'selected' : null)}
                         style={style}
                         onClick={(e) => { e.stopPropagation(); dispatch(pickById(photo.id)) }} >
                    </div>
                  );
                })}
              </div>
            </div>
          </div>
        </div>
        <div className="right" onClick={() => dispatch(flipRight())}></div>
      </div>
    );
  }
}

export default connect(
  (state, ownProps) => ({
    state: state.photoViewer.state,
    ownProps
  })
)(PhotoViewer);
