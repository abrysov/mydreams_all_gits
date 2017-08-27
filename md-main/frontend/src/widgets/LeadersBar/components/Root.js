import Routes from "routes";
import React from 'react';
import { connect } from 'react-redux';

import {
  loadLeaders,
  showAddModal
} from "../Actions";

class Root extends React.Component {

  componentDidMount() {
    this.onResize = this.onResize.bind(this);

    window.addEventListener('resize', this.onResize);
    this.onResize()

    this.props.dispatch(loadLeaders());
  }

  onResize(){
    this.setState({
      windowWidth: this.refs.tape.clientWidth,
      buttonSize: this.refs.addButton.clientHeight
    });
  }

  getLeaders() {
    let photoSize = 0;
    if(this.refs.addButton){
      let buttonSize = this.refs.addButton.clientHeight;
      let listSize = this.state.windowWidth - buttonSize;
      var count = Math.ceil( listSize / buttonSize );
      photoSize = listSize / count;
    }
    const leaders = this.props.state.leaders;
    return this.props.state.leaders.take(count).map((l) => {
      var message = l.get('message') ? <span>{l.get('message')}</span> : false;
      return (
        <a href={Routes.d_path(l.get('id'))} target="_blank" key={l.get('id')} className="user" style={{ backgroundImage: `url(${l.get('photo')})`, width: photoSize }}>
          <div className="title-box">
            <div className="title">
              <strong>{l.get('full_name')}, {l.get('age')}</strong>
              {message}
            </div>
          </div>
        </a>
      );
    });
  }

  render() {
    const { state, dispatch } = this.props;
    const leaders = state.getCached('leaders');

    return (
      <div className="tape" ref="tape">
        <div className="add-btn" ref="addButton" onClick={() => dispatch(showAddModal())}><span /></div>
        {this.getLeaders()}
      </div>
    );
  }
}

export default connect(
  (state) => ({
    state: state.leadersBar,
  })
)(Root);

