// WARNING : though the widget is named EventsFeed, the API method for it is `Routes.api_web_feedbacks_path`.

import moment from "moment";
import Immutable from "immutable";

class Feedback extends Immutable.Record({
  id: -1,
  dreamer: {},
  initiator: {},
  resource: {
    type: "comment"
  },
  action: "",
  created_at: moment()
}) { }

export class State extends Immutable.Record({
  currentPage: 1,
  isLoadStarted: false,
  feedbacks: Immutable.List()
}) {
  handleLoadEventsSuccess(response) {
    const collection = response.feedbacks.map((p) => new Feedback(p));

    return this
      .set("feedbacks", Immutable.fromJS(collection))
      .set("currentPage", response.meta.page)
      .set('isLoadStarted', false);
  }

  handleLoadNextEventsSuccess(response) {
    const collection = response.feedbacks.map((p) => new Feedback(p));

    if (collection.length > 0) {
      const currentIds = this.feedbacks.map((d) => d.get('id'));

      const adds = Immutable.fromJS(collection)
        .filter((d) => !currentIds.contains(d.get('id')));

      return this.update("feedbacks", (d) => d.concat(adds))
        .set("currentPage", response.meta.page)
        .set("isLoadStarted", false);
    }

    return this.set('isLoadStarted', false);
  }
}
