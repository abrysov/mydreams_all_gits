import Immutable from "immutable";

const initialState = {
  dream: Immutable.Map(),
  isLoadStarted: false,
  isEditing: false,
  oldDreamValues: Immutable.Map(),
  updatedPhoto: {
    rect: {},
    photo: null
  }
};

export class State extends Immutable.Record(initialState) {
  handleLoadDreamStart() {
    return this.set('isLoadStarted', true);
  }

  handleLoadDreamFailed() {
    return this.set('isLoadStarted', false);
  }

  handleLoadDreamSuccess(response) {
    return this
      .set('dream', Immutable.fromJS(response.dream))
      .set('isLoadStarted', false);
  }

  handleStartEdit() {
    return this.setIn(['oldDreamValues', 'title'], this.dream.get('title'))
                .setIn(['oldDreamValues', 'description'], this.dream.get('description'))
                .setIn(['oldDreamValues', 'photo'], this.dream.get('photo'))
                .set('isEditing', true);
  }

  handleCancelEdit() {
    return this.setIn(['dream', 'title'], this.oldDreamValues.get('title'))
                .setIn(['dream', 'description'], this.oldDreamValues.get('description'))
                .setIn(['dream', 'photo'], this.oldDreamValues.get('photo'))
                .set('isEditing', false);
  }

  handlePhotoChange({ photo, rect, croppedDataURI }) {
    return this.setIn(['dream', 'photo', 'large'], croppedDataURI)
        .set('updatedPhoto', { rect, photo });
  }

  handleSaveDreamSuccess(response) {
    return this.setIn(['dream', 'title'], response.dream.title)
               .setIn(['dream', 'description'], response.dream.description)
               .setIn(['dream', 'photo'], response.dream.photo)
               .set('oldDreamValues', Immutable.Map())
               .set('isEditing', false)
               .set('updatedPhoto', { rect: {}, photo: null });
  }

  handleFieldChange({ name, value }) {
    return this.setIn(['dream', name], value);
  }
}

