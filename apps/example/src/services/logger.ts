import { createLogger } from "@repo/logger";

import { config } from "@/config";

export const logger = createLogger({
  level: config.log.level,
});
