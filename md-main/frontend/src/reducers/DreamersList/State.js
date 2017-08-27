import Immutable from "immutable";

export class WidgetParams extends Immutable.Record({
  type: "",
  dreamerId: -1
}) {}

const initialState = {
  widgetParams: new WidgetParams({}),
  dreamers: [],
  currentPage: 1,
  isLoadStarted: false
};

export class State extends Immutable.Record(initialState) {
  isFriendshipWidget() {
    return this.widgetParams.type == "dreambook_friendships";
  }

  getType() {
    return this.widgetParams.type;
  }

  getDreamerId() {
    return this.widgetParams.dreamerId;
  }

  getDreamerIdxById(id) {
    return this.dreamers.findIndex((d) => d.get('id') == id);
  }

  handleInitWidget(params) {
    return this.set("widgetParams", new WidgetParams(params));
  }

  handleLoadDreamersSuccess(response) {
    const key = this.isFriendshipWidget() ? "friendship_requests" : "dreamers";
    return this
      .set("dreamers", Immutable.fromJS(response[key]))
      .set("isLoadStarted", false);
  }

  handleLoadNextDreamersSuccess(response) {
    const key =  this.isFriendshipWidget() ? "friendship_requests" : "dreamers";
    if (response[key].length > 0) {
      const currentDreamsIds = this.dreamers.map((d) => d.get('id'));

      const newRecords = Immutable.fromJS(response[key])
      .filter((d) => !currentDreamsIds.contains(d.get('id')));

      return this.update("dreamers", (d) => d.concat(newRecords))
        .set("currentPage", response.meta.page)
        .set("isLoadStarted", false);
    }
    return this.set('isLoadStarted', false);
  }

  handleAddFriendClick(id) {
    return this.setIn(['dreamers', this.getDreamerIdxById(id), 'i_friend'], true);
  }

  handleRemoveFriendClick(id) {
    return this.setIn(['dreamers', this.getDreamerIdxById(id), 'i_friend'], false);
  }

  handleApproveFriendClick(id) {
    return this.removeIn(['dreamers', this.getDreamerIdxById(id)]);
  }

  handleRejectFriendClick(id) {
    return this.removeIn(['dreamers', this.getDreamerIdxById(id)]);
  }
}
