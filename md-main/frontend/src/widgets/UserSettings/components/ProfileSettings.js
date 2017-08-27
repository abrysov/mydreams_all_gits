import React from "react";
import { connect } from "react-redux";

import ImageCropperModal from "lib/components/ImageCropperModal";
import FileUpload from "lib/components/FileUpload";

import CountrySelect from "lib/components/CountrySelect";
import CitySelect from "lib/components/CitySelect";

import {
  loadProfileSettings,
  changeProfileField,
  handleSelectPhoto,
  handleSaveImageCropperModal,
  handleCloseImageCropperModal,
  saveProfileSettings
} from "../Actions";

class Root extends React.Component {
  componentDidMount() {
    this.props.dispatch(loadProfileSettings());
  }

  render() {
    const {
      dispatch,
      state
    } = this.props;

    const d = state.settings.toJSON();
    const avatarPreview = state.settings.croppedPhoto ? state.settings.croppedPhoto : state.currentAvatar;

    return (
      <div className="settings-page">
        { state.isImageCropperModalOpened ?
          <ImageCropperModal
            type="avatar"
            image={state.settings.photoDataURI}
            onSave={(e) => dispatch(handleSaveImageCropperModal(e))}
            onClose={(e) => dispatch(handleCloseImageCropperModal(e))} />
          : '' }
        <div className="avatar-wrapper">
          <div className="avatar size-xl filearea">
            <FileUpload onSelect={(e) => dispatch(handleSelectPhoto(e))} />
            <img src={avatarPreview} />
          </div>
          <div className="btn"></div>
        </div>
        <div className="form">
          <label htmlFor="" className="title">
            <span className="name">Имя:</span>
            <input type="text"
                   value={d.first_name}
                   onChange={(e) => dispatch(changeProfileField({
                     fieldName: 'first_name',
                     value: e.target.value
                   }))} />
          </label>
          <label htmlFor="" className="title">
            <span className="name">Фамилия:</span>
            <input type="text"
                   value={d.last_name}
                   onChange={(e) => dispatch(changeProfileField({
                     fieldName: 'last_name',
                     value: e.target.value
                   }))} />
          </label>
          <label htmlFor="" className="title">
            <span className="name">Пол:</span>
            <div className="select">
              <select onChange={(e) => dispatch(changeProfileField({
                     fieldName: 'gender',
                     value: e.target.value
                   }))}>
                <option value="male" defaultValue={(d.gender === 'male')}>Мужской</option>
                <option value="female" defaultValue={(d.gender === 'female')}>Женский</option>
              </select>
            </div>
          </label>
          <label htmlFor="" className="title">
            <span className="name">Дата рождения:</span>
            <input type="text"
                   value={d.birthday}
                   onChange={(e) => dispatch(changeProfileField({
                     fieldName: 'birthday',
                     value: e.target.value
                   }))} />
          </label>
          <label htmlFor="" className="title">
            <span className="name">Страна:</span>
            { d.countryId === null ?
              '' :
              <CountrySelect
                onChange={(country_id) => dispatch(changeProfileField({
                fieldName: 'countryId',
                value: country_id
              }))}
                value={d.countryId}/>
            }
          </label>
          <label htmlFor="" className="title">
            <span className="name">Город:</span>
            { d.countryId === null || d.cityId === null ?
              '' :
              <CitySelect
                country_id={d.countryId}
                onChange={(city_id) => dispatch(changeProfileField({
                fieldName: 'cityId',
                value: city_id
              }))}
                value={d.cityId}/>
            }
          </label>
        </div>
        <hr />
        <button className="blue" onClick={() => dispatch(saveProfileSettings())}>Сохранить</button>
      </div>
    );
  }
}

export default connect(
  (state, ownProps) => ({
    state: state.userSettings.profile,
    ownProps
  })
)(Root);
