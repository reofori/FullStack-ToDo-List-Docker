#!/bin/bash

echo "Running Container Tests..."

# Test if all containers are running
echo "Checking running containers..."
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

# Test Backend API (Ensure it's reachable)
echo "Testing Backend API..."
BACKEND_PORT=3000
BACKEND_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:$BACKEND_PORT)
if [ "$BACKEND_STATUS" -eq 200 ]; then
  echo "Backend is running on port $BACKEND_PORT and reachable!"
else
  echo "Backend is NOT reachable on port $BACKEND_PORT! Status Code: $BACKEND_STATUS"
fi

# Test Database Connection (Ensure MongoDB container is running)
echo "Testing MongoDB connection..."
DATABASE_PORT=27017
docker exec -it mongodb_container mongosh --eval "db.stats()" &>/dev/null
if [ $? -eq 0 ]; then
  echo "MongoDB is running on port $DATABASE_PORT and connected!"
else
  echo "MongoDB is NOT reachable on port $DATABASE_PORT!"
fi

# Test Frontend Access
echo "Testing Frontend Access..."
FRONTEND_PORT=5173
FRONTEND_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:$FRONTEND_PORT)
if [ "$FRONTEND_STATUS" -eq 200 ]; then
  echo "Frontend is running on port $FRONTEND_PORT!"
else
  echo "Frontend is NOT reachable on port $FRONTEND_PORT! Status Code: $FRONTEND_STATUS"
fi

echo "All tests completed!"
