FROM centos:7

ARG NGINX_VER=1.14.2
ARG INST_PATH=/home1/apps
RUN curl -SL http://nginx.org/download/nginx-${NGINX_VER}.tar.gz | tar -xzC ./

ARG NJS_MODULE_FILE_NAME=njs-43b31a943c08
ARG NJS_MODULE_FILE_EXTENSION=.tar.gz
COPY ./${NJS_MODULE_FILE_NAME}${NJS_MODULE_FILE_EXTENSION} ./${NJS_MODULE_FILE_NAME}${NJS_MODULE_FILE_EXTENSION}
RUN tar -xf ${NJS_MODULE_FILE_NAME}${NJS_MODULE_FILE_EXTENSION} && rm -f ${NJS_MODULE_FILE_NAME}${NJS_MODULE_FILE_EXTENSION}
ARG NJS_ADD_MODULE_OPTION="--add-module=/${NJS_MODULE_FILE_NAME}/nginx"

RUN yum install -y gcc-c++ which make pcre-devel pcre openssl-devel openssl mod_ssl libcurl-devel
RUN mkdir -p ${INST_PATH}/nginx-${NGINX_VER} && cd nginx-${NGINX_VER} && ./configure --prefix=${INST_PATH}/nginx-${NGINX_VER} ${NJS_ADD_MODULE_OPTION} && make install && cd ${INST_PATH} && tar -czf nginx.tar.gz nginx-${NGINX_VER}
RUN ln -sf ${INST_PATH}/nginx-${NGINX_VER} ${INST_PATH}/nginx

# nginx conf
COPY ./nginx.conf ${INST_PATH}/nginx/conf
# js file copy
COPY ./njs ${INST_PATH}/nginx/njs

WORKDIR ${INST_PATH}/nginx
ENV PATH="${INST_PATH}/nginx/sbin:${PATH}"
CMD ["nginx", "-g", "daemon off;"]

EXPOSE 80
EXPOSE 443