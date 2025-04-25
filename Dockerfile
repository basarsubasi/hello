# Use official Node.js LTS as base
FROM node:18-alpine AS builder
WORKDIR /usr/src/app

# Install dependencies in production mode
COPY package*.json ./
RUN npm ci --only=production

# Copy application source
COPY . .

# Inject version into service worker (pre-start)
ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}
RUN node scripts/pre-start.js

# Final image
FROM node:18-alpine
WORKDIR /usr/src/app

# Copy built artifacts and node_modules
COPY --from=builder /usr/src/app ./

# Expose default port
EXPOSE 1122

# Run the server
CMD ["node", "server.js"]