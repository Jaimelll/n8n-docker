#!/bin/bash

# Detener y eliminar todo
docker-compose down -v

# Iniciar solo ngrok primero (no n8n)
docker-compose up -d ngrok

# Esperar a que ngrok inicie
echo "⏳ Esperando a que ngrok inicie..."
until curl -s http://localhost:4040/api/tunnels >/dev/null; do
  sleep 2
done

# Obtener la URL pública de ngrok
NGROK_URL=$(curl -s http://localhost:4040/api/tunnels | jq -r '.tunnels[] | select(.proto=="https") | .public_url')

echo "✅ URL pública obtenida de ngrok: $NGROK_URL"

# Exportar la URL para docker-compose
export WEBHOOK_URL_PLACEHOLDER=N8N_PUBLIC_API_WEBHOOK_URL=$NGROK_URL

# Ahora iniciar n8n pasando la URL correcta
docker-compose up -d n8n

# Mostrar URL final
echo "🌐 n8n Webhook URL: $NGROK_URL"
