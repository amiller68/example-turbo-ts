FROM node:20-alpine AS base

FROM base AS builder
RUN apk update
RUN apk add --no-cache libc6-compat
WORKDIR /app
RUN npm i -g turbo@^2
COPY . .

# Use --include-dependencies to include all dependencies
RUN turbo prune example --docker

FROM base AS installer
RUN apk update
# Install all required dependencies for building the canvas package
RUN apk add --no-cache \
    libc6-compat

WORKDIR /app

# Copy pruned files
COPY --from=builder /app/out/json/ .
RUN yarn install --frozen-lockfile

RUN npm i -g turbo@^2
COPY --from=builder /app/out/full/ .
RUN turbo run build --filter=example...

FROM base AS runner
WORKDIR /app

# Install runtime dependencies
RUN apk add --no-cache libc6-compat

# Set up user for security
RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 ex

# Copy everything needed
COPY --from=installer --chown=ex:nodejs /app .

USER ex

# Set environment variables
ENV NODE_ENV=production
EXPOSE 3001

# Run with ts-node to handle TypeScript on the fly
CMD ["node", "apps/example/dist/index.cjs"]
