import _ from "lodash";
import React from 'react';
import { connect } from 'react-redux';

import Dream from "lib/components/Dream";
import BodyInfinityScroll from "lib/components/BodyInfinityScroll";

import {
  loadDreams,
  loadNextDreams,
  handleCreateDreamClick,
  likeDream,
  unlikeDream
} from "../Actions";

class Root extends React.Component {
  componentDidMount() {
    this.props.dispatch(loadDreams(this.props.route.userId));
  }

  render() {
    const {
      dispatch,
      state,
      userState
    } = this.props;

    const userId = userState.getCached('id');

    const widgetType = this.props.route.widgetType;
    const widgetUserId = this.props.route.userId;

    const showCreateDreamButton = (widgetType === 'one_dreamer' && widgetUserId === userId);
    const noNameDream = (widgetType === 'one_dreamer');

    return (
      <BodyInfinityScroll
        className="card-list"
        isLoading={state.isLoadStarted}
        onScrollEnd={(e) => dispatch(loadNextDreams(widgetUserId))}>

        { showCreateDreamButton === false ?
          '' :
          (<div className="card add-dream" onClick={(e) => dispatch(handleCreateDreamClick())}>
            <div className="front">
              <div className="plus"></div>
              <div className="title">{`Добавить исполненную мечту`}</div>
            </div>
          </div>)
        }

        {state.dreams.map((dream) => {
          const d = dream.toJS();
          return <Dream key={`dream-${d.id}`}
                        labelClass="green"
                        noNameMode={noNameDream}
                        onLike={(id) => dispatch(likeDream(id))}
                        onUnlike={(id) => dispatch(unlikeDream(id))}
                        {...d} />
        })}
      </BodyInfinityScroll>
    );
  }

  componentWillReceiveProps(newProps) {
    const newQuery = newProps.location.query;
    const oldQuery = this.props.location.query;
    if (!_.isEqual(oldQuery, newQuery)) {
      newProps.dispatch(loadDreams(this.props.route.userId));
    }
  }
}

export default connect(
  (state, ownProps) => ({
    state: state.fulfilledDreamsList.dreams,
    userState: state.user,
    location: ownProps.location
  })
)(Root);
