import React from 'react';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';

import Search from "lib/components/Search";

import DreamerStatuses from "lib/components/DreamerStatuses";
import CountrySelect from "lib/components/CountrySelect";
import CitySelect from "lib/components/CitySelect";
import AgeSelect from "lib/components/AgeSelect";
import GenderSelect from "lib/components/GenderSelect";

import {
  handleFilterSelect
} from "../Actions";

function getFilterParamsFromQuery(urlParams) {
  const state = {
    search: "",
    new: false,
    hot: false,
    vip: false,
    online: false,
    country_id: -1,
    city_id: -1,
    from: -1,
    to: -1,
    gender: false
  };

  ['new', 'hot', 'vip', 'online'].forEach(k => {
    if (urlParams[k]) { state[k] = Boolean(urlParams[k]); }
  });

  ['from', 'to', 'country_id', 'city_id'].forEach(k => {
    if (urlParams[k]) { state[k] = Number(urlParams[k]); }
  });

  ['search', 'gender'].forEach(k => {
    if (urlParams[k]) { state[k] = urlParams[k]; }
  });

  return state;
}

class Filter extends React.Component {
  render() {
    const { state, currentUser, dispatch, location } = this.props;
    const isCurrentUser = currentUser.getId() == state.getDreamerId();
    const widgetType = state.getType();

    const filterParams = getFilterParamsFromQuery(location.query);
    const {
      search,
      hot,
      online,
      vip,
      country_id,
      city_id,
      from,
      to,
      gender
    } = filterParams;

    const allDreamersWidget = widgetType === 'all_dreamers';

    const showLocationSelects = isCurrentUser || allDreamersWidget; // && _.contains(['all_dreamers', 'dreambook_friends', 'dreambook_followers'], widgetType);
    const showGenderSelect = isCurrentUser || allDreamersWidget; // && _.contains(['all_dreamers', 'dreambook_friends', 'dreambook_followers'], widgetType);
    const showAgeSelect = isCurrentUser || allDreamersWidget; // && _.contains(['all_dreamers', 'dreambook_friends', 'dreambook_followers'], widgetType);

    return (
      <div className="top">
        <div className="wrapper">
          { allDreamersWidget ?
          <Search onEnter={(search) => dispatch(handleFilterSelect({ search }))} value={search} />
          : "" }
        </div>
        <div className="wrapper">
          <div className="filter">
            <DreamerStatuses
              isCurrentUser={isCurrentUser}
              widgetType={widgetType}
              onChange={(statuses) => dispatch(handleFilterSelect(statuses)) }
              value={{ new: filterParams.new, hot, vip, online }} />
          </div>

          { showLocationSelects ?
          <label className="filter">
            <span>Страна</span>
            <CountrySelect
              onChange={(country_id) => dispatch(handleFilterSelect({ country_id, city_id: -1 }))}
              value={country_id} />
          </label>
          : "" }
          { showLocationSelects && country_id > 0 ?
            <label className="filter">
              <span>Город</span>
              <CitySelect
                country_id={country_id}
                onChange={(city_id) => dispatch(handleFilterSelect({ city_id }))}
                value={city_id} />
            </label>
            : "" }
            { showAgeSelect ?
            <label className="filter">
              <span>Возраст</span>
              <AgeSelect
                onChange={(age) => dispatch(handleFilterSelect(age))}
                value={{from, to }} />
            </label>
            : "" }
            { showGenderSelect ?
            <div className="filter">
              <span>Пол</span>
              <GenderSelect
                onChange={(gender) => dispatch(handleFilterSelect({ gender }))}
                value={gender} />
            </div>
            : "" }
          </div>
        </div>
    );
  }
}

export default connect(
  (state, ownProps) => ({
    ownProps,
    state: state.dreamersList,
    currentUser: state.user
  })
)(Filter);
