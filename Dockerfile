# ---- Build Stage ----
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install --legacy-peer-deps
COPY . .
RUN npm run build

# ---- Runtime Stage ----
FROM nginx:stable-alpine AS runtime
COPY --from=builder /app/dist /usr/share/nginx/html

# Replace default nginx config to handle SPA routing and API proxy
RUN rm -rf /etc/nginx/conf.d/*
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
