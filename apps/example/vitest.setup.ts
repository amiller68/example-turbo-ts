import { vi } from "vitest";

// Mock environment variables
vi.mock("@/config", () => ({
  config: {
    server: {
      port: 3000,
      env: "test",
      basePath: undefined,
    },
    log: {
      logLevel: "info",
    },
  },
}));

// Mock logger first since it's imported by other modules
vi.mock("@/services/logger", () => ({
  logger: {
    info: vi.fn(),
    error: vi.fn(),
    warn: vi.fn(),
    debug: vi.fn(),
  },
}));
