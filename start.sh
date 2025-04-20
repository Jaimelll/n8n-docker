#!/bin/bash

echo "🟢 Levantando servicios..."

docker-compose up -d

sleep 5

NGROK_URL=$(curl --silent http://localhost:4040/api/tunnels | jq -r '.tunnels[] | select(.proto=="https") | .public_url')

if [ -z "$NGROK_URL" ]; then
  echo "❌ No se pudo obtener la URL pública de ngrok."
  exit 1
fi

echo "🌐 URL pública de ngrok: $NGROK_URL"

sed -i "s|^NGROK_URL=.*|NGROK_URL=${NGROK_URL}|" .env


docker-compose restart n8n
