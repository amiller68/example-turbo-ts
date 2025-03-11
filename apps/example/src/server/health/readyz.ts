import { Request, Response } from "express";

export const handler = async (req: Request, res: Response) => {
  try {
    res.json({
      status: "ok",
      timestamp: new Date().toISOString(),
      // TODO (amiller68): we're running this in a fargate, is
      //  this redundant?
      uptime: process.uptime(),
      memory: process.memoryUsage(),
    });
  } catch (error) {
    res.status(503).json({
      status: "error",
      message: "Service unavailable",
    });
  }
};
