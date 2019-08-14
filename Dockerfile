FROM ubuntu:xenial-20190425
MAINTAINER Peter Herbert <p-herbert>

# Tini version
ARG TINI_VERSION=0.18.0
ENV TINI_VERSION=${TINI_VERSION}

# Add Tini
ADD https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini /tini
RUN chmod +x /tini
ENTRYPOINT ["/tini", "--"]

# Node version
ARG NODE_VERSION=10.15.3
ENV NODE_VERSION=${NODE_VERSION}

# Install dependencies
RUN apt-get update && \
    # PhantomJS needs libfontconfig and bzip2
    apt-get install -y libfontconfig bzip2 curl unzip && \
    # Install nvm and NodeJS
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash && \
    # Install Puppeteer dependencies
    apt-get install -y libx11-xcb1 libxrandr2 libasound2 libpangocairo-1.0-0 libatk1.0-0 libatk-bridge2.0-0 libgtk-3-0 libnss3 libxss1 && \
    # Install emoji fonts
    curl -Lo /tmp/emojis.zip https://noto-website-2.storage.googleapis.com/pkgs/NotoEmoji-unhinted.zip && \
    mkdir -p ~/.fonts && \
    unzip /tmp/emojis.zip "*.ttf" -d ~/.fonts && \
    # Flush the font cache
    fc-cache -f -v && \
    # Clean up
    rm -rf /var/lib/apt/lists/*

# Add NodeJS and npm to PATH
ENV PATH /root/.nvm/versions/node/v${NODE_VERSION}/bin:$PATH

# Create app directory
WORKDIR /usr/src/app

# Cache package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm ci --only=production

# Copy build
COPY . .

# Environment
ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}

# Start server
EXPOSE 8080
CMD [ "npm", "start" ]
