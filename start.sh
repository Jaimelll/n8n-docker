#!/bin/bash

# Cargar variables desde .env para usarlas en el script (si es necesario)
set -a # automatically export all variables
source .env
set +a

echo "🛑 Deteniendo contenedores existentes..."
# docker-compose down -v # Descomenta -v para eliminar volúmenes también
docker-compose down

echo "🚀 Iniciando servicios n8n y ngrok..."
docker-compose up -d

echo "⏳ Esperando a que n8n inicie (http://localhost:5678)..."
while ! curl -s --fail http://localhost:5678/healthz > /dev/null; do
  echo -n "."
  sleep 5
done
echo "" # Nueva línea

echo "⏳ Esperando a que ngrok inicie y conecte..."
sleep 5 # Darle tiempo a ngrok

echo "✅ ¡Configuración completada!"
echo "   ➡️ n8n debería estar accesible localmente en: http://localhost:5678"
echo "   ➡️ Tu URL pública estática (para webhooks) es: https://${N8N_STATIC_DOMAIN}/"
echo "   ➡️ Puedes ver el estado de ngrok en: http://localhost:4040"