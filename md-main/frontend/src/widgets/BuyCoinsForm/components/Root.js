import Routes from "routes";
import React from "react";
import { connect } from "react-redux";

import cx from "classnames";

import CoinsList from "./CoinsList";
import PaymentSystems from "./PaymentSystems";

import {
  loadProducts,
  handleFieldChange
} from "../Actions";

class Root extends React.Component {
  componentDidMount() {
    this.props.dispatch(loadProducts());
  }

  render() {
    const { dispatch, state } = this.props;
    const {
      paymentSystem,
      coinsCount
    } = state;

    const coinRate = state.getCoinRate();
    const totalCost = state.getTotalCost();

    const onFieldChange = (name) => (value) => dispatch(handleFieldChange(name, value));

    return (
      <form className="balance-page" action={Routes.api_web_payments_gateway_path()} method="POST">
        <PaymentSystems value={paymentSystem} onChange={onFieldChange("paymentSystem")} />

        <div className="coin-course">
          <div className="icon money size-86"></div>
          <div className="title">
            Курс: <b>1</b> монета = <b>{coinRate}</b> руб.
          </div>
        </div>
        <h4>Выберите количество</h4>
        <CoinsList value={coinsCount} onChange={onFieldChange("coinsCount")} />

        <div className="wrapper">
          <div className="coin-input">
            <div className="title">Ввести вручную:</div>
            <input name="amount"
                   type="text"
                   value={coinsCount}
                   onChange={(e) => dispatch(handleFieldChange("coinsCount", parseInt(e.target.value)))} />
            <div className="coins">Монет</div>
          </div>
          <hr />
          <div className="total">
            <div className="title">
              Итого в рублях: <span>{totalCost}</span> руб.
            </div>
            <div className="btn-wrapper">
              <button className="blue accent">Пополнить</button>
            </div>
          </div>
        </div>
      </form>
    );
  }
}

export default connect(
  (state, ownProps) => ({
    state: state.buyCoinsForm,
    ownProps
  })
)(Root);
