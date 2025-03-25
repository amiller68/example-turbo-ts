import { Response } from "express";
import { ZodError } from "zod";

import { logger } from "@/services/logger";

/* Examples usage:

const handler = (req: Request, res: Response) => {
  try {
    // this would through a 422 error if the input is invalid
    //  since its not caught by anything else
    const unsafeParse = z.parse(unsafeInput);

    // this could throw anything we want if we follow this pattern.
    //  its good for implementing custom errors and business logic errors.
    try {
      const unsafeParse = z.parse(unsafeInput);
    } catch (error) {
      // this would throw a 401 when the input is invalid
      throw new ServerError({
        error: ServerErrors.BadRequest,
        cause: error,
      });
    }

    let random = Math.random();
    if (random < 0.5) {
      // this would get caught as a 500, since its not handled by ServerError.from
      //  and isn't thrown from the ServerError class. It should also trigger
      //  the logger.error below.
      throw new Error("random error");
    }
  } catch (error) {
    // Everything gets caught here and sent to the client
    const serverError = ServerError.from(error);
    serverError.send(res);
  }
}
*/

export enum ServerErrorStatus {
  BadRequest = 400,
  Unauthenticated = 401,
  Unauthorized = 403,
  NotFound = 404,
  Conflict = 409,
  ValidationError = 422,
  InternalError = 500,
  ServiceUnavailable = 503,
  // TODO: add more as needed
}

export interface IServerError {
  message: string;
  status: ServerErrorStatus;
}

// Base server errors
export const ServerErrors = {
  BadRequest: {
    message: "bad-request",
    status: ServerErrorStatus.BadRequest,
  } as IServerError,
  Unauthenticated: {
    message: "unauthenticated",
    status: ServerErrorStatus.Unauthenticated,
  } as IServerError,
  Unauthorized: {
    message: "unauthorized",
    status: ServerErrorStatus.Unauthorized,
  } as IServerError,
  NotFound: {
    message: "not-found",
    status: ServerErrorStatus.NotFound,
  } as IServerError,
  ValidationError: {
    message: "validation-error",
    status: ServerErrorStatus.ValidationError,
  } as IServerError,
  InternalError: {
    message: "internal-server-error",
    status: ServerErrorStatus.InternalError,
  } as IServerError,
  ServiceUnavailable: {
    message: "service-unavailable",
    status: ServerErrorStatus.ServiceUnavailable,
  } as IServerError,
  // TODO: add more as needed
} as const;

const sanitizeMessage = (message: string) => {
  return message
    .toLowerCase()
    .replace(/[^\w-]+/g, "")
    .replace(/\s+/g, "-");
};

export class ServerError extends Error {
  public readonly type: ServerErrorStatus;
  private readonly overrideMessage?: string;
  private readonly originalError?: Error;
  private readonly sanitizedMessage: string;

  constructor({
    error,
    overrideMessage,
    type,
    cause,
  }: {
    error: IServerError | string;
    overrideMessage?: string;
    type?: ServerErrorStatus;
    cause?: Error;
  }) {
    // If we have a cause, use its message but keep the sanitized version
    const message =
      cause?.message || (typeof error === "string" ? error : error.message);

    super(message);
    this.overrideMessage = overrideMessage;
    this.type =
      type ??
      (typeof error === "string"
        ? ServerErrorStatus.InternalError // Default untyped errors to 500
        : error.status);

    // Store sanitized message for client responses
    this.sanitizedMessage =
      typeof error === "string"
        ? "internal-server-error" // Default sanitized message for untyped errors
        : sanitizeMessage(error.message);

    // if overrideMessage is provided, use it
    if (overrideMessage) {
      this.sanitizedMessage = sanitizeMessage(overrideMessage);
    }

    // Preserve the original error and its stack
    if (cause) {
      this.originalError = cause;
      this.stack = `${this.stack}\nCaused by: ${cause.stack}`;
    }
  }

  static from(error: Error | unknown): ServerError {
    if (error instanceof ServerError) {
      return error;
    }

    // TODO: implement more implementations of FROM here as needed.
    //  For now we are pretty set on saying ZodErrors are bad requests
    //  if they are otherwise unhandled.
    if (error instanceof ZodError) {
      return new ServerError({
        error: ServerErrors.ValidationError,
        cause: error,
      });
    }

    // Unhandled errors become 500s with sanitized messages
    return new ServerError({
      error: ServerErrors.InternalError,
      cause: error instanceof Error ? error : undefined,
    });
  }

  send(res: Response) {
    if (this.type === ServerErrorStatus.InternalError) {
      logger.error("server::error::internal-server-error", {
        message: this.message,
        stack: this.stack,
      });
    }

    // Send sanitized message to client
    res
      .status(this.type)
      .json({ error: this.overrideMessage ?? this.sanitizedMessage });
  }
}
