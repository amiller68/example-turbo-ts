import { Response } from "express";
import { ZodError } from "zod";

export enum ServerErrorStatus {
  BadRequest = 400,
  Unauthenticated = 401,
  Unauthorized = 403,
  NotFound = 404,
  Conflict = 409,
  ValidationError = 422,
  InternalError = 500,
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
  InternalError: {
    message: "internal-server-error",
    status: ServerErrorStatus.InternalError,
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

    if (error instanceof ZodError) {
      return new ServerError({
        error: ServerErrors.BadRequest,
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
      console.log("error");
    }

    // Send sanitized message to client
    res
      .status(this.type)
      .json({ error: this.overrideMessage ?? this.sanitizedMessage });
  }
}
