import app from "@/server";
import http from "http";

import { logger } from "@/services/logger";
import { config } from "@/config";

let server: http.Server;

// Graceful shutdown function
async function shutdown(exitCode = 0, reason = "unknown") {
  logger.info(`index::shutdown -- starting shutdown process`, { reason });

  // Close the HTTP server if it exists
  if (server) {
    logger.info(`index::shutdown -- closing HTTP server`);
    await new Promise<void>((resolve) => {
      server.close(() => resolve());
    });
  }
  logger.info(`index::shutdown -- completed, exiting with code ${exitCode}`);
  process.exit(exitCode);
}

async function main() {
  // TODO (service-setup): its helpful to place any debuggable configuration here!
  logger.info("index::main -- starting", {
    port: config.server.port,
    basePath: config.server.basePath ?? "n/a",
    logLevel: config.log.level,
  });

  // TODO (service-setup): if you need to do any intialization, do it here!
  // await Promise.all([
  //   initMyService(),
  // ]);

  // Start the server
  const port = config.server.port;
  server = app.listen(port, () => {
    logger.info(`index::main -- server started on port ${port}`);
  });
}

// Handle unhandled errors
process.on("uncaughtException", (error) => {
  logger.error("index::main -- uncaught exception", {
    error: error.message,
    stack: error.stack,
  });
  // For now just crash the process, this would trigger a restart
  //  in ECS.
  shutdown(1, `Uncaught exception: ${error.message}`);
});

process.on("unhandledRejection", (reason) => {
  logger.error("index::main -- unhandled rejection", {
    reason: reason instanceof Error ? reason.message : String(reason),
    stack: reason instanceof Error ? reason.stack : undefined,
  });
  // For now just crash the process, this would trigger a restart
  //  in ECS.
  shutdown(
    1,
    `Unhandled rejection: ${reason instanceof Error ? reason.message : String(reason)}`,
  );
});

// Handle termination signals
process.on("SIGTERM", () => {
  logger.info("index::main -- received SIGTERM");
  shutdown(0, "SIGTERM");
});

process.on("SIGINT", () => {
  logger.info("index::main -- received SIGINT");
  shutdown(0, "SIGINT");
});

// Run the application
main().catch((error) => {
  logger.error("index::main -- failed to start", {
    error: error.message,
    stack: error.stack,
  });
  shutdown(1, `Failed to start: ${error.message}`);
});
