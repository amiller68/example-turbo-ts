import { describe, it, expect, vi, beforeEach } from "vitest";
import { Request, Response } from "express";
import { createMockRequest, createMockResponse } from "../../helpers/request";

import * as echo from "@/server/api/v0/echo";

describe("API Endpoints", () => {
  let mockRequest: Partial<Request>;
  let mockResponse: Partial<Response>;
  let jsonMock: ReturnType<typeof vi.fn>;
  // let statusMock: ReturnType<typeof vi.fn>;

  beforeEach(() => {
    const { res, jsonMock: jMock } = createMockResponse();
    // const { res, jsonMock: jMock, statusMock: sMock } = createMockResponse();
    mockResponse = res;
    jsonMock = jMock;
    // statusMock = sMock;
    mockRequest = createMockRequest();

    vi.clearAllMocks();
  });

  describe("echo", () => {
    it("should return a 200 OK response", () => {
      echo.handler(mockRequest as Request, mockResponse as Response);

      expect(jsonMock).toHaveBeenCalledWith({});
    });
  });
});
