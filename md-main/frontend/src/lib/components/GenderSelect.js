import React from 'react';

export default function({ onChange, value }) {
  const handleChange = (val) => (e) => e.target.checked ? onChange(val): null;
  return (
    <div className="couple">
      <div>
        <label>
          <div className="radio">
            <input name="sex" type="radio" checked={value == "female"} onChange={handleChange('female')} />
            <span></span>
          </div>
          <span>Девушка</span>
        </label>
        <label>
          <div className="radio">
            <input name="sex" type="radio" checked={value == "male"} onChange={handleChange('male')} />
            <span></span>
          </div>
          <span>Мужчина</span>
        </label>
      </div>
      <div>
        <label>
          <div className="radio">
            <input name="sex" type="radio" checked={value == false} onChange={handleChange(false)} />
            <span></span>
          </div>
          <span>Любой</span>
        </label>
      </div>
    </div>
  );
}

