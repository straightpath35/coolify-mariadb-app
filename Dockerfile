# Dockerfile (place in repo root)
FROM node:18-alpine

# Create app dir
WORKDIR /usr/src/app

# Install dependencies (use lockfile if present, else fall back and show verbose logs)
COPY package.json package-lock.json* ./

RUN if [ -f package-lock.json ]; then \
      echo "package-lock.json found — running npm ci"; \
      npm ci --omit=dev --loglevel verbose; \
    else \
      echo "no package-lock.json — running npm install (fallback)"; \
      npm install --omit=dev --loglevel verbose; \
    fi


# Copy source
COPY . .

# Create uploads dir and ensure permissions
RUN mkdir -p /usr/src/app/uploads && chown -R node:node /usr/src/app/uploads

USER node
EXPOSE 3000

CMD ["node", "server.js"]
