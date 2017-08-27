import Immutable from "immutable";

const initialState = {
  isOpened: false,
  likes: [],
  page: 1,
  per: 10,
  displayPage: 1,
  displayPer: 5,
  totalCount: 0,
  totalPagesCount: 0,
  loadedPagesCount: 0,
  entityType: null,
  entityId: null
};

export class State extends Immutable.Record(initialState) {
  getTotal() {
    return this.totalCount;
  }

  getVisibleLikes() {
    // get likes displayPer * page -> displayPer * page + 1
    const startIdx = (this.displayPage - 1) * this.displayPer;
    const endIdx = startIdx + this.displayPer;
    return this.likes.slice(startIdx, endIdx);
  }

  isUpButtonEnabled() {
    return this.displayPage > 1;
  }

  isDownButtonEnabled() {
    return this.displayPage < this.totalCount / this.displayPer;
  }

  getLoadedPagesCount() {
    return this.likes.length / this.displayPer;
  }

  handleShowModal({ entityType, entityId }) {
    return this
              .set('entityType', entityType)
              .set('entityId', entityId);
  }

  handleSetPage(page) {
    return this.set('displayPage', page);
  }

  handleLoadLikesSuccess(response) {
    return this
      .set('likes', response.likes)
      .set('page', 1)
      .set('displayPage', 1)
      .set('totalCount', response.meta.total_count)
      .set('totalPagesCount', response.meta.pages_count)
      .set('isOpened', true);
  }

  handleLoadNextLikesSuccess(response) {
    return this
      .set('likes', this.likes.concat(response.likes))
      .set('page', response.meta.page)
      .set('displayPage', this.displayPage + 1)
      .set('totalCount', response.meta.total_count)
      .set('totalPagesCount', response.meta.pages_count);
  }
}
