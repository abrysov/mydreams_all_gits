import React from "react";

import DP from "presenters/Dreamer";

export default class extends React.Component {
  render() {
    const { coinsCount, cost, dreamer, onSubmit } = this.props;
    const handleSubmit = () => {
      const count = this.refs.count.value;
      const text = this.refs.text.value;
      onSubmit(count, text);
    };

    return (
      <div className="tab-body visible">
        <h4> На Вашем счете <b>{coinsCount}</b> монет </h4>
        <div className="gift-to">
          <div className="gift-wrapper">
            <div className="gift coins"></div>
            <div className="title">Введите количество:</div>
            <div className="coin-input">
              <input ref="count" type="number" defaultValue="10" min="1" />
              <div className="coins">Монет</div>
            </div>
          </div>
          <div className="arrow"></div>
          <a className="user" href={DP.url(dreamer)}>
            <div className="avatar size-l">
              <img src={DP.avatar(dreamer, 'medium')} />
            </div>
            <div className="username"> {DP.fullName(dreamer)} </div>
            <div className="info icon-text">
              <div className={`icon size-8 ${DP.gender(dreamer)}`}></div>
              {DP.locationInfo(dreamer)}
            </div>
          </a>
        </div>
        <textarea ref="text" className="normal" placeholder="Введите пожелание…" rows="4"></textarea>
        <button className="blue accent" onClick={handleSubmit}>Поделиться</button>
      </div>
    );
  }
}
