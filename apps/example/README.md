# Example Service

Example service.

To set up a new service from this template, copy it into `./apps` and
search for `TODO (service-setup)` for which parts of the code require
your attention!

This example is not a well tested framework! Be sure to be vigilant for bugs.
If you make a significant improvement in a template service that is generic to
this example, consider updating example code as well.

<!-- TODO (service-setup): remember to change the name of the package! -->

## Features

<!-- TODO (service-setup): describe what this service is supposed to do -->

## Environment Variables

<!-- TODO (service-setup): describe how to configure your service -->

The service is configured via the following (defaults listed):

```
PORT=3001 # port to listen on.
BASE_PATH= # only required when running in ECS behind an Application Load Balancer. specifies what prefix to use for all implemented routes to the http server.
ENV=development # node env
LOG_LEVEL=info # log level
LOG_TAIL_TOKEN= # token to use in order to write to logtail. this should be specific to the source set up ahead of time. if not set the service just writes logs to stdout.
EXAMPLE_AUTH_KEY=your-auth-key # an auth key that callers must provide in an `x-api-key` header in requests to the service's API routes
```

## Development

### Running Locally

```bash
# Install dependencies (from the root of the repo)
npm i

# Run in development mode
npm run dev

# Build and run in production mode
npm run build
npm start
```

### Running with Docker

From the root of the repo:

```bash
# Build the Docker image for your local platform
./bin/docker.sh build example

# Build the Docker image for linux/amd-64
./bin/docker.sh build example -p linux/amd-64

# Run the local image marked latest
./bin/docker.sh run example
```

See our wiki on pushing docker images if you'd like to push the built image to ECR for use in AWS.

### Testing

```bash
# Run all tests
npm test

# Run unit tests
npm run test:unit

# Run integration tests
npm run test:integration
```

## API

### Echo Endpoint

Echos the posted json back to the caller

`POST /api/v0/echo`

Headers:

- `x-api-key`: Authentication key

Request Body:

```json
{ any }
```

Response:

```json
{ any }
```
