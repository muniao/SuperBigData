#!/bin/bash

set -e

# Tengine and module dependencies 
TENGINE_VERSION="2.2.0"
NGINX_LUA_MODULE_VERSION="0.2.0"
OPENSSL_VERSION="1.0.2j"
HEADERS_MORE_VERSION="0.32"
UPSTREAM_CHECK_VERSION="0.3.0"
DEVEL_KIT_VERSION="0.3.0"
NGINX_CT_VERSION="1.3.2"
LUAJIT_VERSION="2.0.4"
LUAJIT_MAIN_VERSION="2.0"
LUAJIT_LIB="/usr/local/lib"
LUAJIT_INC="/usr/local/include/luajit-$LUAJIT_MAIN_VERSION"

PREFIX=$1

# build args
CONFIG_ARGS="\
    --prefix=${PREFIX:-/usr/local/tengine} \
    --pid-path=/var/run/nginx.pid \
    --lock-path=/var/run/nginx.lock \
    --with-http_ssl_module \
    --with-http_realip_module \
    --with-http_addition_module \
    --with-http_sub_module \
    --with-http_dav_module \
    --with-http_flv_module \
    --with-http_mp4_module \
    --with-http_gunzip_module \
    --with-http_gzip_static_module \
    --with-http_random_index_module \
    --with-http_secure_link_module \
    --with-http_stub_status_module \
    --with-http_auth_request_module \
    --with-threads \
    --with-http_slice_module \
    --with-mail \
    --with-mail_ssl_module \
    --with-file-aio \
    --with-http_v2_module \
    --with-openssl=/usr/src/openssl-${OPENSSL_VERSION} \
    --add-module=/usr/src/lua-nginx-module-${NGINX_LUA_MODULE_VERSION} \
    --http-client-body-temp-path=/tmp/client_body_temp \
    --http-proxy-temp-path=/tmp/proxy_temp \
    --http-fastcgi-temp-path=/tmp/fastcgi_temp \
    --http-uwsgi-temp-path=/tmp/uwsgi_temp \
    --http-scgi-temp-path=/tmp/scgi_temp \
    "

# install build dependencies
function _installdep(){
    echo -e "\033[32minstall build dependencies...\033[0m"
    yum install gcc glibc glibc-devel make pcre \
        pcre-devel zlib zlib-devel kernel-devel \
        curl gnupg libxslt libxslt-devel gd-devel \
        geoip-devel perl-devel perl-ExtUtils-Embed \
        lua lua-devel patch -y
}

# download module dependencies
function _downloadfiles(){
    echo -e "\033[32mdownload module dependencies...\033[0m"
    curl -fSL http://tengine.taobao.org/download/tengine-${TENGINE_VERSION}.tar.gz -o tengine.tar.gz
    curl -fSL https://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz -o openssl-${OPENSSL_VERSION}.tar.gz
    curl -fSL https://github.com/openresty/lua-nginx-module/archive/v${NGINX_LUA_MODULE_VERSION}.tar.gz -o lua-nginx-module-v${NGINX_LUA_MODULE_VERSION}.tar.gz
    curl -fSL https://github.com/openresty/headers-more-nginx-module/archive/v${HEADERS_MORE_VERSION}.tar.gz -o headers-more-nginx-module-v${HEADERS_MORE_VERSION}.tar.gz 
    curl -fSL https://github.com/yaoweibin/nginx_upstream_check_module/archive/v${UPSTREAM_CHECK_VERSION}.tar.gz -o nginx_upstream_check_module-v${UPSTREAM_CHECK_VERSION}.tar.gz
    curl -fSL https://github.com/simpl/ngx_devel_kit/archive/v${DEVEL_KIT_VERSION}.tar.gz -o ngx_devel_kit-v${DEVEL_KIT_VERSION}.tar.gz
    curl -fSL http://luajit.org/download/LuaJIT-$LUAJIT_VERSION.tar.gz -o LuaJIT-$LUAJIT_VERSION.tar.gz
    curl -fSL https://raw.githubusercontent.com/cloudflare/sslconfig/master/patches/openssl__chacha20_poly1305_draft_and_rfc_ossl102j.patch -o openssl__chacha20_poly1305_draft_and_rfc_ossl102j.patch
    #curl -fSL https://raw.githubusercontent.com/cloudflare/sslconfig/master/patches/nginx__dynamic_tls_records.patch -o nginx__dynamic_tls_records.patch
    #curl -fSL https://raw.githubusercontent.com/cloudflare/sslconfig/master/patches/nginx__http2_spdy.patch -o nginx__http2_spdy.patch
    curl -fSL https://github.com/grahamedgecombe/nginx-ct/archive/v${NGINX_CT_VERSION}.tar.gz -o nginx-ct-v${NGINX_CT_VERSION}.tar.gz
    
    tar -zxC /usr/src -f tengine.tar.gz
    tar -zxC /usr/src -f openssl-${OPENSSL_VERSION}.tar.gz
    tar -zxC /usr/src -f lua-nginx-module-v${NGINX_LUA_MODULE_VERSION}.tar.gz
    tar -zxC /usr/src -f headers-more-nginx-module-v${HEADERS_MORE_VERSION}.tar.gz
    tar -zxC /usr/src -f nginx_upstream_check_module-v${UPSTREAM_CHECK_VERSION}.tar.gz
    tar -zxC /usr/src -f lua-nginx-module-v$NGINX_LUA_MODULE_VERSION.tar.gz
    tar -zxC /usr/src -f ngx_devel_kit-v${DEVEL_KIT_VERSION}.tar.gz
    tar -zxC /usr/src -f LuaJIT-$LUAJIT_VERSION.tar.gz
    tar -zxC /usr/src -f nginx-ct-v${NGINX_CT_VERSION}.tar.gz
    
    rm -f tengine.tar.gz
    rm -f openssl-${OPENSSL_VERSION}.tar.gz
    rm -f lua-nginx-module-v${NGINX_LUA_MODULE_VERSION}.tar.gz
    rm -f headers-more-nginx-module-v${HEADERS_MORE_VERSION}.tar.gz
    rm -f nginx_upstream_check_module-v${UPSTREAM_CHECK_VERSION}.tar.gz
    rm -f ngx_devel_kit-v${DEVEL_KIT_VERSION}.tar.gz
    rm -f LuaJIT-$LUAJIT_VERSION.tar.gz
    rm -f nginx-ct-v${NGINX_CT_VERSION}.tar.gz

    #mv nginx__dynamic_tls_records.patch /usr/src/nginx-${NGINX_VERSION}
    #mv nginx__http2_spdy.patch /usr/src/nginx-${NGINX_VERSION}
    mv openssl__chacha20_poly1305_draft_and_rfc_ossl102j.patch  /usr/src/openssl-${OPENSSL_VERSION}

}

