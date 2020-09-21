#!/bin/bash

set -e

# Nginx and module dependencies 
NGINX_VERSION="1.17.9"
NGINX_LUA_MODULE_VERSION="0.10.15"
NGINX_LUA_RESTY_CORE_VERSION="0.1.17"
NGINX_LUA_RESTY_LRUCACHE_VERSION="0.09"
NGINX_NJS_VERSION="0.3.9"
HEADERS_MORE_VERSION="0.33"
LUA_ENABLE="false"
LUAJIT_VERSION="2.0.2"
LUAJIT_MAIN_VERSION="2.0"
LUAJIT_LIB="/usr/local/lib"
LUAJIT_INC="/usr/local/include/luajit-${LUAJIT_MAIN_VERSION}"

PREFIX=$1

# build args
CONFIG_ARGS="\
    --prefix=${PREFIX:-/usr/local/nginx} \
    --error-log-path=/var/log/nginx/error.log \
    --http-log-path=/var/log/nginx/access.log \
    --pid-path=/var/run/nginx.pid \
    --lock-path=/var/run/nginx.lock \
    --http-client-body-temp-path=/var/cache/nginx/client_temp \
    --http-proxy-temp-path=/var/cache/nginx/proxy_temp \
    --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
    --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
    --http-scgi-temp-path=/var/cache/nginx/scgi_temp \
    --user=nginx \
    --group=nginx \
    --with-debug \
    --with-compat \
    --with-file-aio \
    --with-threads \
    --with-http_addition_module \
    --with-http_auth_request_module \
    --with-http_dav_module \
    --with-http_flv_module \
    --with-http_gunzip_module \
    --with-http_gzip_static_module \
    --with-http_mp4_module \
    --with-http_random_index_module \
    --with-http_realip_module \
    --with-http_secure_link_module \
    --with-http_slice_module \
    --with-http_ssl_module \
    --with-http_stub_status_module \
    --with-http_sub_module \
    --with-http_v2_module \
    --with-mail \
    --with-mail_ssl_module \
    --with-stream \
    --with-stream_realip_module \
    --with-stream_ssl_module \
    --with-stream_ssl_preread_module \
    --with-http_geoip_module=dynamic \
    --with-stream_geoip_module=dynamic \
    --with-http_image_filter_module=dynamic \
    --with-http_perl_module=dynamic \
    --with-http_xslt_module=dynamic \
    --add-dynamic-module=/usr/src/njs-${NGINX_NJS_VERSION}/nginx \
    --add-module=/usr/src/headers-more-nginx-module-${HEADERS_MORE_VERSION} \
    "

