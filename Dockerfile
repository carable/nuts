FROM mhart/alpine-node:5.8.0

# patchy mcpatchface
RUN apk update \
    && apk add python py-pip jq curl bash \
    && rm -rf /var/cache/apk/*

# set up tool for accessing parameter store data
ENV AWS_DEFAULT_REGION=us-west-2
RUN pip install awscli && \
  curl -sL https://gist.github.com/rafaelmagu/782e1a6e3e1e70799e38682f9cf069e1/raw/065a6de34b1e42ec1229ab00cd09c684e4662304/ssm-params-to-env.sh > /usr/local/bin/ssm-params-to-env.sh && \
  chmod +x /usr/local/bin/ssm-params-to-env.sh

# Switch to /app
WORKDIR /app
# Install deps
COPY package.json ./
RUN npm install --production
# Copy source
COPY . ./

# Ports
ENV PORT 80
EXPOSE 80

ENTRYPOINT ["npm", "start"]
