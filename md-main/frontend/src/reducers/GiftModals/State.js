import Immutable from "immutable";

const initialState = {
  isModalOpened: false,
  modalType: 'gifts', // gifts | marks
  isForCurrentUser: false,
  dream: null,
  dreamer: null
};

export class State extends Immutable.Record(initialState) {
  handleBuyMarks(dream) {
    return this.set('isModalOpened', true)
               .set('modalType', 'marks')
               .set('isForCurrentUser', true)
               .set('dream', dream);
  }

  handlePresentMarks(dream) {
    return this.set('isModalOpened', true)
               .set('modalType', 'marks')
               .set('isForCurrentUser', false)
               .set('dream', dream);
  }

  handleBuyGifts(dreamer) {
    return this.set('isModalOpened', true)
               .set('modalType', 'gifts')
               .set('isForCurrentUser', true)
               .set('dreamer', dreamer);
  }

  handlePresentGifts(dreamer) {
    return this.set('isModalOpened', true)
               .set('modalType', 'gifts')
               .set('isForCurrentUser', false)
               .set('dreamer', dreamer);
  }

  handleClose() {
    return new State();
  }
}
