import Immutable from "immutable";
import { handleActions } from "redux-actions";
import Constants from "Constants";

const initialState = {
  isLoadStarted: false,
  certificates: [],
  currentPage: 1
};

export class State extends Immutable.Record(initialState) {}

export default handleActions({
  [Constants.CERTIFICATES_LIST.LOAD_CERTIFICATES_START]: (state:State, action) => {
    return state.set('isLoadStarted', true);
  },
  [Constants.CERTIFICATES_LIST.LOAD_CERTIFICATES_FAILED]: (state:State, action) => {
    return state.set('isLoadStarted', false);
  },
  [Constants.CERTIFICATES_LIST.LOAD_CERTIFICATES_SUCCESS]: (state:State, action) => {
    return state.set('certificates', Immutable.fromJS(action.payload.certificates))
                .set('currentPage', action.payload.meta.page)
                .set('isLoadStarted', false);
  },
  [Constants.CERTIFICATES_LIST.LOAD_NEXT_CERTIFICATES_SUCCESS]: (state:State, action) => {
    if (action.payload.certificates.length > 0) {
      const currentCertificatesIds = state.certificates.map((d) => d.get('id'));

      const addCertificates = Immutable.fromJS(action.payload.certificates)
        .filter((d) => !currentCertificatesIds.contains(d.get('id')));

      return state.update('certificates', (d) => d.concat(addCertificates))
                  .set('currentPage', action.payload.meta.page)
                  .set('isLoadStarted', false);
    } else {
      return state.set('isLoadStarted', false);
    }
  }
}, new State());