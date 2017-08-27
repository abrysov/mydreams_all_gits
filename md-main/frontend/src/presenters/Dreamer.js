import Routes from "routes";
import { truncate } from "./helpers";

export default {
  url(dreamer) {
    return Routes.d_path(dreamer.id);
  },

  locationInfo(dreamer) {
    return [dreamer.age,
      !dreamer.country ? null : dreamer.country.name,
      !dreamer.city ? null : dreamer.city.name]
      .filter((x) => !!x).join(", ");
  },

  hasDreambookBg(dreamer) {
    return dreamer.dreambook_bg.cropped != null;
  },

  dreambookBg(dreamer) {
    return dreamer && dreamer.dreambook_bg ? dreamer.dreambook_bg.cropped : "";
  },

  avatar(dreamer, size) {
    return dreamer && dreamer.avatar ? dreamer.avatar[size] : "";
  },

  status(dreamer) {
    return truncate(dreamer.status, 40);
  },

  gender(dreamer) {
    return dreamer.gender;
  },

  fullName(dreamer) {
    return dreamer.full_name;
  }
}
