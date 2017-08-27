import React from 'react';
import { Link } from 'react-router';
import { connect } from 'react-redux';

import { buildRouterDreamsUrl } from "lib/routerUrlBuilders";

import Search from "lib/components/Search";

import {
  handleSearchEnter
} from "../Actions";

function Filter({ location, dispatch }) {
  const query = location.query;
  return (
    <div className="top">
      <div className="wrapper">
        <Search onEnter={(val) => dispatch(handleSearchEnter(val))} />
      </div>
      <ul className="vertical-menu">
        <li><Link to={buildRouterDreamsUrl(query, { gender: 'all'})} activeClassName="active">Все</Link></li>
        <li><Link to={buildRouterDreamsUrl(query, { gender: 'female'})} activeClassName="active">Женские</Link></li>
        <li><Link to={buildRouterDreamsUrl(query, { gender: 'male'})} activeClassName="active">Мужские</Link></li>
      </ul>
    </div>
  );
}

export default connect(
  (state, ownProps) => ({
    ownProps
  })
)(Filter);

