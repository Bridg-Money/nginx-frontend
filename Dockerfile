# Base NGINX image
FROM nginx:alpine AS final

# Create target directory
WORKDIR /usr/share/nginx/html

# ------------------------------
# Stage 1: Copy from admin-ui image
FROM paypass-admin-ui:latest AS admin

# ------------------------------
# Stage 2: Copy from services-ui image
FROM paypass-services-ui:latest AS services

# ------------------------------
# Stage 3: Copy builds and configure NGINX
FROM nginx:alpine

# Create folders and copy certs
RUN mkdir -p /usr/share/nginx/html/admin /usr/share/nginx/html/services /etc/nginx/certs

# Copy builds from admin and services
COPY --from=admin /app/paypass-admin-ui/build /usr/share/nginx/html/admin
COPY --from=services /app/paypass-services-ui/build /usr/share/nginx/html/services

# Copy nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy SSL certs
COPY certs/ /etc/nginx/certs/

# Start nginx
CMD ["nginx", "-g", "daemon off;"]