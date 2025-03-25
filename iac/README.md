# iac

This module is responsible for provisioning infrastructure.

## Dependencies

required services:

- terraform cloud / hashicorp compute platform

tools:

- hcp cli
- terraform cli

## Overview

we maintain staging and production environments in terraform.

state is managed in terraform cloud. this module expects a single shared project called 'example-turbo' for the two environments, each of which is manged in a separate workspace ('staging' and 'production'). each workspace should be configured to use local execution.

secrets are injected and stored in hcp vault secrets. you can store your deployment access key and secret key here to make them available
 to authorized developers.

## Modules

- [envs](./envs): manages the configuration for specific stages, and defines
  a common module for all provisioned infrastructure. See [the common module](./envs/common) for more details on how we configure our stage-specific infrastructure.
- aws: describes our defaults for setting up our environments on AWS

## Setup

we assume you have a hashicorp account and your device is logged in via the hcp cli

### Terraform Cloud

- create a project called 'example-turbo' and your two workspaces, 'staging' and 'production'.
- in order for everything to work out of the box, you need to set up the following:
  - organization name is `example-turbo`
  - staging workspace name is `staging`
  - production workspace name is `production`
  <!-- TODO: update this to use remote execution when we have a better setup -->
  - both workspaces should be configured to use local execution
- login to the terraform cli with `terraform login`

## Usage

### Terraform

we provide a helper script that will run your terraform commands against the correct stage.

from this directory, you can run:

```bash
./bin/tf <stage> <command>
```

where `<stage>` is one of `staging` or `production` and `<command>` is the terraform command you wish to run.

for example, to initialize the staging workspace within your local environment, you can run:

```bash
./bin/tf staging init
```
