import Immutable from "immutable";
import { handleActions } from "redux-actions";
import Constants from "Constants";

const initialState = {
  isVisible: false,
  currentPhotoId: -1,
  photos: [],

  canUploadNext: false,
  isLoadStarted: false,
  currentPage: -1,
  dreamerId: -1
};

export class State extends Immutable.Record(initialState) {}

export default handleActions({
  [Constants.PHOTO_VIEWER.SHOW_PHOTO]: (state:State, action) => {
    return state.set('isVisible', true)
                .set('currentPhotoId', action.payload.photoId)
                .set('photos', Immutable.fromJS(action.payload.photos))
                .set('currentPage', action.payload.currentPage)
                .set('canUploadNext', action.payload.canUploadNext || false)
                .set('dreamerId', action.payload.dreamerId);
  },
  [Constants.PHOTO_VIEWER.HIDE_PHOTO]: (state:State, action) => {
    return new State(); // TODO : is it legal?
  },

  [Constants.PHOTO_VIEWER.FLIP_LEFT]: (state:State, action) => {
    const currentIndex = state.photos.findIndex((p) => p.get('id') === state.currentPhotoId);
    const newIndex = (currentIndex === 0) ? state.photos.size - 1 : currentIndex - 1;
    const newId = state.getIn(['photos', newIndex, 'id']);
    return state.set('currentPhotoId', newId);
  },
  [Constants.PHOTO_VIEWER.FLIP_RIGHT]: (state:State, action) => {
    const currentIndex = state.photos.findIndex((p) => p.get('id') === state.currentPhotoId);
    const newIndex = (currentIndex === state.photos.size - 1) ? 0 : currentIndex + 1;
    const newId = state.getIn(['photos', newIndex, 'id']);
    return state.set('currentPhotoId', newId);
  },

  [Constants.PHOTO_VIEWER.PICK_BY_ID]: (state:State, action) => {
    return state.set('currentPhotoId', action.payload);
  },

  [Constants.PHOTO_VIEWER.LOAD_PHOTOS_START]: (state:State, action) => {
    return state.set('isLoadStarted', true);
  },
  [Constants.PHOTO_VIEWER.LOAD_PHOTOS_FAILED]: (state:State, action) => {
    return state.set('isLoadStarted', false);
  },
  [Constants.PHOTO_VIEWER.LOAD_PHOTOS_SUCCESS]: (state:State, action) => {
    if (action.payload.photos.length > 0) {
      const currentPhotosIds = state.photos.map((d) => d.get('id'));

      const addPhotos = Immutable.fromJS(action.payload.photos)
        .filter((d) => !currentPhotosIds.contains(d.get('id')));

      return state.update('photos', (d) => d.concat(addPhotos))
                  .set('currentPage', action.payload.meta.page)
                  .set('isLoadStarted', false);
    } else {
      return state.set('isLoadStarted', false);
    }
  }
}, new State());
