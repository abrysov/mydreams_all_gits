import Immutable from "immutable";

const initialState = {
  paymentSystem: "robokassa", // yandex | robokassa
  coinsCount: 10,
  products: {}
};

export class State extends Immutable.Record(initialState) {
  getCoinRate() {
    return this.products[this.paymentSystem] || 0;
  }

  getTotalCost() {
    return this.coinsCount * this.getCoinRate();
  }

  handleFieldChange(field, value) {
    return this.set(field, value);
  }

  handleLoadProductsSuccess(response) {
    const products = response.products.reduce((acc, p) => {
      acc[p.properties.gateway_id] = p.properties.gateway_rate;
      return acc;
    }, {});

    return this.set("products", products);
  }
}
