import React from "react";
import { connect } from 'react-redux';

import cx from "classnames";

import {
  closeModal,
  handleUpClick,
  handleDownClick
} from "../Actions";

import DP from "presenters/Dreamer";

class Root extends React.Component {
  render() {
    const { state, dispatch } = this.props;

    const totalLikes = state.getTotal();
    const visibleLikes = state.getVisibleLikes();
    const isUpEnabled = state.isUpButtonEnabled();
    const isDownEnabled = state.isDownButtonEnabled();

    if (!state.isOpened) return null;

    return (
      <div className="popup-container">
        <div className="popup popup-likes popup-label red">
          <div className="close" onClick={() => dispatch(closeModal())}></div>
          <div className="header">
            <div className="icon like"></div>
            <h3>Понравилось</h3>
            <h4> <b>{totalLikes}</b> Мечтателям </h4>
          </div>
          <div className="like-list">
            <div
              className={`btn top ${!isUpEnabled ? 'disabled': ''}`}
              onClick={() => dispatch(handleUpClick())}></div>
            <div className="mask">
              <div className="tape" style={{marginTop: '-1px'}}>
                {visibleLikes.map((l) => {
                  const dreamer = l.dreamer;
                  return (
                    <div className="user-card">
                      <div className="avatar size-s">
                        <img alt="avatar" src={DP.avatar(dreamer, 'small')} />
                      </div>
                      <div className="description">
                        <a href={DP.url(dreamer)}>{DP.fullName(dreamer)}</a>
                        <div className="icon-text">
                          <div className={`icon size-8 ${DP.gender(dreamer)}`}></div>
                          <span className="text">{DP.locationInfo(dreamer)}</span>
                        </div>
                      </div>
                    </div>
                  );
                })}
              </div>
            </div>
            <div className={`btn bottom ${!isDownEnabled ? 'disabled': ''}`}
              onClick={() => dispatch(handleDownClick())}></div>
          </div>
        </div>
      </div>
    );
  }
}

export default connect(
  (state, ownProps) => ({
    state: state.likesModal
  })
)(Root);