# patch to nginx
function _patch_nginx(){
    echo -e "\033[32mpatch to nginx...\033[0m"
    cd /usr/src/nginx-$NGINX_VERSION
    patch -p1 < nginx__dynamic_tls_records.patch
    patch -p1 < nginx__http2_spdy.patch
}

# patch to openssl
function _patch_openssl(){
    echo -e "\033[32mpatch to openssl...\033[0m"
    cd /usr/src/openssl-${OPENSSL_VERSION}
    patch -p1 < openssl__chacha20_poly1305_draft_and_rfc_ossl102j.patch
}


# install openssl
function install_openssl(){
    echo -e "\033[32minstall openssl $OPENSSL_VERSION ...\033[0m"
    cd /usr/src/openssl-${OPENSSL_VERSION}
    ./config shared zlib-dynamic
    make && make install

    echo -e "\033[32mbackup old files...\033[0m"
    mv /usr/bin/openssl /usr/bin/openssl.old || true
    mv /usr/include/openssl /usr/include/openssl.old || true

    # link new file
    ln -s /usr/local/ssl/bin/openssl  /usr/bin/openssl
    ln -s /usr/local/ssl/include/openssl  /usr/include/openssl

    mv /usr/lib/libssl.so /usr/lib/libssl.so.old || true
    mv /usr/local/lib64/libssl.so /usr/local/lib64/libssl.so.old || true

    # link new lib
    ln -s /usr/local/ssl/lib/libssl.so /usr/lib/libssl.so
    ln -s /usr/local/ssl/lib/libssl.so /usr/local/lib64/libssl.so

    # reload lib
    echo "/usr/local/ssl/lib" >> /etc/ld.so.conf
    ldconfig -v
}

# install Lua
function install_lua(){
    echo -e "\033[32minstall Lua $LUAJIT_VERSION ...\033[0m"
    cd /usr/src/LuaJIT-$LUAJIT_VERSION
    make -j$(getconf _NPROCESSORS_ONLN)
    make install
}    

# install nginx
function install_nginx(){
    echo -e "\033[32minstall nginx $NGINX_VERSION ...\033[0m"
    cd /usr/src/tengine-$TENGINE_VERSION
    ./configure $CONFIG_ARGS --with-debug
    make -j$(getconf _NPROCESSORS_ONLN)
    make install
}

# clean
function _clean(){
    echo -e "\033[32mcleaning files...\033[0m"
    rm -rf /usr/src/*
}    

_installdep
_downloadfiles
#_patch_nginx
_patch_openssl
install_openssl
install_lua
install_nginx
_clean
