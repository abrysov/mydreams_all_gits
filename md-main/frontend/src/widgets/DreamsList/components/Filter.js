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
      <ul className="vertical-menu">
        <li><Link to={buildRouterDreamsUrl(query, { filter: 'liked'})} activeClassName="active">Популярные</Link></li>
        <li><Link to={buildRouterDreamsUrl(query, { filter: 'hot'})} activeClassName="active">Обсуждаемые</Link></li>
        <li><Link to={buildRouterDreamsUrl(query, { filter: 'new'})} activeClassName="active">Новые</Link></li>
      </ul>
    </div>
  );
}

export default connect(
  (state, ownProps) => ({
    ownProps
  })
)(Filter);

