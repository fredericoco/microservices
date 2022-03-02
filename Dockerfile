FROM node:latest

WORKDIR /usr/src/app

COPY /app /usr/src/app

RUN npm install

EXPOSE 3000

CMD ["node", "app.js"]
