FROM node:20-bookworm-slim

# 1. Instalamos las herramientas de OCR y PDF usando la sintaxis de Debian
RUN apt-get update && apt-get install -y \
    tesseract-ocr \
    tesseract-ocr-spa \
    poppler-utils \
    ghostscript \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 2. Instalamos n8n globalmente (usando Node 20, que es el estándar actual para n8n)
RUN npm install -g n8n

# 3. Creamos las carpetas y asignamos los permisos al usuario 'node' (incluido por defecto en la imagen de Node)
RUN mkdir -p /data/binary /home/node/.n8n && \
    chown -R node:node /data /home/node/.n8n

# 4. Cambiamos al usuario sin privilegios para operar de forma segura
USER node
WORKDIR /home/node

EXPOSE 5678

CMD ["n8n"]