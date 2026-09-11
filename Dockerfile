# Use lightweight Nginx web server
FROM nginx:alpine

# Copy HTML static files to default Nginx serving path
COPY index.html /usr/share/nginx/html/index.html

# Expose port 80
EXPOSE 80
