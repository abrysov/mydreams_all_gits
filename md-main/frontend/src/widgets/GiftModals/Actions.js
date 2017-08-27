import Routes from "routes";
import { request, getJson, requestJson }  from 'lib/ajax';
import { createAction } from 'redux-actions';

import Constants from 'Constants';

export const handleClose = createAction(Constants.GIFT_MODALS.CLOSE);
