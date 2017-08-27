import React from 'react';
import {dispatch} from '../flux-infra/MessengerDispatcher';

class StatusBar extends React.Component {
  constructor(props, context) {
    super(props, context);

    this.handleOpenConnectionButtonClick = this.handleOpenConnectionButtonClick.bind(this);
    this.handleCloseConnectionButtonClick = this.handleCloseConnectionButtonClick.bind(this);
  }

  handleOpenConnectionButtonClick(e) {
    dispatch({type: 'connect'});
  }

  handleCloseConnectionButtonClick(e) {
    dispatch({type: 'disconnect'});
  }

  render() {
    return (
      <div className="statusBar">
        <span>Status: </span>
        <span>{this.props.status}</span>
        <button
          className="openConnectionButton"
          onClick={this.handleOpenConnectionButtonClick}
        >Open connection</button>
        <button
          className="closeConnectionButton"
          onClick={this.handleCloseConnectionButtonClick}
        >Close connection</button>
      </div>
    )
  }
}

export default StatusBar;
