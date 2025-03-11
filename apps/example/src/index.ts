import app from "./server";
import http from "http";

import { logger } from "./services/logger";

let server: http.Server;

// Graceful shutdown function
async function shutdown(exitCode = 0, reason = "unknown") {
  logger.info("shutdown");
  // Close the HTTP server if it exists
  if (server) {
    await new Promise<void>((resolve) => {
      server.close(() => resolve());
    });
  }
  process.exit(exitCode);
}

async function main() {
  await Promise.all([]);

  // Start the server
  const port = 3001;
  server = app.listen(port, () => {
    logger.info("startup");
  });
}

// Handle unhandled errors
process.on("uncaughtException", (error) => {
  shutdown(1, `Uncaught exception: ${error.message}`);
});

process.on("unhandledRejection", (reason) => {
  shutdown(
    1,
    `Unhandled rejection: ${reason instanceof Error ? reason.message : String(reason)}`,
  );
});

// Handle termination signals
process.on("SIGTERM", () => {
  shutdown(0, "SIGTERM");
});

process.on("SIGINT", () => {
  shutdown(0, "SIGINT");
});

// Run the application
main().catch((error) => {
  shutdown(1, `Failed to start: ${error.message}`);
});
