import React from 'react';
import {dispatch} from '../flux-infra/MessengerDispatcher';

class UserSelect extends React.Component {

  render() {
    var {
      onUserChanged,
      userToken,
      users
    } = this.props;

    var usersNodes = users.map(user => {
      return (<option value={user.token} key={user.token}>{user.name}</option>)
    });
    return (
      <div>
        <span>I am</span>
        <select value={userToken} onChange={onUserChanged}>
          {usersNodes}
        </select>
      </div>
    )
  }
}

export default UserSelect;
