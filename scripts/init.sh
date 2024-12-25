#!/bin/bash
set -e

# Start MinIO server in the background
/usr/bin/minio server /data --console-address ":9001" &

# Wait for MinIO to become ready
echo "Waiting for MinIO to start..."
until curl -s http://minio:9000/minio/health/live; do
  sleep 5
done
echo "MinIO is ready."

# Set the MinIO alias
mc alias set myminio http://minio:9000 minioadmin minioadmin123

# Ensure the bucket exists
mc ls myminio/your-bucket || mc mb myminio/your-bucket

# Add the bucket event notification
mc event add myminio/your-bucket arn:minio:sqs:us-east-1:PRIMARY:amqp

# Keep the container running
wait
