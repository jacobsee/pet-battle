FROM node:14.10 AS appbuild
WORKDIR /usr/src/app
COPY ./ ./
RUN npm ci
RUN npm run build

FROM registry.access.redhat.com/rhscl/nginx-112-rhel7
ARG build_url=default
ARG git_commit=default
ARG git_url=default

LABEL labs.build.url="${build_url}" \
      labs.git.tag="${git_commit}" \
      labs.git.url="${git_url}"

COPY nginx.conf /etc/opt/rh/rh-nginx112/nginx/nginx.conf
COPY --from=appbuild /usr/src/app/dist $HOME
CMD ["nginx", "-g", "daemon off;"]