FROM node:10

WORKDIR /usr/src/app
COPY package*.json ./

RUN npm install --production

COPY ./dist/* ./

RUN ls

EXPOSE 5015 5020

CMD ["node", "server.js"]