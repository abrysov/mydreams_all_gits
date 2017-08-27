import React from "react";

import DP from "presenters/Dreamer";

export default function({ dreamer, onClose }) {
  return (
    <div className="tab-body visible">
      <h4>Вы успешно приобрели VIP статус!</h4>
      <div className="user-wrapper">
        <a className="user" href="#">
          <div className="avatar-wrapper success vip">
            <div className="avatar size-l">
              <img src={DP.avatar(dreamer, 'medium')} />
            </div>
          </div>
          <div className="username vip">
            {DP.fullName(dreamer)}
          </div>
          <div className="info icon-text">
            <div className={`icon size-8 ${DP.gender(dreamer)}`}></div>
            {DP.locationInfo(dreamer)}
          </div>
        </a>
      </div>
      <button className="blue accent" onClick={onClose}>Готово</button>
    </div>
  );
}

