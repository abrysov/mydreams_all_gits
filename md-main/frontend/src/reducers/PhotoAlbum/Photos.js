import Immutable from "immutable";
import { handleActions } from "redux-actions";
import Constants from "Constants";

const initialState = {
  isLoadStarted: false,
  photos: [],
  currentPage: 1
};

export class State extends Immutable.Record(initialState) {}

export default handleActions({
  [Constants.PHOTO_ALBUM.LOAD_PHOTOS_START]: (state:State, action) => {
    return state.set('isLoadStarted', true);
  },
  [Constants.PHOTO_ALBUM.LOAD_PHOTOS_FAILED]: (state:State, action) => {
    return state.set('isLoadStarted', false);
  },
  [Constants.PHOTO_ALBUM.LOAD_PHOTOS_SUCCESS]: (state:State, action) => {
    return state.set('photos', Immutable.fromJS(action.payload.photos))
                .set('currentPage', action.payload.meta.page)
                .set('isLoadStarted', false);
  },
  [Constants.PHOTO_ALBUM.LOAD_NEXT_PHOTOS_SUCCESS]: (state:State, action) => {
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
  },

  [Constants.PHOTO_ALBUM.UPLOAD_PHOTO_SUCCESS]: (state:State, action) => {
    if (action.payload.photo) {
      const newPhoto = Immutable.fromJS([action.payload.photo]);

      return state.update('photos', (d) => newPhoto.concat(d))
                  .set('currentPage', action.payload.meta.page);
    }
  }
}, new State());