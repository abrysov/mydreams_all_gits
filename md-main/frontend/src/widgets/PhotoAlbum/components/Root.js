import React from "react";
import { connect } from "react-redux";

import BodyInfinityScroll from "lib/components/BodyInfinityScroll";

import {
  loadPhotos,
  loadNextPhotos,
  showPhoto
} from "../Actions";

class PhotoAlbum extends React.Component {
  componentDidMount() {
    this.props.dispatch(loadPhotos(this.props.route.userId));
  }

  render() {
    const {
      dispatch,
      state
    } = this.props;

    return (
      <BodyInfinityScroll
        className="photoalbum"
        isLoading={state.isLoadStarted}
        onScrollEnd={(e) => dispatch(loadNextPhotos(this.props.route.userId))} >

        { state.photos.map((photo) => {
          photo = photo.toJSON();
          let style = { backgroundImage: 'url(' + photo.preview + ')' };
          return (
            <div key={photo.id}
                 className="photo"
                 style={style}
                 onClick={() => dispatch(showPhoto({
                    photoId: photo.id,
                    photos: state.photos,
                    currentPage: state.currentPage,
                    dreamerId: this.props.route.userId,
                    canUploadNext: true
                 }))} >
            </div>
          );
        })}

      </BodyInfinityScroll>
    );
  }

  componentWillReceiveProps(newProps) {
    const newQuery = newProps.location.query;
    const oldQuery = this.props.location.query;
    if (!_.isEqual(oldQuery, newQuery)) {
      newProps.dispatch(loadPhotos(this.props.route.userId));
    }
  }
}

export default connect(
  (state, ownProps) => ({
    state: state.photoAlbum.photos,
    ownProps
  })
)(PhotoAlbum);
