import _ from "lodash";
import React from 'react';
import { connect } from 'react-redux';

import Dream from "lib/components/Dream";
import BodyInfinityScroll from "lib/components/BodyInfinityScroll";

import {
  loadDreams,
  loadNextDreams,
  likeDream,
  unlikeDream
} from "../Actions";

class Root extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      loadingActionsProps: {
        onlyMyDreams: this.props.route.onlyMyDreams,
        userId: this.props.route.userId
      }
    };
  }

  componentDidMount() {
    this.props.dispatch(loadDreams(this.state.loadingActionsProps));
  }

  render() {
    const {
      dispatch,
      dreamsState,
      onlyMyDreams
    } = this.props;

    return (
      <BodyInfinityScroll
        className="card-list"
        isLoading={dreamsState.isLoadStarted}
        onScrollEnd={(e) => dispatch(loadNextDreams(this.state.loadingActionsProps))}>
        {dreamsState.dreams.map((dream) => {
          const d = dream.toJS();
          return <Dream {...d} key={`dream-${d.id}`}
                               noNameMode={onlyMyDreams}
                               onLike={(id) => dispatch(likeDream(id))}
                               onUnlike={(id) => dispatch(unlikeDream(id))} />
          })}
      </BodyInfinityScroll>
    );
  }

  componentWillReceiveProps(newProps) {
    const newQuery = newProps.location.query;
    const oldQuery = this.props.location.query;
    if (!_.isEqual(oldQuery, newQuery)) {
      newProps.dispatch(loadDreams(this.state.loadingActionsProps));
    }
  }
}

export default connect(
  (state, ownProps) => ({
    dreamsState: state.dreamsList.dreams
  })
)(Root);
