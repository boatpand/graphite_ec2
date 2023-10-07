FROM node:lts as base

FROM base as DEV
WORKDIR /app
COPY . .
RUN npm install
CMD ["node", "index.js"]

FROM base as UAT
WORKDIR /app
COPY . .
RUN npm install
CMD ["node", "index.js"]

FROM base as Production
WORKDIR /app
COPY . .
RUN npm install
CMD ["node", "index.js"]