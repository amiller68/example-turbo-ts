import express from "express";
import { json } from "body-parser";
import * as api from "./api";
import * as health from "./health";
import { authMiddleware } from "@/server/middleware/auth";
import { config } from "@/config";
const app = express();

const STATUS_PATH = "/_status";
const API_PATH = "/api";

app.use(json());

// NOTE: this base path is what allows your service to be proxied behind
//  an Application Load Balancer in ECS.
if (config.server.basePath) {
  const _router = express.Router();
  _router.use(STATUS_PATH, health.router);
  _router.use(API_PATH, authMiddleware, api.router);
  app.use(config.server.basePath, _router);
} else {
  app.use(STATUS_PATH, health.router);
  app.use(API_PATH, authMiddleware, api.router);
}

export default app;
