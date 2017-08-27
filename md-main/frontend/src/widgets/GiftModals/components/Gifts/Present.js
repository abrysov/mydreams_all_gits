import _ from "lodash";
import { connect } from "react-redux";
import { request, requestJson, getJson }  from 'lib/ajax';
import React from "react";
import cx from "classnames";

import DP from "presenters/Dreamer";

import {
  handleClose
} from "../../Actions";

import * as Requests from "../../Requests";

import InitialPresentVipStep from "./Steps/InitialPresentVip";
import SuccessPresentVipStep from "./Steps/SuccessPresentVip";
import InitialPresentCoinsStep from "./Steps/InitialPresentCoins";
import SuccessPresentCoinsStep from "./Steps/SuccessPresentCoins";
import FailStep from "./Steps/Fail";

class Present extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      tab: 'vip', // vip || coins
      vipCertificate: {},
      presentedCoinsCount: -1,
      step: 'initial', // initial || success || fail
    };

    Requests.loadVipCertificate().then((vipCertificate) => this.setState({ vipCertificate }));
  }

  renderStep(step) {
    const { presentedCoinsCount, vipCertificate } = this.state;
    const coinsCount = this.props.user.getCached('coins_count');
    const dreamer = this.props.state.dreamer;

    const key = `${this.state.tab}.${step}`;

    switch(key) {
      case 'vip.initial':
        return <InitialPresentVipStep
                  coinsCount={coinsCount}
                  cost={vipCertificate.cost}
                  dreamer={dreamer}
                  onSubmit={this.handleVipSubmit.bind(this)} />;
      case 'vip.success':
        return <SuccessPresentVipStep dreamer={dreamer} onClose={this.onClose.bind(this)} />;
      case 'vip.fail':
        return <FailStep cost={vipCertificate.cost} />;
      case 'coins.initial':
        return <InitialPresentCoinsStep coinsCount={coinsCount} dreamer={dreamer} onSubmit={this.handleCoinsSubmit.bind(this)} />;
      case 'coins.success':
        return <SuccessPresentCoinsStep count={presentedCoinsCount} dreamer={dreamer} onClose={this.onClose.bind(this)} />;
      case 'coins.fail':
        return <FailStep cost={presentedCoinsCount} />;
      default:
        throw 'Unhandled step: ' + step;
    }
  }

  renderTabs() {
    const onClick = (tab) => () => this.setState({ tab: tab, step: 'initial' });
    const activeClass = (tab) => this.state.tab == tab ? 'active' : '';

    const tabs = {
      vip: 'Подарить VIP статус',
      coins: 'Подарить монеты'
    };

    return (
      <div className="tabs">
        {_.map(tabs, (name, key) => {
          return <div key={key} className={`tab ${activeClass(key)}`} onClick={onClick(key)}>{name}</div>;
        })}
      </div>
    );
  }

  render() {
    return (
      <div className="popup gift">
        <div className="close" onClick={this.onClose.bind(this)}></div>
        <div className="header">
          <h3>Подарки</h3>
        </div>
        <div>
          {this.renderTabs()}
          {this.renderStep(this.state.step)}
        </div>
      </div>
    );
  }

  onClose() {
    this.props.dispatch(handleClose());
  }

  handleVipSubmit(text) {
    Requests.buyVip(this.state.vipCertificate.id, this.props.state.dreamer.id, text)
      .then((r) => this.setState({ step: 'success' }),
            () => this.setState({ step: 'fail' }));
  }

  handleCoinsSubmit(count, text) {
    this.setState({ presentedCoinsCount: count });
    const url = Routes.api_web_products_path({ certificates: true });
    requestJson(url)
    .then((r) => this.setState({ step: 'success' }),
          () => this.setState({ step: 'fail' }));
  }
}

export default connect(
  (state, ownprops) => ({
    state: state.giftModals,
    user: state.user
  })
)(Present);
