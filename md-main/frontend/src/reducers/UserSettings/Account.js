import Immutable from "immutable";
import { handleActions } from "redux-actions";
import Constants from "Constants";

class AccountSettings extends Immutable.Record({
  language: '',
  email: '',
  current_password: '',
  password: '',
  password_confirmation: ''
}) { }

const initialState = {
  isProcessing: false,
  languagesList: [],
  settings: new AccountSettings()
};

export class State extends Immutable.Record(initialState) {}

export default handleActions({
  [Constants.USER_ACCOUNT_SETTINGS.LOAD_SETTINGS_START]: (state:State, action) => {
    return state.set('isProcessing', true);
  },
  [Constants.USER_ACCOUNT_SETTINGS.LOAD_SETTINGS_FAILED]: (state:State, action) => {
    return state.set('isProcessing', false);
  },
  [Constants.USER_ACCOUNT_SETTINGS.LOAD_SETTINGS_SUCCESS]: (state:State, action) => {
    const d = action.payload.dreamer;
    return state.setIn(['settings', 'email'], d.email)
                // .setIn(['settings', 'language'], d.language)
                .set('isProcessing', false);
  },

  [Constants.USER_ACCOUNT_SETTINGS.LOAD_LANGUAGES]: (state:State, action) => {
    return state.set('countriesList', action.payload.countries);
  },

  [Constants.USER_ACCOUNT_SETTINGS.CHANGE_FIELD]: (state:State, action) => {
    return state.setIn(['settings', action.payload.fieldName], action.payload.value);
  },

  [Constants.USER_ACCOUNT_SETTINGS.SAVE_PASSWORD_START]: (state:State, action) => {
    return state.set('isProcessing', true);
  },
  [Constants.USER_ACCOUNT_SETTINGS.SAVE_PASSWORD_FAILED]: (state:State, action) => {
    return state.set('isProcessing', false);
  },
  [Constants.USER_ACCOUNT_SETTINGS.SAVE_PASSWORD_SUCCESS]: (state:State, action) => {
    return state.set('isProcessing', false);
  },

  [Constants.USER_ACCOUNT_SETTINGS.SAVE_EMAIL_START]: (state:State, action) => {
    return state.set('isProcessing', true);
  },
  [Constants.USER_ACCOUNT_SETTINGS.SAVE_EMAIL_FAILED]: (state:State, action) => {
    return state.set('isProcessing', false);
  },
  [Constants.USER_ACCOUNT_SETTINGS.SAVE_EMAIL_SUCCESS]: (state:State, action) => {
    return state.set('isProcessing', false);
  }
}, new State());