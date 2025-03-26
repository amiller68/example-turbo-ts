import { Request, Response } from "express";
import { ServerError, ServerErrors } from "@/server/error";
import pkg from "../../../package.json";

interface PackageJson {
  version: string;
  [key: string]: unknown;
}

export const handler = async (req: Request, res: Response) => {
  try {
    res.json({
      status: "ok",
      timestamp: new Date().toISOString(),
      node_version: process.version,
      platform: process.platform,
      arch: process.arch,
      version: (pkg as PackageJson).version,
    });
  } catch (error) {
    const e = error instanceof Error ? error : new Error(String(error));
    const serverError = new ServerError({
      error: ServerErrors.ServiceUnavailable,
      cause: e,
    });
    serverError.send(res);
  }
};
