# Use lightweight base
FROM node:18-alpine

# Install newman + reporter
RUN npm install -g newman newman-reporter-html

# Create non-root user
RUN addgroup -S newman && adduser -S newman -G newman

# Set working directory
WORKDIR /etc/newman

# Set permissions
RUN chown -R newman:newman /etc/newman

# Switch to non-root user
USER newman

# Default command (flexible)
CMD ["sh"]