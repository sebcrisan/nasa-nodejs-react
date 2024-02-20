FROM node:lts-alpine

WORKDIR /app

# Install root level dependencies
COPY package*.json ./
RUN npm install --only=production

# Install client dependencies and build the client
COPY client/package*.json client/
RUN npm run install-client --omit=dev

# Install server dependencies
COPY server/package*.json server/
RUN npm run install-server --omit=dev

# Copy and build client
COPY client/ client/
RUN npm run build-unix --prefix client

# Copy the client build artifacts to server public directory before switching to node user
RUN mkdir -p server/public && cp -r client/build/* server/public/

# Copy server files
COPY server/ server/

USER node

CMD ["npm", "start", "--prefix", "server"]

EXPOSE 8000
