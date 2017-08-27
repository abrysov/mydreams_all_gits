import Immutable from "immutable";

const initialState = {
  dreamer: Immutable.Map()
};

export class State extends Immutable.Record(initialState) {
}

