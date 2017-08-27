import React from 'react';

const ages = [];
for (var i = 6; i < 90; i++) { ages.push(i); }


export default class AgeSelect extends React.Component {
  render() {
    const { value, onChange } = this.props;
    const { from, to } = value;

    const handleChange = (e) => {
      onChange({
        from: parseInt(this.refs.from.value),
        to: parseInt(this.refs.to.value)
      });
    };

    return (
      <div className="couple">
        <div className="select">
          <select value={from} onChange={handleChange} ref="from">
            <option value="-1">От</option>
            {ages.filter((v) => to > 0 ? v < to : true).map((age) => {
              return <option key={`from-${age}`} value={age}>{age}</option>
              })}
            </select>
          </div>
          <span>−</span>
          <div className="select">
            <select value={to} onChange={handleChange} ref="to">
              <option value="-1">До</option>
              {ages.filter((v) => from > 0 ? v > from : true).map((age) => {
                return <option key={`to-${age}`} value={age}>{age}</option>
                })}
              </select>
            </div>
          </div>
    );
  }

}
