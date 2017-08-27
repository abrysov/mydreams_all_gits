import Routes from "routes";
import React from 'react';
import { connect } from 'react-redux';

import cx from "classnames";

export default class CertificatesList extends React.Component {
  componentDidMount() {
    this.props.onMount ? this.props.onMount() : false;
  }

  render() {
    const {
      certificates,
      onSelect,
      currentCertificateId
    }  = this.props;
    return (
      <div className="mark-list">
        {certificates.map((c) => {
          const id = c.id;
          const name = c.name;
          const launches = c.properties.certificate_launches;
          const classes = cx('mark-wrapper', { active: id == currentCertificateId });
          return (
            <div className={classes} key={id} onClick={(e) => onSelect(id)}>
              <div className={`${name} mark`}></div>
              <div className="icon-text">
                <div className="text">{launches}</div>
                <div className="icon amount size-l"></div>
              </div>
            </div>
            );
        })}
      </div>
    );
  }
}
