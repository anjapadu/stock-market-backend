FROM node:8

WORKDIR /usr/src/app
COPY package*.json ./

RUN npm install

COPY ./dist/* .

EXPOSE 3035

CMD ["npm", "run", "production start"]