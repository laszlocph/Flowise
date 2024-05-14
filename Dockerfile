FROM node:20-alpine

# Install essential packages
RUN apk add --update libc6-compat python3 make g++ \
    && apk add --no-cache chromium nss@edge \
    && rm -rf /var/cache/apk/*

# Install PNPM globally
RUN npm install -g pnpm

# Set environment variables
ENV PUPPETEER_SKIP_DOWNLOAD=true
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser
ENV CHROME_BIN="/usr/bin/chromium-browser" \
    PUPPETEER_SKIP_CHROMIUM_DOWNLOAD="true"

WORKDIR /usr/src

# Copy app source
COPY..

RUN pnpm install

RUN pnpm build

EXPOSE 3000

CMD [ "pnpm", "start" ]
