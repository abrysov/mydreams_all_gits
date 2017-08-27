import React from "react";
import { connect } from "react-redux";
import { push } from 'react-router-redux';

import {
  buildRouterCertificatesUrl
} from "lib/routerUrlBuilders";

class Filter extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      possibleFilters: {
        all: 'Все',
        gifted: 'Подаренные',
        paid: 'Купленные'
      },
      currentFilter: 'all'
    };
  }

  handleFilterChange(newFilter) {
    if (this.state.currentFilter === newFilter) { return; }
    this.setState({ currentFilter: newFilter });
    const oldFilter = this.state.currentFilter;

    const query = {};
    if (newFilter !== 'all') {
      query[newFilter] = true;
    }

    const url = buildRouterCertificatesUrl({}, query);

    this.props.dispatch(push(url));
  }

  render() {
    return (
      <div className="wrapper">
        <div className="filter">
          { Object.keys(this.state.possibleFilters).map((filterKey) => {
            return (
              <label key={filterKey}>
                <span className="checkbox">
                  <input type="checkbox"
                         checked={filterKey === this.state.currentFilter}
                         onChange={this.handleFilterChange.bind(this, filterKey)} />
                  <span></span>
                </span>
                <span>{this.state.possibleFilters[filterKey]}</span>
              </label>
            );
          })}
        </div>
      </div>
    );
  }
}

export default connect(
  (state, ownProps) => ({
    state: state.certificatesList.certificates,
    ownProps
  })
)(Filter);
