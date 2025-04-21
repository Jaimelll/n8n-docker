#!/bin/bash

# Detener y eliminar todo
docker-compose down -v

# Iniciar servicios
docker-compose up -d

# Esperar a que n8n esté listo
echo "⏳ Esperando a que n8n inicie..."
while ! curl -s http://localhost:5678/healthz >/dev/null; do
  sleep 5
done

# Obtener URL de ngrok
NGROK_URL=$(curl -s http://localhost:4040/api/tunnels | jq -r '.tunnels[] | select(.proto=="https").public_url')

echo "✅ URL definitiva: $NGROK_URL"