import { connect } from "react-redux";
import { request, requestJson, getJson }  from 'lib/ajax';
import React from "react";
import cx from "classnames";

import CertificatesList from "lib/components/CertificatesList";
import * as Requests from "../../Requests";

import DP from "presenters/Dream";

import {
  handleClose
} from "../../Actions";

class Buy extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      certificates: [],
      currentCertificateId: -1,
      step: 'initial', // initial || success || fail
    };

    Requests.loadCertificates().then((certificates) => this.setState({ certificates }));
  }

  renderStep(step) {
    switch(step) {
      case 'initial':
        return this.renderInitialStep();
      case 'success':
        return this.renderSuccessStep();
      case 'fail':
        return this.renderFailStep();
      default:
        throw 'Unhandled step: ' + step;
    }
  }

  renderInitialStep() {
    const coinsCount = this.props.user.getCached('coins_count');
    const { certificates, currentCertificateId } = this.state;
    const canSubmitForm = currentCertificateId != -1;

    return (
      <div>
        <h4>Выберите марку</h4>
        <h4>На Вашем счете <b>{coinsCount}</b> монет</h4>

        <CertificatesList
          certificates={certificates}
          currentCertificateId={currentCertificateId}
          onSelect={(id) => this.setState({currentCertificateId: id})} />

        <button
          className="yellow accent"
          disabled={!canSubmitForm}
          onClick={() => this.handleSubmit()}>Запустить Мечту</button>

        <h4 className="pay-info">Данная опция является платной</h4>
      </div>
    );

  }

  renderSuccessStep() {
    const cert = this.getCurrentCertificate();
    const dream = this.props.state.dream;
    //FIXME: dirty hack for presenter
    dream.certificate_type = cert.name;

    return (
      <div>
        <h4> Вы успешно приобрели Марку <br /> <b>{DP.certificateType(dream)}</b> на Мечту!  </h4>

        <div className="dream">
          <div className={`label ${DP.certificateTypeClass(dream)}`}>{dream.certificate_type}</div>
          <img src={DP.photo(dream, 'medium')} />
          <div className={`mark ${DP.certificateTypeClass(dream)}`}></div>
        </div>

        <button className="yellow accent" onClick={this.onClose.bind(this)}>Готово</button>
      </div>
    );
  }

  renderFailStep() {
    return (
      <div className="need-coin">
        <h4> К сожалению, на Вашем счете <br /> недостаточно монет!  </h4>
        <h3> Требуется: <strong>{this.getCurrentCertificateCost()}</strong> монет </h3>
        <button className="yellow accent" onClick={this.onClose.bind(this)}>Готово</button>
      </div>
    );
  }

  render() {
    return (
      <div className="popup popup-marks popup-label yellow">
        <div className="close" onClick={this.onClose.bind(this)}></div>
        <div className="header">
          <h3>Запустить Мечту во Вселенную</h3>
        </div>
        {this.renderStep(this.state.step)}
      </div>
    );
  }

  onClose() {
    this.props.dispatch(handleClose());
  }

  getCurrentCertificate() {
    return this.state.certificates.find((x) => x.id == this.state.currentCertificateId);
  }

  getCurrentCertificateCost() {
    const cert = this.getCurrentCertificate();
    return cert ? cert.properties.certificate_launches : -1;
  }

  handleSubmit() {
    const currentCertificateId = this.state.currentCertificateId;
    const dreamId = this.props.state.dream.id;
    if (!currentCertificateId) { return; }

    Requests.buyCertificate(currentCertificateId, dreamId)
      .then((r) => this.setState({ step: 'success' }),
            () => this.setState({ step: 'fail' }));
  }
}

export default connect(
  (state, ownprops) => ({
    state: state.giftModals,
    user: state.user
  })
)(Buy);
