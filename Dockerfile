FROM node:20 AS frontend-builder
WORKDIR /usr/src/frontend
COPY frontend/package*.json frontend/pnpm-lock.yaml ./
ENV VITE_USER_NAME={VITE_USER_NAME}
RUN npm install -g pnpm && pnpm install
COPY ./frontend/ .
EXPOSE 5173


FROM node:20 AS backend
WORKDIR /usr/src/backend
COPY backend/package*.json backend/pnpm-lock.yaml ./
RUN npm install -g pnpm && pnpm install
COPY ./backend/ .
EXPOSE 3000

FROM nginx:latest
RUN apt-get update && apt-get install -y gettext-base
COPY nginx/nginx.conf /etc/nginx/nginx.conf
CMD /bin/bash -c "envsubst '\$USER_NAME' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf && exec nginx -g 'daemon off;'"