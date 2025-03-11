import { Request, Response } from "express";
import { z } from "zod";

import { ServerError } from "../../error";

// NOTE (amiller68): this api surface is tightly coupled with the client implementation
//  in apps/mothership/lib/image-renderer -- if you change this you are
//  responsible for updating the client implementation as well.

export const HelloRequestSchema = z.object({}).strict();

export type HelloRequest = z.infer<typeof HelloRequestSchema>;

export interface HelloResponse {
  message: string;
}

export async function handler(req: Request, res: Response) {
  try {
    return res.json({
      message: "hello",
    });
  } catch (error: Error | unknown) {
    ServerError.from(error).send(res);
  }
}
