# Build local monorepo image
docker build --no-cache -t flowise.

# Run image
docker run -d -p 3000:3000 flowise

# Use the official Node.js 20 image based on Alpine Linux
FROM node:20-alpine

# Install essential packages for building software
RUN apk add --update libc6-compat python3 make g++ \
    && rm -rf /var/cache/apk/*

# Install Chromium for PDF rendering
RUN apk add --no-cache chromium

# Install PNPM globally
RUN npm install -g pnpm

# Set environment variables to skip Puppeteer download and specify the executable path
ENV PUPPETEER_SKIP_DOWNLOAD=true
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

# Set the working directory inside the container
WORKDIR /usr/src

# Copy the application source code into the container
COPY . .

# Install dependencies using PNPM
RUN pnpm install

# Build the application
RUN pnpm build

# Expose port 3000 for the application
EXPOSE 3000

# Start the application
CMD [ "pnpm", "start" ]
