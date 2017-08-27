// WARNING : though the widget is named EventsFeed, the API method for it is `Routes.api_web_feedbacks_path`.

import Routes from "routes";
import React from 'react';
import { connect } from 'react-redux';

import {
  loadEvents,
  loadNextEvents
} from "../Actions";

import BodyInfinityScroll from "lib/components/BodyInfinityScroll";

import Event from "./Event";

class Root extends React.Component {
  componentDidMount() {
    this.props.dispatch(loadEvents());
  }

  render() {
    const { currentUser, state, dispatch } = this.props;

    const {
      isLoadStarted,
      feedbacks
    } = state;

    if (feedbacks.size > 0) {

      return (
        <BodyInfinityScroll className="feed-container"
                            isLoading={state.isLoadStarted}
                            onScrollEnd={(e) => dispatch(loadNextEvents())}>
          {feedbacks.map(this.renderEvent.bind(this))}
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

  renderEvent(event) {
    const eventJs = event.toJS();
    return <Event key={eventJs.id} {...eventJs} />
  }
}

export default connect(
  (state, ownProps) => ({
    state: state.eventsFeed, // TODO
    currentUser: state.user.user
  })
)(Root);
