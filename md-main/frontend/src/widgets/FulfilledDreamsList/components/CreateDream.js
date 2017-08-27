import React from 'react';
import { connect } from 'react-redux';

import cx from "classnames";

import ContentEditable from "lib/components/ContentEditable";
import ImageCropperModal from "lib/components/ImageCropperModal";
import FileUpload from "lib/components/FileUpload";

import {
  handleCloseDreamClick,

  handleSaveImageCropperModal,
  handleCloseImageCropperModal,

  handleFieldChange,
  handleSelectPhoto,

  handleAddDream
} from "../Actions";

class CreateDream extends React.Component {
  resizeModal() {
    var m = document.querySelector('.create-dream-modal');
    var page = document.querySelector('.row-page');
    var colWidth = document.querySelector('.col-right').clientWidth;
    var headerHeight = document.querySelector('.header-group').clientHeight;
    m.style.width = document.querySelector('.content-body').clientWidth + colWidth + 'px';
    m.style.left = page.offsetLeft + colWidth + 'px';
    m.style.top = headerHeight + 'px';
    m.style.height = window.innerHeight - headerHeight + 'px';
  }

  componentDidMount() {
    window.addEventListener('resize', this.resizeModal);
    this.resizeModal();
  }

  componentWillUnmount() {
    window.removeEventListener('resize', this.resizeModal);
  }

  addDream() {
    const state = this.props.state;
    if (!state.formData.title) return false;
    if (!state.formData.description) return false;
    if (!state.formData.restriction_level) return false;
    if (!state.formData.photo) return false;
    if (!state.formData.crop) return false;
    this.props.dispatch(handleAddDream());
  }

  render() {
    const { state, dispatch }  = this.props;
    const {
      isImageCropperModalOpened,
      isVisible,
      formData
    } = state;

    if (isVisible) {
      document.body.classList.add('scroll-disabled');
    } else {
      document.body.classList.remove('scroll-disabled');
    }

    const restrictionLevel = formData.restriction_level;

    const classes = cx("modal create-dream-modal", { visible: isVisible });
    const pictureStyles = formData.croppedPhoto ? {
      backgroundImage: `url(${formData.croppedPhoto})`
    } : {};

    return (
      <div className={classes}>
        { isImageCropperModalOpened ?
          <ImageCropperModal
            type="dream"
            image={formData.photoDataURI}
            onSave={(e) => dispatch(handleSaveImageCropperModal(e))}
            onClose={(e) => dispatch(handleCloseImageCropperModal(e))} />
          : ""}
        <div className="header">
          <div className="content">
            <h2>Добавить сбывшуюся Мечту</h2>
          </div>
          <div className="close" onClick={(e) => dispatch(handleCloseDreamClick())}></div>
        </div>
        <div className="body">
          <div className="options">
            <label htmlFor="" className="filter access">
              <span>Кто может видеть эту Мечту</span>
              <span className="select">
                <select onChange={(e) => dispatch(handleFieldChange('restriction_level', e))}>
                  <option value="public" selected={restrictionLevel === 'public'}>Все</option>
                  <option value="friends" selected={restrictionLevel === 'friends'}>Я и мои друзья</option>
                  <option value="private" selected={restrictionLevel === 'private'}>Только Я</option>
                </select>
              </span>
            </label>
            <label htmlFor="" className="filter access">
              <span>Когда Ваша Мечта сбылась?</span>
            </label>
          </div>
          <div className="card-wrapper">
            <ul className="description-list">
              <li className="photo">
                <span>
                  Фото Мечты
                  <span className="asterisk">*</span>
                </span>
              </li>
              <li className="name">
                <span>
                  Название Мечты
                  <span className="asterisk">*</span>
                </span>
              </li>
              <li className="desc">
                <span>
                  Описание Мечты
                  <span className="asterisk">*</span>
                </span>
              </li>
            </ul>
            <div className="card">
              <div className="front">
                <div className="label green">MyDreams</div>
                <div className="picture filearea icon" style={pictureStyles}>
                  <FileUpload onSelect={(e) => dispatch(handleSelectPhoto(e))} />
                </div>
                <div className="description">
                  <ContentEditable element="h3" onChange={(e) => dispatch(handleFieldChange('title', e))} eraseOnClick>
                    Введите название
                  </ContentEditable>
                  <ContentEditable element="h5" onChange={(e) => dispatch(handleFieldChange('description', e))} eraseOnClick>
                    Детально опишите
                    <br />
                    Вашу Мечту
                  </ContentEditable>
                </div>
                <div className="reactions">
                  <div className="icon-text like">
                    <div className="icon reaction"></div>
                    <span className="text">0</span>
                  </div>
                  <div className="icon-text in-progress">
                    <div className="icon reaction"></div>
                    <span className="text">0</span>
                  </div>
                  <div className="icon-text reaction comments">
                    <div className="icon"></div>
                    <span className="text">0</span>
                  </div>
                </div>
              </div>
            </div>
            <div className="button accept green" onClick={this.addDream.bind(this)}>Добавить</div>
          </div>
        </div>
      </div>
    );
  }
}

export default connect(
  (state, ownProps) => ({
    state: state.fulfilledDreamsList.createDream,
    location: ownProps.location
  })
)(CreateDream);
