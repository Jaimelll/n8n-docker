FROM node:20-bookworm-slim

USER root

# ============================================================
# 1. INSTALACIÓN DE HERRAMIENTAS NECESARIAS
# ============================================================
RUN apt-get update && apt-get install -y \
    # OCR
    tesseract-ocr \
    tesseract-ocr-spa \
    tesseract-ocr-eng \
    # PDF a imágenes
    poppler-utils \
    # Alternativa para PDFs problemáticos
    ghostscript \
    # Procesamiento de imágenes
    imagemagick \
    # Utilidades adicionales
    wget \
    curl \
    file \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# ============================================================
# 2. CONFIGURAR IMAGEMAGICK (FIX CRÍTICO)
# ============================================================
# Deshabilitar políticas restrictivas que bloquean PDFs
RUN sed -i 's/<policy domain="coder" rights="none" pattern="PDF" \/>/<policy domain="coder" rights="read|write" pattern="PDF" \/>/g' /etc/ImageMagick-*/policy.xml 2>/dev/null || true && \
    sed -i 's/<policy domain="delegate" rights="none" pattern="gs" \/>/<policy domain="delegate" rights="read|write" pattern="gs" \/>/g' /etc/ImageMagick-*/policy.xml 2>/dev/null || true && \
    sed -i 's/rights="none"/rights="read|write"/g' /etc/ImageMagick-*/policy.xml 2>/dev/null || true

# ============================================================
# 3. VERIFICAR INSTALACIÓN (opcional, pero útil para debug)
# ============================================================
RUN echo "=== VERIFICANDO INSTALACIÓN ===" && \
    tesseract --version | head -1 && \
    pdftoppm -v 2>&1 | head -1 && \
    convert --version | head -1 && \
    gs --version && \
    echo "=== INSTALACIÓN COMPLETADA ==="

# ============================================================
# 4. INSTALAR N8N
# ============================================================
RUN npm install -g n8n

# ============================================================
# 5. CREAR DIRECTORIOS Y PERMISOS
# ============================================================
RUN mkdir -p /data/binary /home/node/.n8n && \
    chown -R node:node /data /home/node/.n8n

# ============================================================
# 6. VARIABLES DE ENTORNO POR DEFECTO
# ============================================================
ENV N8N_DEFAULT_BINARY_DATA_MODE=filesystem \
    N8N_BINARY_DATA_STORAGE_PATH=/data/binary

USER node
WORKDIR /home/node

EXPOSE 5678

CMD ["n8n"]