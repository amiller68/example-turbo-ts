import { describe, it, expect, vi, beforeEach } from "vitest";
import { Request, Response } from "express";
import { createMockRequest, createMockResponse } from "../../helpers/request";

import * as livez from "@/server/health/livez";
import * as readyz from "@/server/health/readyz";
import * as versionz from "@/server/health/versionz";

describe("Health Endpoints", () => {
  let mockRequest: Partial<Request>;
  let mockResponse: Partial<Response>;
  let jsonMock: ReturnType<typeof vi.fn>;
  // let statusMock: ReturnType<typeof vi.fn>;

  beforeEach(() => {
    // const { res, jsonMock: jMock, statusMock: sMock } = createMockResponse();
    const { res, jsonMock: jMock } = createMockResponse();
    mockResponse = res;
    jsonMock = jMock;
    // statusMock = sMock;
    mockRequest = createMockRequest();

    vi.clearAllMocks();
  });

  describe("livez", () => {
    it("should return a 200 OK response", () => {
      livez.handler(mockRequest as Request, mockResponse as Response);

      expect(jsonMock).toHaveBeenCalledWith({ status: "ok" });
    });
  });

  describe("readyz", () => {
    it("should return a 200 OK response with system info", async () => {
      await readyz.handler(mockRequest as Request, mockResponse as Response);
      expect(jsonMock).toHaveBeenCalledWith(
        expect.objectContaining({
          status: "ok",
          timestamp: expect.any(String),
          uptime: expect.any(Number),
          memory: expect.any(Object),
        }),
      );
    });
    // TODO: add example of a failed check -- this example service
    //   however does not have any dependencies that would fail!
  });

  describe("versionz", () => {
    it("should return a 200 OK response with version info", async () => {
      await versionz.handler(mockRequest as Request, mockResponse as Response);
      expect(jsonMock).toHaveBeenCalledWith(expect.any(Object));
      expect(jsonMock).toHaveBeenCalledWith({
        status: "ok",
        timestamp: expect.any(String),
        node_version: expect.any(String),
        arch: expect.any(String),
        platform: expect.any(String),
        version: expect.any(String),
      });
    });
  });
});
