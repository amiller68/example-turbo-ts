import { createLogger } from "@repo/logger";

import { config } from "@/config";

export const logger = createLogger({
  sourceToken: config.log.logTailToken,
  level: config.log.level,
});
