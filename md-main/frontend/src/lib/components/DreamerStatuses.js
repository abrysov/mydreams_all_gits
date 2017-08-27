import React from 'react';

export default function({ onChange, value, isCurrentUser, widgetType }) {
  const handleChange = (name) => (e) => onChange({ [`${name}`]: e.target.checked });

  const handleAllChange = () => (e) => onChange({ new: false, hot: false, vip: false, online: false });

  const allChecked = !value.new && !value.hot && !value.vip && !value.online;

  const showAdditionalFields = widgetType == 'all_dreamers';

  return (
    <div className="couple">
      <div>
        <label>
          <div className="checkbox">
            <input type="checkbox" checked={allChecked} onChange={handleAllChange()} />
            <span />
          </div>
          <span>Все</span>
        </label>
        <label>
          <div className="checkbox">
            <input type="checkbox" checked={value.new} onChange={handleChange('new')} />
            <span />
          </div>
          <span>Новые</span>
        </label>
        <label>
          <div className="checkbox">
            <input type="checkbox" checked={value.hot} onChange={handleChange('hot')} />
            <span />
          </div>
          <span>Популярные</span>
        </label>
      </div>
      { showAdditionalFields ?
      <div>
        <label>
          <div className="checkbox">
            <input type="checkbox" checked={value.vip} onChange={handleChange('vip')} />
            <span />
          </div>
          <span>VIP</span>
        </label>
        <label>
          <div className="checkbox">
            <input type="checkbox" checked={value.online} onChange={handleChange('online')} />
            <span />
          </div>
          <span>Online</span>
        </label>

      </div>
      : "" }
    </div>
  );
}

