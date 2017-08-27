import React from 'react';
import { connect } from 'react-redux';
import cx from "classnames";

import DP from "presenters/Dreamer";

import Background from "./Background";
import StatusField from "./StatusField";
import Avatar from "./Avatar";

import {
  loadDreamerInfo,
  handleSendMessageClick,
  handleUpdateStatus,
  handleAddFriendClick,
  handleRemoveFriendClick,
  handleBuyGift,
  handlePresentGift
} from "../Actions";

class Root extends React.Component {
  componentDidMount() {
    this.props.dispatch(loadDreamerInfo(this.props.dreamerId));
  }

  renderLeftButtons(dreamer) {
    const { dispatch } = this.props;
    if (this.isCurrentUser()) {
      return (
        <div className="left">
          <div className="button blue">Сменить фон</div>
          <div className="button blue circle gift" onClick={() => dispatch(handleBuyGift())}></div>
        </div>
      );
    } else {
      return (
        <div className="left">
          { dreamer.i_friend
            ? <div className="button blue"
              onClick={(e) => dispatch(handleRemoveFriendClick(dreamer.id))}>Удалить из друзей</div>
            : <div className="button blue"
              onClick={(e) => dispatch(handleAddFriendClick(dreamer.id))}>Добавить в друзья</div> }
            <div className="button blue circle gift" onClick={() => dispatch(handlePresentGift())}></div>
        </div>
      );
    }
  }

  renderRightButtons(dreamer) {
    const { dispatch } = this.props;
    if (this.isCurrentUser()) {
      return (
        <div className="right">
          <div className="button blue accent">Редактировать</div>
          <div className="button blue circle send"></div>
        </div>
      );
    } else {
      return (
        <div className="right">
          <div className="button blue accent"
            onClick={(e) => dispatch(handleSendMessageClick())}>Сообщение</div>
          <div className="button blue circle send"></div>
        </div>
      );
    }
  }

  isCurrentUser() {
    return this.props.state.dreamer.get('id') == this.props.currentUser.getCached('id');
  }

  render() {
    const { state, currentUser, dispatch } = this.props;
    const dreamer = state.dreamer.toJS();

    if (dreamer.id == 1) {
      return this.renderClub();
    } else {
      return this.renderUsual();
    }
  }

  renderClub() {
    const { state, currentUser, dispatch } = this.props;
    const dreamer = state.dreamer.toJS();

    return (
      <div className="header">
        { dreamer.dreambook_bg ?
        <Background dreamer={dreamer} isCurrentUser={this.isCurrentUser()} />
        : "" }

        <div className="dreamer-header club">
          { dreamer.avatar ?
            <Avatar dreamer={dreamer} isCurrentUser={this.isCurrentUser()} />
            : "" }
          <div className="row name">
            <div className="item">
              <h2 className="username vip">{dreamer.full_name}</h2>
            </div>
            <div className="item">
              <button className="purple" onClick={(e) => dispatch(handleSendMessageClick())}>Написать сообщение</button>
            </div>
          </div>

          <div className="row description">
            <div className="text">
              <StatusField
                text={dreamer.status}
                isCurrentUser={this.isCurrentUser()}
                onEnter={(text) => dispatch(handleUpdateStatus(text))} />
            </div>
            <div className="item">
              <div className="button purple circle send"></div>
            </div>
          </div>
        </div>
      </div>
    );
  }

  renderUsual() {
    const { state, currentUser, dispatch } = this.props;
    const dreamer = state.dreamer.toJS();

    return (
      <div className="header dreamer">
        { dreamer.dreambook_bg ?
        <Background dreamer={dreamer} isCurrentUser={this.isCurrentUser()} />
        : "" }

        <div className="dreamer-header">
          <div className="row">
            {this.renderLeftButtons(dreamer)}
            <div className="center">
              { dreamer.avatar ?
                <Avatar dreamer={dreamer} isCurrentUser={this.isCurrentUser()} />
                : "" }
              <h2>{dreamer.full_name}</h2>
              <h4>{DP.locationInfo(dreamer)}</h4>
            </div>
            {this.renderRightButtons(dreamer)}
          </div>

          <div className="description">
            <StatusField
              text={dreamer.status}
              isCurrentUser={this.isCurrentUser()}
              onEnter={(text) => dispatch(handleUpdateStatus(text))} />
          </div>
        </div>
      </div>
    );
  }
}

export default connect(
  (state, ownProps) => ({
    state: state.dreamerInfo,
    currentUser: state.user,
    ownProps
  })
)(Root);
