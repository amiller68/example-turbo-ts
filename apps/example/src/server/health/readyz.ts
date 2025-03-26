import { Request, Response } from "express";

import { logger } from "@/services/logger";

import { ServerError, ServerErrors } from "@/server/error";

export const handler = async (req: Request, res: Response) => {
  try {
    logger.info("server::health::readyz -- health check started");
    // TODO (service-setup): this essentially equivalent to livez, but if you have any
    //  critical dependencies that need to be ready before you can handle
    //  requests, you can implement checks here i.e. we do a connection test to
    //  s3 here in the image-renderer service.
    res.json({
      status: "ok",
      timestamp: new Date().toISOString(),
      uptime: process.uptime(),
      memory: process.memoryUsage(),
    });
  } catch (error) {
    const e = error instanceof Error ? error : new Error(String(error));
    // NOTE: specifcally coalece into service-unavailable errors
    const serverError = new ServerError({
      error: ServerErrors.ServiceUnavailable,
      cause: e,
    });
    serverError.send(res);
  }
};
