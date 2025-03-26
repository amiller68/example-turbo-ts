# Use node-20 as a base -- this should match our node version in our
#  package.json
FROM node:20-alpine AS base

# TODO (service-setup): replace the service name with the correct service name.
ARG SERVICE_NAME=example

# 1. prune phase
FROM base AS pruner

# install deps
RUN apk update
RUN apk add --no-cache libc6-compat
WORKDIR /app
RUN npm i -g turbo@^2

# copy over the entire repo (sans .dockerignore matches)
COPY . .

# generate the pruned artifacts required to build the example service
RUN turbo prune ${SERVICE_NAME} --docker

# 2. install + build phase
FROM base AS builder

# install deps
RUN apk update
# Install all required dependencies for building the canvas package
RUN apk add --no-cache \
    libc6-compat 
RUN npm i -g turbo@^2

# declare a workdir (where we run commands / copy resources)
WORKDIR /app

# copy pruned dependency artifacts from the pruner
#  this details everything regarding what packages we need / versions for same
COPY --from=pruner /app/out/json/ .
RUN yarn install --frozen-lockfile

# copy pruned source code to from the pruner
COPY --from=pruner /app/out/full/ .
# Build the example app with its dependencies
RUN turbo run build --filter=${SERVICE_NAME}...

# 3. run phase
FROM base AS runner

# install runtime dependencies
RUN apk add --no-cache \
    curl \
    libc6-compat

WORKDIR /app

# Set up user to run our build
RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 service

# copy everything we need respecting original layout -- 
#  this is very important to get modules to resolve correctly
COPY --from=builder --chown=service:nodejs /app .

# set up our start script
RUN echo "node apps/$SERVICE_NAME/dist/index.cjs" > /app/start.sh
RUN chmod +x /app/start.sh

# set the user
USER service

# Set environment variables
ENV PORT=3000
# TODO (service-setup): set any good defaults for your service here!
EXPOSE 3000

# run our target service with node -- make sure this points
#  to the correct build artifact. 9/10 this should look like
#  `apps/{app-name}/dist/index.cjs`
CMD ["/app/start.sh"]
