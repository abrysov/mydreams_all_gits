import Routes from "routes";
import React from 'react';
import { connect } from 'react-redux';

import cx from "classnames";

import FileUpload from "lib/components/FileUpload";
import ImageCropperModal from "lib/components/ImageCropperModal";
import ContentEditable from "lib/components/ContentEditable";
import CertificatesList from "lib/components/CertificatesList";

import {
  loadCertificates,
  handleCertificateSelect,

  handleFieldChange,

  handleSelectPhoto,
  handleSaveImageCropperModal,
  handleCloseImageCropperModal,

  handleLaunchDream,
  handleAddDream,
  handleCloseBtnClick
} from "../Actions";

class Root extends React.Component {
  render() {
    const { state, dispatch }  = this.props;
    const {
      isImageCropperModalOpened,
      isVisible,
      certificates,
      currentCertificateId,
      formData
    } = state;

    const classes = cx('modal belive-in-dream-modal', { visible: isVisible });

    const hasCertificate = currentCertificateId > 0;
    const pictureStyles = formData.croppedPhoto ? {
      backgroundImage: `url(${formData.croppedPhoto})`,
      backgroundSize: 'cover'
    } : {};

    //TODO: Add some validation rules
    const canSubmitForm = true;

    if (isVisible) {
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
              <h2>Исполнить мечту</h2>
            </div>
            <div className="close" onClick={(e) => dispatch(handleCloseBtnClick())}></div>
          </div>
          <div className="body">
            <label className="filter access">
              <span>Кто может видеть эту Мечту</span>
              <div className="select">
                <select onChange={(e) => dispatch(handleFieldChange('restriction_level', e))}>
                  <option value="public">Все</option>
                  <option value="friends">Я и мои друзья</option>
                  <option value="private">Только Я</option>
                </select>
              </div>
            </label>
            <div className="envelope">
              <div className="corner left"></div>
              <div className="corner right"></div>
              <div className="back"></div>

              <div className="card-wrapper">
                <ul className="description-list">
                  <li className="status">
                    <span>Статус Мечты</span>
                  </li>
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
                    <div className="label default">MyDreams</div>
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
                    <div className="back"></div>
                  </div>
                </div>
              </div>
            </div>

            <hgroup>
              <h3>Выберите марку</h3>
              <h5>платно</h5>
            </hgroup>
            <p>
              Используя марки, Вы запускаете Мечту во Вселенную.
              <br />
              Каждая марка изменяет статус Мечты, в зависимости от количества запусков.
            </p>

            <CertificatesList
              certificates={certificates.toJS()}
              currentCertificateId={currentCertificateId}
              onMount={() => dispatch(loadCertificates())}
              onSelect={(id) => dispatch(handleCertificateSelect(id))} />

            { hasCertificate ?
              <button disabled={!canSubmitForm}
                className="yellow accent"
                onClick={(e) => dispatch(handleLaunchDream())}>
                Запустить Мечту во Вселенную
              </button>
              :
                <button disabled={!canSubmitForm}
                  className="gray accent"
                  onClick={(e) => dispatch(handleAddDream())}>
                  Добавить в Dreambook
                </button> }
                <br />
                <br />
                <br />
                <p>На Ваш E-mail придет уведомление</p>
              </div>
            </div>
      );
    } else {
      return <div className={classes} />;
    }
  }
}

export default connect(
  (state, ownProps) => ({
    state: state.createDream
  })
)(Root);

