import { apiInitializer } from "discourse/lib/api";
import bdaysAnnsBanner from "../components/get_bdays_anns.gjs";

export default apiInitializer("1.14.0", (api) => {
  api.renderInOutlet('below-site-header', bdaysAnnsBanner);
});
