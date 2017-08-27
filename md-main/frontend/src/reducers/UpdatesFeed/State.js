import moment from "moment";
import Immutable from "immutable";

class Update extends Immutable.Record({
  id: -1,
  dreamer: {},
  initiator: {},
  resource: {
    type: "dream"
  },
  action: "",
  created_at: moment()
}) { }

export class State extends Immutable.Record({
  currentPage: 1,
  isLoadStarted: false,
  updates: Immutable.List()
}) {
  handleLoadUpdatesSuccess(response) {
    const collection = response.updates.map((p) => new Update(p));

    return this
      .set("updates", Immutable.fromJS(collection))
      .set("currentPage", response.meta.page)
      .set('isLoadStarted', false);
  }

  handleLoadNextUpdatesSuccess(response) {
    const collection = response.updates.map((p) => new Update(p));

    if (collection.length > 0) {
      const currentIds = this.updates.map((d) => d.get('id'));

      const adds = Immutable.fromJS(collection)
                        .filter((d) => !currentIds.contains(d.get('id')));

      return this.update("updates", (d) => d.concat(adds))
                  .set("currentPage", response.meta.page)
                  .set("isLoadStarted", false);
    }

    return this.set('isLoadStarted', false);
  }
}
