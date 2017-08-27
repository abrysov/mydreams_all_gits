import Routes from "routes";
import React from 'react';
import { connect } from 'react-redux';

import {
  loadUpdates,
  loadNextUpdates
} from "../Actions";

import BodyInfinityScroll from "lib/components/BodyInfinityScroll";

import Update from "./Update";

class Root extends React.Component {
  componentDidMount() {
    this.props.dispatch(loadUpdates());
  }

  render() {
    const { currentUser, state, dispatch } = this.props;

    const {
      isLoadStarted,
      updates
    } = state;

    if (updates.size > 0) {

      return (
        <BodyInfinityScroll className="feed-container"
                            isLoading={state.isLoadStarted}
                            onScrollEnd={(e) => dispatch(loadNextUpdates())}>
          {updates.map(this.renderUpdate.bind(this))}
        </BodyInfinityScroll>
      );

    } else {

      return (
        <div className="feed-container">
          <div className="info">Нет обновлений</div>
        </div>
      );

    }
  }

  renderUpdate(update) {
    const updateJs = update.toJS();
    return <Update key={updateJs.id} {...updateJs} />
  }
}

export default connect(
  (state, ownProps) => ({
    state: state.updatesFeed,
    currentUser: state.user.user
  })
)(Root);
