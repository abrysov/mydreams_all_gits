import React from "react";
import cx from "classnames";

const COINS = [1, 5, 10, 50, 100, 250, 500];

export default class extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      coins: COINS
    };
  }

  getSelectedMap() {
    var value = this.props.value;

    const map = {};


    this.state.coins.reverse().forEach((c) => {
      if (value >= c) {
        map[c] = true;
        value -= c;
      }
    });

    // Fucking js
    this.state.coins.reverse();

    return map;
  }

  render() {
    const map = this.getSelectedMap();

    const handleClick = (coin, isSelected) => (e) => {
      const oldValue = this.props.value;
      const newValue = isSelected ? oldValue - coin : oldValue + coin;
      this.props.onChange(newValue);
    };

    return (
      <div className="coin-list">
        {this.state.coins.map((c) => {
          const isSelected = map[c];
          const classes = cx({ disabled: !isSelected }, "coin");
          return (
            <div key={c} className={classes} onClick={handleClick(c, isSelected)}>{c}</div>
          );
        })}
      </div>
    );
  }
}
