import { request, getJson, requestJson }  from 'lib/ajax';
import { createAction } from 'redux-actions';
import { push } from 'react-router-redux';

import Constants from 'Constants';

import {
  animateBodyScrollTop
} from "lib/animations";

import {
  buildApiCertificatesUrl
} from "lib/apiUrlsBuilders";

const _loadCertificatesStart = createAction(Constants.CERTIFICATES_LIST.LOAD_CERTIFICATES_START);
const _loadCertificatesSuccess = createAction(Constants.CERTIFICATES_LIST.LOAD_CERTIFICATES_SUCCESS);
const _loadNextCertificatesSuccess = createAction(Constants.CERTIFICATES_LIST.LOAD_NEXT_CERTIFICATES_SUCCESS);
const _loadCertificatesFailed = createAction(Constants.CERTIFICATES_LIST.LOAD_CERTIFICATES_FAILED);

export const loadCertificates = (dreamerId) => (dispatch, getState) => {
  const state = getState();
  if (state.certificatesList.certificates.isLoadStarted) { return; }

  animateBodyScrollTop();

  dispatch(_loadCertificatesStart());

  const url = buildApiCertificatesUrl(dreamerId, state.routing.locationBeforeTransitions.query, 1);

  getJson(url)
    .then(
      (r) => dispatch(_loadCertificatesSuccess(r)),
      (xhr, status, error) => dispatch(_loadCertificatesFailed())
    );
};

export const loadNextCertificates = (dreamerId) => (dispatch, getState) => {
  const state = getState();
  if (state.certificatesList.certificates.isLoadStarted) { return; }

  const newPage = state.certificatesList.certificates.currentPage + 1;

  dispatch(_loadCertificatesStart());

  const url = buildApiCertificatesUrl(dreamerId, state.routing.locationBeforeTransitions.query, newPage);

  getJson(url)
    .then(
      (r) => dispatch(_loadNextCertificatesSuccess(r)),
      (xhr, status, error) => dispatch(_loadCertificatesFailed())
    );
};