# download module dependencies
function download(){
    echo -e "\033[32mdownload files...\033[0m"

    download_dir="nginx_src"
    if [ ! -d "${download_dir}" ];then
        mkdir ${download_dir}
    fi

    if [ ! -f "${download_dir}/nginx-${NGINX_VERSION}.tar.gz" ]; then
        curl -fSL http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz \
            -o ${download_dir}/nginx-${NGINX_VERSION}.tar.gz
    fi
    if [ ! -f "${download_dir}/lua-nginx-module-v${NGINX_LUA_MODULE_VERSION}.tar.gz" ]; then
        curl -fSL https://github.com/openresty/lua-nginx-module/archive/v${NGINX_LUA_MODULE_VERSION}.tar.gz \
            -o ${download_dir}/lua-nginx-module-v${NGINX_LUA_MODULE_VERSION}.tar.gz
    fi
    if [ ! -f "${download_dir}/headers-more-nginx-module-v${HEADERS_MORE_VERSION}.tar.gz" ]; then
        curl -fSL https://github.com/openresty/headers-more-nginx-module/archive/v${HEADERS_MORE_VERSION}.tar.gz \
            -o ${download_dir}/headers-more-nginx-module-v${HEADERS_MORE_VERSION}.tar.gz 
    fi
    if [ ! -f "${download_dir}/njs-${NGINX_NJS_VERSION}.tar.gz" ]; then
        curl -fSL https://github.com/nginx/njs/archive/${NGINX_NJS_VERSION}.tar.gz \
            -o ${download_dir}/njs-${NGINX_NJS_VERSION}.tar.gz
    fi
    if [ ! -f "${download_dir}/LuaJIT-${LUAJIT_VERSION}.tar.gz" ] && [ "${LUA_ENABLE}" == "true" ]; then
        curl -fSL http://luajit.org/download/LuaJIT-${LUAJIT_VERSION}.tar.gz \
            -o ${download_dir}/LuaJIT-${LUAJIT_VERSION}.tar.gz
    fi
    if [ ! -f "${download_dir}/lua-resty-core-v${NGINX_LUA_RESTY_CORE_VERSION}.tar.gz" ] && [ "${LUA_ENABLE}" == "true" ]; then
        curl -fSL https://github.com/openresty/lua-resty-core/archive/v${NGINX_LUA_RESTY_CORE_VERSION}.tar.gz \
            -o ${download_dir}/lua-resty-core-v${NGINX_LUA_RESTY_CORE_VERSION}.tar.gz
    fi
    if [ ! -f "${download_dir}/lua-resty-lrucache-v${NGINX_LUA_RESTY_LRUCACHE_VERSION}.tar.gz" ] && [ "${LUA_ENABLE}" == "true" ]; then
        curl -fSL https://github.com/openresty/lua-resty-lrucache/archive/v${NGINX_LUA_RESTY_LRUCACHE_VERSION}.tar.gz \
            -o ${download_dir}/lua-resty-lrucache-v${NGINX_LUA_RESTY_LRUCACHE_VERSION}.tar.gz
    fi
    
    tar -zxC /usr/src -f ${download_dir}/nginx-${NGINX_VERSION}.tar.gz
    tar -zxC /usr/src -f ${download_dir}/headers-more-nginx-module-v${HEADERS_MORE_VERSION}.tar.gz
    tar -zxC /usr/src -f ${download_dir}/njs-${NGINX_NJS_VERSION}.tar.gz

    if [ "${LUA_ENABLE}" == "true" ]; then
        tar -zxC /usr/src -f ${download_dir}/lua-nginx-module-v$NGINX_LUA_MODULE_VERSION.tar.gz
        tar -zxC /usr/src -f ${download_dir}/LuaJIT-$LUAJIT_VERSION.tar.gz
        tar -zxC /usr/src -f ${download_dir}/lua-resty-core-v${NGINX_LUA_RESTY_CORE_VERSION}.tar.gz
        tar -zxC /usr/src -f ${download_dir}/lua-resty-lrucache-v${NGINX_LUA_RESTY_LRUCACHE_VERSION}.tar.gz
    fi
}

# install build dependencies
function install_build_dep(){
    echo -e "\033[32minstall build dependencies...\033[0m"
    apt install build-essential -y
    apt build-dep nginx -y
}

# install Lua
function install_lua(){
    echo -e "\033[32minstall Lua ${LUAJIT_VERSION} ...\033[0m"
    cd /usr/src/LuaJIT-${LUAJIT_VERSION}
    make -j$(getconf _NPROCESSORS_ONLN)
    make install
}    

# install lua-resty-core
function install_lua_resty_core(){
    echo -e "\033[32minstall lua-resty-core ${NGINX_LUA_RESTY_CORE_VERSION} ...\033[0m"
    cd /usr/src/lua-resty-core-${NGINX_LUA_RESTY_CORE_VERSION}
    make install
}

# install lua-resty-lrucache
function install_lua_resty_lrucache(){
    echo -e "\033[32minstall lua-resty-lrucache ${NGINX_LUA_RESTY_LRUCACHE_VERSION} ...\033[0m"
    cd /usr/src/lua-resty-lrucache-${NGINX_LUA_RESTY_LRUCACHE_VERSION}
    make install
}

# install nginx
function install_nginx(){
    echo -e "\033[32minstall nginx ${NGINX_VERSION} ...\033[0m"
    cd /usr/src/nginx-${NGINX_VERSION}
    if [ "${LUA_ENABLE}" == "true" ]; then
        CONFIG_ARGS="${CONFIG_ARGS} --add-module=/usr/src/lua-nginx-module-${NGINX_LUA_MODULE_VERSION}" 
    fi
    ./configure ${CONFIG_ARGS}
    make -j$(getconf _NPROCESSORS_ONLN)
    make install
    mkdir -p /var/cache/nginx/{client_temp,proxy_temp,fastcgi_temp,uwsgi_temp,scgi_temp} 
}

function adduser(){
    echo -e "\033[32madd nginx user ...\033[0m"
    getent group nginx >/dev/null || groupadd -r nginx
    getent passwd nginx >/dev/null || useradd -r -g nginx -s /sbin/nologin -c "nginx user" nginx
    chown -R nginx:nginx /var/cache/nginx
}

# clean
function clean(){
    echo -e "\033[32mcleaning files...\033[0m"
    rm -rf /usr/src/*
}    

download
install_build_dep
if [ "${LUA_ENABLE}" == "true" ]; then
    install_lua
    install_lua_resty_core
    install_lua_resty_lrucache
fi
install_nginx
adduser
clean
