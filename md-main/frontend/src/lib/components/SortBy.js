import React from "react";
import { connect } from "react-redux";
import { push } from 'react-router-redux';

function getNullifiedOptionsMap(optionsMap) {
  return Object.keys(optionsMap).reduce((options, key) => {
    options[key] = false;
    return options;
  }, {});
}

class SortBy extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      options: {}
    };
  }

  componentDidMount() {
    this.setState({
      options: this.getSortParamsFromQuery(this.props.location.query)
    });
  }

  componentWillReceiveProps(newProps) {
    this.setState({
      options: this.getSortParamsFromQuery(newProps.location.query)
    });
  }

  getSortParamsFromQuery(urlParams) {
    const optionsMap = this.props.route.optionsMap;
    const state = getNullifiedOptionsMap(optionsMap);

    Object.keys(optionsMap).forEach((key) => {
      if (urlParams[key]) {
        // FIXME : есть ли какой-то способ получить сразу boolean из query?
        state[key] = (urlParams[key] === 'true');
      }
    });

    return state;
  }

  handleSortChange(sortName) {
    const state = getNullifiedOptionsMap(this.props.route.optionsMap);
    const buildUrl = this.props.route.urlBuildingMethod;
    state[sortName] = true;
    const url = buildUrl(this.props.location.query, state);
    this.props.dispatch(push(url));
  }

  render() {
    return (
      <div className="top">
        <div className="wrapper size-l justify">
          <div className="row">
            { Object.keys(this.state.options).map((key) => {
              return (
                <div className={"col-1 sort-btn" + (this.state.options[key] === true ? " down" : " up")}
                     onClick={this.handleSortChange.bind(this, key)}
                     key={key} >
                  { this.props.route.optionsMap[key] }
                </div>
              );
            }) }
          </div>
        </div>
      </div>
    );
  }
}

export default connect(
  (state, ownProps) => ({
    ownProps
  })
)(SortBy);