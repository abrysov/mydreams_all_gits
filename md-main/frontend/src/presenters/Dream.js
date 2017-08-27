import Routes from "routes";
import moment from 'moment';
import { truncate } from "./helpers";

import DreamerPresenter from "./Dreamer";

export default {
  url(dream) {
    return Routes.d_dream_path(dream.dreamer.id, dream.id);
  },

  photo(dream, size) {
    return dream && dream.photo ? dream.photo[size] : "";
  },

  description(dream, length = 40) {
    if (length == 0) {
      return dream.description;
    }
    return truncate(dream.description, length);
  },

  createdAt(dream) {
    return moment(dream.created_at).format("DD.MM.YY");
  },

  certificateType(dream) {
    return dream.certificate_type.toUpperCase();
  },

  certificateTypeClass(dream, defaultClass = "default") {
    if (dream.fulfilled) {
      return 'green';
    }

    switch(dream.certificate_type) {
      case 'My Dreams':
        return defaultClass;
      case 'Vip':
        return 'vip';
      case 'Bronze':
        return 'bronze';
      case 'Silver':
        return 'silver';
      case 'Gold':
        return 'gold';
      case 'Presidential':
        return 'presidential';
      case 'Imperial':
        return 'imperial';
      case 'Platinum':
        return 'platinum';
      default:
        return defaultClass;
    }
  },

  dreamerAvatar(dream, size) {
    return DreamerPresenter.avatar(dream.dreamer, size);
  },

  dreamerUrl(dream) {
    return DreamerPresenter.url(dream.dreamer);
  },

  dreamerFullName(dream) {
    return dream.dreamer.full_name;
  },

  dreamerLocationInfo(dream) {
    return DreamerPresenter.locationInfo(dream.dreamer);
  },

  dreamerGender(dream) {
    return DreamerPresenter.gender(dream.dreamer);
  }
}

