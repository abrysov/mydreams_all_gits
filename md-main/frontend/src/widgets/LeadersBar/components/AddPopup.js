import React from "react";
import { connect } from 'react-redux';
import { getJson } from 'lib/ajax';

import {
  addPhoto,
  closeAddModal
} from "../Actions";

class AddPopup extends React.Component {
  constructor(props) {
    super(props);
    this.state = { photos: [], selectedPhotoId: -1 };
  }

  componentWillReceiveProps(newProps) {
    if (newProps.state.isModalOpened && !this.props.state.isModalOpened) {
      getJson(Routes.api_web_profile_photos_path())
        .then((r) => { console.log(r); this.setState({ photos: r.photos }) });
    }
  }

  render() {
    const { state, dispatch } = this.props;
    if (!state.isModalOpened) return null;

    const { photos, selectedPhotoId } = this.state;

    const onPhotoClick = (id) => (e) => this.setState({ selectedPhotoId: id });

    const canSubmit = selectedPhotoId != -1;

    return (
      <div className="popup-container">
        <div className="popup avatar-select">
          <div className="header-title">
            Попасть в фотоленту
            <div className="close purple" onClick={() => dispatch(closeAddModal())}></div>
          </div>
          <h4>Это бесплатно</h4>
          <div className="avatar-list">
            {photos.map((p) => {
              return (
                <div
                  key={p.id}
                  className={`avatar-wrapper ${p.id == selectedPhotoId ? 'selected' : ''}`}
                  onClick={onPhotoClick(p.id)}>
                  <div className="avatar size-m">
                    <img src={p.preview} />
                  </div>
                </div>
                );
            })}
          </div>
          <div className="textarea-wrapper">
            <textarea ref="text" className="normal" placeholder="Напишите свое приветствие" rows="4"></textarea>
          </div>
          <button disabled={!canSubmit} className="blue accent" onClick={this.onSubmit.bind(this)}>Готово</button>
        </div>
      </div>
    );
  }

  onSubmit() {
    const text = this.refs.text.value;
    const photoId = this.state.selectedPhotoId;

    this.props.dispatch(addPhoto(photoId, text));
  }
}

export default connect(
  (state) => ({
    state: state.leadersBar,
  })
)(AddPopup);

