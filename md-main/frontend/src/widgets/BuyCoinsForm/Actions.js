import Routes from "routes";
import { request, getJson, requestJson }  from 'lib/ajax';
import { createAction } from 'redux-actions';

import Constants from 'Constants';

const _loadProductsSuccess = createAction(Constants.BUY_COINS_FORM.LOAD_PRODUCTS_SUCCESS);
export const loadProducts = () => (dispatch, getState) => {
  getJson(Routes.api_web_products_path({ special: true }))
    .then((r) => dispatch(_loadProductsSuccess(r)));
}

export const handleFieldChange = (name, value) => (dispatch, getState) => {
  dispatch(createAction(Constants.BUY_COINS_FORM.HANDLE_FIELD_CHANGE)({ name, value }));
};
