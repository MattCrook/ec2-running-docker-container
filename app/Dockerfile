# FROM node:13-alpine

# # WORKDIR /usr/src/app
# # copy package.json and package-lock.json into container
# # copy app content into container
# COPY package*.json /usr/app/
# COPY app/* /usr/app/


# # set root dir inside container
# WORKDIR /usr/app

# RUN npm install

# EXPOSE 8080
# CMD ["node", "server.js"]

FROM node:13-alpine

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install

COPY . .

EXPOSE 8080
CMD [ "node", "server.js" ]
