import Immutable from "immutable";

class FormData extends Immutable.Record({
  title: "",
  description: "",
  restriction_level: "public", // public | private | friends
  came_true: false,

  photo: null,
  photoDataURI: null,
  crop: null,
  croppedPhoto: null
}) { }

const initialState = {
  isVisible: false,
  isImageCropperModalOpened: false,

  formData: new FormData(),

  certificates: Immutable.List(),
  currentCertificateId: -1,

};

export class State extends Immutable.Record(initialState) {
  handleLoadCertificatesSuccess(response) {
    return this.set('certificates', Immutable.fromJS(response.products));
  }
  handleCertificateSelect(id) {
    if (this.currentCertificateId == id) {
      return this.set('currentCertificateId', -1);
    }
    return this.set('currentCertificateId', id);
  }

  handleFieldChange(fieldName, value) {
    return this.setIn(['formData', fieldName], value);
  }

  handleSelectPhoto(data) {
    return this
      .setIn(['formData', 'photo'], data.file)
      .setIn(['formData', 'photoDataURI'], data.dataURI)
      .set('isImageCropperModalOpened', true);
  }

  handleSaveImageCropperModal({ croppedImage, rect }) {
    return this
      .setIn(['formData', 'crop'], rect)
      .setIn(['formData', 'croppedPhoto'], croppedImage)
      .set('isImageCropperModalOpened', false);
  }

  handleCloseImageCropperModal() {
    return this
      .setIn(['formData', 'photo'], null)
      .setIn(['formData', 'photoDataURI'], null)
      .setIn(['formData', 'croppedPhoto'], null)
      .set('isImageCropperModalOpened', false);
  }
}
