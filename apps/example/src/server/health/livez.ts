import { Request, Response } from "express";

export const handler = (req: Request, res: Response) => {
  res.json({ status: "ok" });
};
