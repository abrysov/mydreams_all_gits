import React from "react";
import { connect } from "react-redux";

import {
  loadAccountSettings,
  loadLanguages,
  changeAccountField,
  saveAccountSettings
} from "../Actions";

class Root extends React.Component {
  componentDidMount() {
    this.props.dispatch(loadAccountSettings());
    this.props.dispatch(loadLanguages());
  }

  render() {
    const {
      dispatch,
      state
    } = this.props;

    const d = state.settings.toJSON();

    return (
      <div className="settings-page">
        <div className="lang-select">
          <div className="flag rus"></div>
          <div className="title">Русский</div>
        </div>
        <div className="form">
          <label htmlFor="" className="title">
            <span className="name">E-mail:</span>
            <input type="text"
                   value={d.email}
                   onChange={(e) => dispatch(changeAccountField({
                     fieldName: 'email',
                     value: e.target.value
                   }))} />
          </label>
          <label htmlFor="" className="title">
            <span className="name">Пароль:</span>
            <input type="password"
                   value=""
                   onChange={(e) => dispatch(changeAccountField({
                     fieldName: 'current_password',
                     value: e.target.value
                   }))} />
          </label>
          <label htmlFor="" className="title">
            <span className="name">Новый пароль:</span>
            <input type="password"
                   value=""
                   onChange={(e) => dispatch(changeAccountField({
                     fieldName: 'password',
                     value: e.target.value
                   }))} />
          </label>
          <label htmlFor="" className="title">
            <span className="name">Подтвердите:</span>
            <input type="password"
                   value=""
                   onChange={(e) => dispatch(changeAccountField({
                     fieldName: 'password_confirmation',
                     value: e.target.value
                   }))} />
          </label>
        </div>
        <a href="#" className="delete-profile-btn">Временно удалить профиль</a>
        <hr />
        <button className="blue" onClick={() => dispatch(saveAccountSettings())}>Сохранить</button>
      </div>
    );
  }
}

export default connect(
  (state, ownProps) => ({
    state: state.userSettings.account,
    ownProps
  })
)(Root);
