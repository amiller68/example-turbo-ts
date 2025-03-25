import { Request, Response, NextFunction } from "express";
import { config } from "@/config";
import { logger } from "@/services/logger";

export function authMiddleware(
  req: Request,
  res: Response,
  next: NextFunction,
) {
  const authKey = req.headers["x-api-key"];

  // Skip auth for health checks
  if (req.path.startsWith("/health")) {
    return next();
  }

  if (!authKey || authKey !== config.secrets.authKey) {
    logger.warn("middleware::auth::unauthorized-request", {
      path: req.path,
      ip: req.ip,
    });

    // TODO (amiller68): we should be using the ServerError class here
    return res.status(401).json({
      error: "unauthorized",
      message: "API key is required",
    });
  }

  next();
}
