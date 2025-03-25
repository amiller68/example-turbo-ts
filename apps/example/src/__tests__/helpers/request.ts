import { vi } from "vitest";
import { Request, Response } from "express";

export function createMockRequest(
  body = {},
  params = {},
  query = {},
): Partial<Request> {
  return {
    body,
    params,
    query,
  };
}

export function createMockResponse(): {
  res: Partial<Response>;
  jsonMock: ReturnType<typeof vi.fn>;
  statusMock: ReturnType<typeof vi.fn>;
} {
  const jsonMock = vi.fn().mockReturnThis();
  const statusMock = vi.fn().mockReturnThis();

  const res: Partial<Response> = {
    json: jsonMock,
    status: statusMock as unknown as Response["status"],
    send: vi.fn().mockReturnThis(),
  };

  return { res, jsonMock, statusMock };
}
