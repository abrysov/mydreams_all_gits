import { connect } from "react-redux";
import { request, requestJson, getJson }  from 'lib/ajax';
import React from "react";
import cx from "classnames";

import DP from "presenters/Dreamer";

import {
  handleClose
} from "../../Actions";

import * as Requests from "../../Requests";

import InitialStep from "./Steps/InitialBuy";
import FailStep from "./Steps/Fail";
import SuccessStep from "./Steps/SuccessBuy";

class Buy extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      vipCertificate: {},
      step: 'initial', // initial || success || fail
    };

    Requests.loadVipCertificate().then((vipCertificate) => this.setState({ vipCertificate }));
  }

  renderStep(step) {
    const coinsCount = this.props.user.getCached('coins_count');
    const { vipCertificate } = this.state;
    const dreamer = this.props.state.dreamer;

    switch(step) {
      case 'initial':
        return <InitialStep coinsCount={coinsCount} cost={vipCertificate.cost} onSubmit={this.handleSubmit.bind(this)} />;
      case 'success':
        return <SuccessStep dreamer={dreamer} onClose={this.onClose.bind(this)} />;
      case 'fail':
        return <FailStep cost={vipCertificate.cost} />;
      default:
        throw 'Unhandled step: ' + step;
    }
  }

  render() {
    return (
      <div className="popup gift">
        <div className="close" onClick={this.onClose.bind(this)}></div>
        <div className="header">
          <h3>Купить VIP статус</h3>
        </div>
        <div>
          {this.renderStep(this.state.step)}
        </div>
      </div>
    );
  }

  onClose() {
    this.props.dispatch(handleClose());
  }

  handleSubmit() {
    Requests.buyVip(this.state.vipCertificate.id, this.props.state.dreamer.id)
      .then((r) => this.setState({ step: 'success' }),
            () => this.setState({ step: 'fail' }));
  }
}

export default connect(
  (state, ownprops) => ({
    state: state.giftModals,
    user: state.user
  })
)(Buy);
