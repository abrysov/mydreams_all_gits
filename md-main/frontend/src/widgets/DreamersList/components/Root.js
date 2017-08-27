import _ from "lodash";
import React from 'react';
import { connect } from 'react-redux';

import BodyInfinityScroll from "lib/components/BodyInfinityScroll";
import DreamerCard from "./DreamerCard";
import FriendshipDreamerCard from "./FriendshipDreamerCard";

import {
  loadDreamers,
  loadNextDreamers,
  handleSendMessageClick,
  handleAddFriendClick,
  handleRemoveFriendClick,
  handleApproveFriendClick,
  handleRejectFriendClick
} from "../Actions";

class Root extends React.Component {
  componentDidMount() {
    this.props.dispatch(loadDreamers());
  }

  render() {
    const { state, dispatch } = this.props;

    const dreamerActions = {
      onSendMessageClick: (id) => dispatch(handleSendMessageClick(id)),
      onAddFriendClick: (id) => dispatch(handleAddFriendClick(id)),
      onRemoveFriendClick: (id) => dispatch(handleRemoveFriendClick(id)),
    };

    const friendshipDreamerActions = {
      onApproveFriendClick: (id) => dispatch(handleApproveFriendClick(id)),
      onRejectFriendClick: (id) => dispatch(handleRejectFriendClick(id)),
    };

    return (
      <BodyInfinityScroll
        className="card-list"
        isLoading={state.isLoadStarted}
        onScrollEnd={(e) => dispatch(loadNextDreamers())}>

        {state.dreamers.map((dreamer) => {
          const d = dreamer.toJS();

          if (state.isFriendshipWidget()) {
            return <FriendshipDreamerCard {...d} {...friendshipDreamerActions} key={`dreamer-${d.id}`} />
          } else {
            return <DreamerCard {...d} {...dreamerActions} key={`dreamer-${d.id}`} />
          }
        })}

      </BodyInfinityScroll>
    );
  }

  componentWillReceiveProps(newProps) {
    const newQuery = newProps.location.query;
    const oldQuery = this.props.location.query;
    if (!_.isEqual(oldQuery, newQuery)) {
      newProps.dispatch(loadDreamers());
    }
  }
}

export default connect(
  (state, ownProps) => ({
    state: state.dreamersList,
    ownProps
  })
)(Root);
