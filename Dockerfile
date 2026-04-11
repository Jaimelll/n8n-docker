FROM node:20-bookworm-slim

USER root

# 1. Instalamos OCR y herramientas PDF (Debian puro)
RUN apt-get update && apt-get install -y \
    tesseract-ocr \
    tesseract-ocr-spa \
    poppler-utils \
    ghostscript \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 2. Instalamos n8n (¡Ahora tenemos 8GB de espacio para que esto termine!)
RUN npm install -g n8n

# 3. Creamos carpetas para el volumen de 15GB y damos permisos
RUN mkdir -p /data/binary /home/node/.n8n && \
    chown -R node:node /data /home/node/.n8n

USER node
WORKDIR /home/node

EXPOSE 5678

CMD ["n8n"]