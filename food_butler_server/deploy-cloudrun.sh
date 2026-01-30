#!/bin/bash
set -e

# Cloud Run Deployment Script for Off Menu Serverpod Server
# Project: offmenu-backend
# Region: us-central1

PROJECT_ID="offmenu-backend"
REGION="us-central1"
SERVICE_NAME="offmenu-api"
SERVICE_ACCOUNT="offmenu-cloudrun@offmenu-backend.iam.gserviceaccount.com"

# Get the Cloud SQL connection name
INSTANCE_CONNECTION_NAME=$(gcloud sql instances describe offmenu-db --format='value(connectionName)' 2>/dev/null)

if [ -z "$INSTANCE_CONNECTION_NAME" ]; then
    echo "Error: Could not get Cloud SQL connection name. Is the instance created?"
    exit 1
fi

echo "Using Cloud SQL instance: $INSTANCE_CONNECTION_NAME"

# Build and push the container
echo "Building and pushing container..."
gcloud builds submit --tag gcr.io/$PROJECT_ID/$SERVICE_NAME .

# Deploy to Cloud Run
echo "Deploying to Cloud Run..."
gcloud run deploy $SERVICE_NAME \
    --image gcr.io/$PROJECT_ID/$SERVICE_NAME \
    --platform managed \
    --region $REGION \
    --service-account $SERVICE_ACCOUNT \
    --add-cloudsql-instances $INSTANCE_CONNECTION_NAME \
    --set-env-vars "runmode=production,serverid=default,logging=normal,role=monolith" \
    --set-secrets "SERVERPOD_DATABASE_PASSWORD=offmenu-db-password:latest,SERVERPOD_PASSWORDS=offmenu-passwords:latest" \
    --port 8080 \
    --allow-unauthenticated \
    --min-instances 0 \
    --max-instances 10 \
    --memory 512Mi \
    --cpu 1

# Get the service URL
SERVICE_URL=$(gcloud run services describe $SERVICE_NAME --region $REGION --format='value(status.url)')
echo ""
echo "Deployment complete!"
echo "API URL: $SERVICE_URL"
echo ""
echo "Next steps:"
echo "1. Update your Flutter app's config to use: $SERVICE_URL"
echo "2. Add $SERVICE_URL to Google OAuth authorized origins"
