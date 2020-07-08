FROM node:10.13-alpine
ENV NODE_ENV production
WORKDIR /usr/src/app
COPY ["package.json", "./"]
RUN npm install --production --silent && mv node_modules ../
COPY . .
EXPOSE 5000
CMD node app.js