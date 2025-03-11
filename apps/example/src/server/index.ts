import express from "express";
import * as api from "./api";
import * as health from "./health";

const app = express();

// Add JSON body parser with increased size limit
app.use(express.json({ limit: "50mb" }));
// Add URL-encoded parser with increased size limit
app.use(express.urlencoded({ limit: "50mb", extended: true }));

// Mount routes
app.use("/health", health.router);
app.use("/api", api.router);

export default app;
