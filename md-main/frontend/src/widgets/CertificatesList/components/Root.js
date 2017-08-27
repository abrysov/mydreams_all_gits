import React from "react";
import { connect } from "react-redux";

import cx from "classnames";

import BodyInfinityScroll from "lib/components/BodyInfinityScroll";

import {
  loadCertificates,
  loadNextCertificates
} from "../Actions";

class Root extends React.Component {
  componentDidMount() {
    this.props.dispatch(loadCertificates(this.props.route.userId));
  }

  render() {
    const { dispatch, state } = this.props;
    const widgetUserId = this.props.route.userId;

    return (
      <BodyInfinityScroll
        className="mark-list"
        isLoading={state.isLoadStarted}
        onScrollEnd={(e) => dispatch(loadNextCertificates(widgetUserId))}>

        { state.certificates.map((cert) => {
          cert = cert.toJSON();
          return (
            <div className="mark-wrapper-picture" key={cert.id}>
              <img src={cert.certifiable.photo.medium} alt={cert.certifiable.certificate_type} />
              <div className={ cx('mark', cert.certificate_type) }></div>
            </div>
          );
        })}

      </BodyInfinityScroll>
    );
  }

  componentWillReceiveProps(newProps) {
    const newQuery = newProps.location.query;
    const oldQuery = this.props.location.query;
    if (!_.isEqual(oldQuery, newQuery)) {
      newProps.dispatch(loadCertificates(this.props.route.userId));
    }
  }
}

export default connect(
  (state, ownProps) => ({
    state: state.certificatesList.certificates,
    ownProps
  })
)(Root);
