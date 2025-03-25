import { describe, it, expect } from "vitest";
import request from "supertest";
import app from "@/server";
import { config } from "@/config";

describe("Echo API Integration Tests", () => {
  it("should echo the request body successfully", async () => {
    const response = await request(app)
      .post("/api/v0/echo")
      .set("x-api-key", config.secrets.authKey)
      .send({ message: "Hello, world!" });

    expect(response.status).toBe(200);
    expect(response.body).toHaveProperty("message");
    expect(response.body.message).toBe("Hello, world!");
  });

  it("should fail with 401 when no auth key is provided", async () => {
    const response = await request(app)
      .post("/api/v0/echo")
      .send({ message: "Hello, world!" });

    expect(response.status).toBe(401);
  });
});
