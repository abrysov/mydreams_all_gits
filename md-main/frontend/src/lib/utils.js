export default {
  bodyScroll(t = true) {
    document.body.classList[t ? 'remove' : 'add']('scroll-disabled');
  },
  isValidId(id) {
    return id > -1 && id !== null;
  }
};
