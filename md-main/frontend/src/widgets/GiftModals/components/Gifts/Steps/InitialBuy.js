import React from "react";

import DP from "presenters/Dreamer";

export default function({ coinsCount, cost, onSubmit }) {
  return (
    <div className="tab-body visible">
      <h4> На Вашем счете <b>{coinsCount}</b> монет </h4>
      <div className="gift-wrapper big">
        <div className="gift vip"></div>
        <div className="title">Стоимость:</div>
        <div className="price">
          <span className="number">{cost}</span> Монет
        </div>
      </div>
      <button className="blue accent" onClick={onSubmit}>Купить</button>
    </div>
  );
}
