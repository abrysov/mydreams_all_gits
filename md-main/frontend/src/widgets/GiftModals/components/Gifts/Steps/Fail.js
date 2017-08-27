import React from "react";

export default function({ cost }) {
  return (
    <div className="tab-body visible">
      <div className="fail-wrapper">
        <h4> К сожалению, на Вашем счете <br /> недостаточно монет!  </h4>
        <h3> Требуется: <strong> {cost} </strong> монет </h3>
      </div>
      <a href="#" className="blue accent">Пополнить</a>
    </div>
  );
}
