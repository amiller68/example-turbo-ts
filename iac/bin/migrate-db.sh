#!/bin/bash

# NOTE: we don't need this anymore since everything is fully migrated to neon
#  this is left here for reference

# # Temporary script for migrating from vercel to neon
# #  How you should use this:
# #  - run `./bin/tf <stage> apply` to create the neon db
# #  This should provision the neon db for the target stage and set up the infisical secrets
# #   to store a connection string for the neon db (set in NEON_DATABASE_CONNECTION_URI). Then run:
# #  - run `./bin/migrate-db.sh <stage>` to migrate the data
# #  This should dump / restore the database pointed at by POSTGRES_URL_NON_POOLING (should be a non-pooled connection string to neon-managed vercel db)
# #   to the neon db pointed at by NEON_DATABASE_CONNECTION_URI.
# #  At this point the neon db is ready to be used with the configured stage, but before
# #   that can happen, we need to updated the infisical secrets to point to the neon db.
# #   these annoyingly cannot be updated by IaC, so you need to do this manually.
# #   importantly, everything should map neatly to the vars the next js app expects:
# #     - NEON_DATABASE_CONNECTION_URI_PRISMA -> POSTGRES_PRISMA_URL
# #     - NEON_DATABASE_CONNECTION_URI -> POSTGRES_URL_NON_POOLING -- make sure to append ?sslmode=require when doing this
# #   these next few are not as important, so feel free to update them later:
# #     - NEON_DATABASE_CONNECTION_URI_POOLED -> POSTGRES_URL
# #     - NEON_DATABASE_HOST_POOLED -> POSTGRES_HOST
# #     - NEON_DATABASE_NAME -> POSTGRES_DATABASE
# #     - NEON_DATABASE_USER -> POSTGRES_USER
# #     - NEON_DATABASE_PASSWORD -> POSTGRES_PASSWORD
# #  So long as vercel is sourcing the synced environment from infisical,
# #  the redeployed app will use the neon db.
# #  NOTE: we've experienced some issues with vercel not using the updated infisical secrets, so 
# #   there might be an unknown amount of downtime before the app is ready to be redeployed :(

# set -e

# SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# # Source the environment mappings
# source "$SCRIPT_DIR/env-mappings.sh"

# # Print usage
# usage() {
#     echo "Usage: $0 <environment>"
#     echo "Example: $0 staging"
#     echo
#     echo "Available environments: staging, production"
#     exit 1
# }

# # Validate target environment
# validate_env() {
#     local env=$1
#     case $env in
#         development|staging|production)
#             return 0
#             ;;
#         *)
#             echo "Error: Invalid environment '$env'"
#             echo "Valid environments are: development, staging, production"
#             exit 1
#             ;;
#     esac
# }

# # Check if environment argument is provided
# if [ $# -ne 1 ]; then
#     echo "Error: Environment argument is required"
#     usage
# fi

# TARGET_ENV=$1

# # Validate environment
# validate_env "$TARGET_ENV"

# # Function to get database URLs using Infisical
# get_db_url() {
#     local env=$1
#     local key=$2
#     local infisical_env=$(map_to_infisical_env "$env")
#     infisical export --env="$infisical_env" --format=dotenv | grep "^$key=" | cut -d '=' -f2- | tr -d "'"
# }

# # Get source (current) and target database URLs
# echo "Fetching database credentials..."
# SOURCE_URL="$(get_db_url "$TARGET_ENV" "POSTGRES_URL_NON_POOLING")"
# TARGET_URL="$(get_db_url "$TARGET_ENV" "NEON_DATABASE_CONNECTION_URI")"

# # Add sslmode if not present
# if [[ ! "$SOURCE_URL" =~ "sslmode=" ]]; then
#     SOURCE_URL="${SOURCE_URL}?sslmode=require"
# fi
# if [[ ! "$TARGET_URL" =~ "sslmode=" ]]; then
#     TARGET_URL="${TARGET_URL}?sslmode=require"
# fi

# if [ -z "$SOURCE_URL" ] || [ -z "$TARGET_URL" ]; then
#     echo "Error: Failed to fetch database URLs from Infisical"
#     exit 1
# fi

# # Function to mask password in URL
# mask_password() {
#     echo "$1" | sed -E 's/(:.*@)/:****@/'
# }

# # Show masked URLs and ask for confirmation
# echo
# echo "Migration Details:"
# echo "Environment: $TARGET_ENV"
# echo "Source DB (Current): $(mask_password "$SOURCE_URL")"
# echo "Target DB (Neon): $(mask_password "$TARGET_URL")"
# echo
# echo "⚠️  WARNING: This will overwrite the target database!"
# echo "Are you sure you want to proceed with the migration? (y/n)"
# read -r confirm

# if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
#     echo "Migration cancelled."
#     exit 1
# fi

# # Create backup directory if it doesn't exist
# BACKUP_DIR="$SCRIPT_DIR/../backups"
# mkdir -p "$BACKUP_DIR"

# echo "Starting migration to $TARGET_ENV..."
# echo "Creating backup..."

# # Create a timestamped backup file
# BACKUP_FILE="$BACKUP_DIR/${TARGET_ENV}_backup_$(date +%Y%m%d_%H%M%S).dump"

# # Perform the backup
# if ! pg_dump --clean --if-exists --format=c --no-owner --no-acl "$SOURCE_URL" > "$BACKUP_FILE"; then
#     echo "Backup failed!"
#     exit 1
# fi

# echo "Backup created successfully: $BACKUP_FILE"
# echo "Starting restore to target database..."

# # Perform the restore
# if ! pg_restore --no-owner --no-acl -d "$TARGET_URL" "$BACKUP_FILE"; then
#     echo "Restore failed!"
#     echo "Backup file is stored at: $BACKUP_FILE"
#     exit 1
# fi

# echo "Migration completed successfully!"
# echo "Backup file is stored at: $BACKUP_FILE"

# # Basic verification
# echo "Performing basic verification..."
# psql "$TARGET_URL" -c "SELECT count(*) as table_count FROM information_schema.tables WHERE table_schema = 'public';"

# Run migrations
echo "Running main database migrations..."
npx prisma migrate deploy --schema=./prisma/schema.prisma

echo "Running geo database migrations..."
npx prisma migrate deploy --schema=./packages/geo-db/prisma/schema.prisma 