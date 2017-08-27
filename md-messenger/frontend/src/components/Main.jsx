import React from 'react';
import {Container} from 'flux/utils';
import {dispatch} from '../flux-infra/MessengerDispatcher';
import MessengerStore from '../flux-infra/MessengerStore';
import StatusBar from './StatusBar';
import UserSelect from './UserSelect';
import MessageBox from './MessageBox';

const token1 = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoxfQ.rpWgOBaCjeZW-34cmFQLmbJQ1gRbTyy-bycPYXc5Zts'
const token2 = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoyfQ.FDzZ9cDuecdcuXJx2qIFz1ipDNsnkUnQqfE3bpMY2rU'

class Main extends React.Component {
  static getStores() {
    return [MessengerStore];
  }

  static calculateState(prevState, props) {
    return {
      connection_status: MessengerStore.connection_status(),
      userToken: MessengerStore.userToken(),
      messages: MessengerStore.messages(),
      users: [
        {token: token1, name: 'Андрей'},
        {token: token2, name: 'Саша'}
      ]
    };
  }

  constructor(props, context) {
    super(props, context);
    this.handleUserChanged = this.handleUserChanged.bind(this);
  }

  handleUserChanged(e) {
    dispatch({type: 'change_user', userToken: e.target.value});
  }

  render() {
    return (
      <div>
        <StatusBar status={this.state.connection_status} />
        <UserSelect
          users={this.state.users}
          userId={this.state.userId}
          onUserChanged={this.handleUserChanged}
        />
        <MessageBox data={this.state.messages} />
      </div>
    )
  }
}

const MainContainer = Container.create(Main);
export default MainContainer;
