FROM amazonlinux:latest

RUN yum update -y && \
    yum -y groupinstall development && \
    yum -y install wget zlib-devel openssl-devel \
           gcc gcc-c++ findutils zip atlas-devel \
           atlas-sse3-devel blas-devel lapack-devel && \
    wget https://github.com/openssl/openssl/archive/OpenSSL_1_0_2l.tar.gz && \
    tar -zxvf OpenSSL_1_0_2l.tar.gz && \
    cd openssl-OpenSSL_1_0_2l/ && \
    ./config shared && make && make install && \
    export LD_LIBRARY_PATH=/usr/local/ssl/lib/ && \
    cd .. && rm OpenSSL_1_0_2l.tar.gz && rm -rf openssl-OpenSSL_1_0_2l/ && \
    wget https://www.python.org/ftp/python/3.6.0/Python-3.6.0.tar.xz && \
    tar xJf Python-3.6.0.tar.xz && \
    cd Python-3.6.0 && \
    ./configure && \
    make && \
    make install && \
    make install && \
    cd .. && \
    rm Python-3.6.0.tar.xz && \
    rm -rf Python-3.6.0 && \
    curl -O https://bootstrap.pypa.io/get-pip.py && \
    python3.6 get-pip.py --user

RUN wget https://ftp.postgresql.org/pub/source/v9.4.3/postgresql-9.4.3.tar.gz && \
    wget http://initd.org/psycopg/tarballs/PSYCOPG-2-6/psycopg2-2.6.1.tar.gz && \
    tar -zxvf postgresql-9.4.3.tar.gz && \
    tar -zxvf psycopg2-2.6.1.tar.gz && \
    cd postgresql-9.4.3 && \
    ./configure --prefix /postgresql-9.4.3 --without-readline --without-zlib --with-openssl && \
    make && make install &&  cd .. && \
    cd psycopg2-2.6.1 && echo "pg_config=/postgresql-9.4.3/bin/pg_config" >> setup.cfg && \
    echo "static_libpq=1" >> setup.cfg && \
    echo "libraries=ssl crypto" >> setup.cfg && \
    python3.6 setup.py build

WORKDIR /build