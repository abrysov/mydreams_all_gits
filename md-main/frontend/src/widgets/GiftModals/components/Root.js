import Routes from "routes";
import React from "react";
import { connect } from "react-redux";

import cx from "classnames";

import BuyMarks from "./Marks/Buy";
import PresentMarks from "./Marks/Present";

import BuyGifts from "./Gifts/Buy";
import PresentGifts from "./Gifts/Present";

class Root extends React.Component {
  render() {
    const { dispatch, state } = this.props;
    const { isModalOpened, modalType, isForCurrentUser } = state;

    if (!isModalOpened) { return null; }

    return (
      <div className="popup-container">
        {this.renderModal(modalType, isForCurrentUser)}
      </div>
    );
  }

  renderModal(modalType, isForCurrentUser) {
    switch(modalType) {
      case 'gifts':
        return this.renderGiftsModal(isForCurrentUser);
      case 'marks':
        return this.renderMarksModal(isForCurrentUser);
    }
  }

  renderGiftsModal(isForCurrentUser) {
    const { dispatch, state } = this.props;

    if (isForCurrentUser) {
        return <BuyGifts state={state} dispatch={dispatch} />;
    } else {
      return <PresentGifts state={state} dispatch={dispatch} />;
    }
  }

  renderMarksModal(isForCurrentUser) {
    const { dispatch, state } = this.props;

    if (isForCurrentUser) {
        return <BuyMarks state={state} dispatch={dispatch} />;
    } else {
      return <PresentMarks state={state} dispatch={dispatch} />;
    }
  }
}

export default connect(
  (state, ownProps) => ({
    state: state.giftModals,
    ownProps
  })
)(Root);
