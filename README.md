# Example Turbo TypeScript + IaC

Quick and dirty example of building a typescript project
against AWS fargate with opinionated boilerplate + democratic deployments

## Requirements

- node 20.x
- yarn 1.22.22
- turbo ^2

## What's inside?

This Turborepo includes the following packages/apps:

### Apps and Packages

- example: a simple example service that can be configured to run behind an AWS Application Load Balancer proxying to ECS
- @repo/logger: a small logger utility that acts as an example of building internal dependencies for your services
- `@repo/eslint-config`: `eslint` configurations (includes `eslint-config-next` and `eslint-config-prettier`)
- `@repo/typescript-config`: `tsconfig.json`s used throughout the monorepo

### Build

To build all apps and packages, run the following command:

```
cd my-turborepo
yarn build
```

### Develop

To develop all apps and packages, run the following command:

```
cd my-turborepo
yarn dev
```

# Notes

- using aws bucket for state (example-turbo-ts-tf-state)
- using aws dynamo for state (example-turbo-ts-tf-state-lock)
