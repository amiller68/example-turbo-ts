import { Request, Response } from "express";
import { z } from "zod";

import { ServerError } from "@/server/error";

export const EchoRequestSchema = z.any();

export type EchoRequest = z.infer<typeof EchoRequestSchema>;

export const EchoResponseSchema = z.any();

export type EchoResponse = z.infer<typeof EchoResponseSchema>;

export async function handler(req: Request, res: Response) {
  try {
    const request = EchoRequestSchema.parse(req.body);
    return res.json(request);
  } catch (error: Error | unknown) {
    ServerError.from(error).send(res);
  }
}
