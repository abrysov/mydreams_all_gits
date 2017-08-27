import React from "react";

function Field({ logo, value, isChecked, onChange }) {
  const handleChange = (e) => onChange(value);
  return (
    <div className="col-1">
      <div className="logo">
        <img src={logo} alt={value} />
      </div>
      <div className="radio">
        <input name="gateway" type="radio" checked={isChecked} value={value} onChange={handleChange} />
        <span></span>
      </div>
    </div>
  );
}

export default function({ onChange, value }) {
  return (
    <div className="select-pay-system row">
      <Field
        key="yandex"
        logo="http://mydreams.dev:3000/assets/new/pay-system/yandex-7bf8639bbae8aa27ee80f61d12cc98f905f9a51ccba5ccf1b46bab466003ed05.png"
        value="yandex"
        isChecked={value == "yandex"}
        onChange={onChange} />
      <Field
        key="robokassa"
        logo="http://mydreams.dev:3000/assets/new/pay-system/robokassa-d3084755a1c58405df45a553ad1c6fe1cf0206eaa2243a61ec4429980990393c.png"
        value="robokassa"
        isChecked={value == "robokassa"}
        onChange={onChange} />
    </div>
  );
}
