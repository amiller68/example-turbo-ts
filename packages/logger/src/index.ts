import winston from "winston";
import { Logtail } from "@logtail/node";
import { LogtailTransport } from "@logtail/winston";

const { combine, timestamp, json, errors } = winston.format;

import { prettyJson } from "./utils";

export type Logger = winston.Logger;

export function createLogger({
  sourceToken = undefined,
  level = "info",
  vercelEnv = undefined,
}: {
  sourceToken?: string;
  level?: string,
  vercelEnv?: string,
}) {
  // Create logtail instance if sourceToken is provided
  const logtail = sourceToken ? new Logtail(sourceToken) : null;

  // Initialize transports array
  const transports: winston.transport[] = [
    // Console transport with pretty print
    new winston.transports.Console({
      format: combine(
        timestamp({
          format: "YYYY-MM-DD hh:mm:ss.SSS A", // 2022-01-25 03:23:10.350 PM
        }),
        prettyJson,
      ),
    }),
  ];

  // Add Logtail transport if sourceToken is provided and we're not in browser
  // @ts-expect-error -- we probably shouldnt be doing jank window stuff here
  if (typeof window === "undefined" && sourceToken && logtail) {
    transports.push(
      new LogtailTransport(logtail, {
        format: combine(
          json(),
          timestamp({
            format: "YYYY-MM-DD hh:mm:ss.SSS A",
          }),
          errors({ stack: true }),
        ),
      }),
    );
  }

  return winston.createLogger({
    level,
    transports,
    defaultMeta: {
      vercelEnv,
    },
  });
}
