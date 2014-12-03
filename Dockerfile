FROM centos:centos7
MAINTAINER Matthew J. Mucklo <matthew.j.mucklo@qvc.com>
RUN yum -y update
RUN yum -y upgrade
RUN yum -y install epel-release
RUN yum -y install gcc gcc-c++ cmake git gmp-devel ocaml psmisc binutils-devel boost-devel libmcrypt-devel libmemcached-devel jemalloc-devel libevent-devel sqlite-devel libxslt-devel libicu-devel tbb-devel libzip-devel mysql-devel bzip2-devel openldap-devel readline-devel elfutils-libelf-devel libcap-devel libyaml-devel libedit-devel lz4-devel libvpx-devel unixODBC-devel libgmp-devel libpng-devel ImageMagick-devel expat-devel openssl-devel wget tar bzip2 patch make libtool libidn-devel
RUN mkdir /root/software && cd /root/software && wget http://ftp.gnu.org/gnu/libiconv/libiconv-1.14.tar.gz
RUN cd /root && mkdir src && cd src && tar xzf ../software/libiconv-1.14.tar.gz
COPY libiconv_stdio.in.h.patch /root/src/libiconv-1.14/srclib/
RUN cd /root/src/libiconv-1.14/srclib && patch stdio.in.h libiconv_stdio.in.h.patch
RUN cd /root/src/libiconv-1.14 && ./configure --prefix=/usr/local && make install
RUN cd /root/software && wget http://c-ares.haxx.se/download/c-ares-1.10.0.tar.gz
RUN cd /root/src && tar xzf ../software/c-ares-1.10.0.tar.gz
RUN cd /root/src/c-ares-1.10.0 && ./configure --prefix /usr/local && make install
RUN cd /root/software && wget http://curl.haxx.se/download/curl-7.39.0.tar.bz2
RUN cd /root/src && tar xjf ../software/curl-7.39.0.tar.bz2
RUN cd /root/src/curl-7.39.0 && ./configure --prefix=/usr/local --enable-ares=/usr/local && make install
RUN cd /root/software && wget https://double-conversion.googlecode.com/files/double-conversion-1.1.5.tar.gz
RUN cd /root/src && mkdir double-conversion-1.1.5 && cd double-conversion-1.1.5 && tar xzf ../../software/double-conversion-1.1.5.tar.gz
RUN cd /root/src/double-conversion-1.1.5 && cmake . && make install
RUN cd /root/software && wget https://google-glog.googlecode.com/files/glog-0.3.3.tar.gz
RUN cd /root/src && tar xzf ../software/glog-0.3.3.tar.gz
RUN cd /root/src/glog-0.3.3 && ./configure --prefix=/usr/local && make install
RUN cd /root/software && wget http://www.geocities.jp/kosako3/oniguruma/archive/onig-5.9.5.tar.gz
RUN cd /root/src && tar xzf ../software/onig-5.9.5.tar.gz
RUN cd /root/src/onig-5.9.5 && ./configure --prefix=/usr/local && make install
RUN cd /root/software && wget http://www.prevanders.net/libdwarf-20140413.tar.gz
RUN cd /root/src && tar xzf ../software/libdwarf-20140413.tar.gz
RUN cd /root/src/dwarf-20140413 && ./configure --prefix=/usr/local && make dd && cp libdwarf/libdwarf.a /usr/local/lib/. && mkdir -p /usr/local/include/dwarf && cp libdwarf/*.h /usr/local/include/dwarf/.
RUN cd /root/src && git clone git://github.com/facebook/hhvm.git && cd hhvm && git checkout 7c1919f48c8d432c4987fc93afe6f4367389934c
RUN cd /root/src/hhvm && git submodule update --init --recursive
RUN cd /root/src/hhvm && cmake -D CMAKE_PREFIX_PATH=/usr/local -D DOUBLE_CONVERSION_INCLUDE_DIR="/usr/local/include/double-conversion" -D DOUBLE_CONVERSION_LIBRARY="/usr/local/lib/libdouble-conversion.a" -D FREETYPE_INCLUDE_DIRS="/usr/include/freetype2" -D LIBDWARF_LIBRARIES="/usr/local/lib/libdwarf.a" -D LIBDWARF_INCLUDE_DIRS="/usr/local/include/dwarf" .
RUN cd /root/src/hhvm && make install
RUN chmod a+x /root/src/hhvm/hphp/tools/hphpize/hphpize
RUN cd /root/src && git clone git://github.com/mongodb/mongo-c-driver && cd mongo-c-driver && git checkout 96d48e98e95fdb5066706f392057ff853c83c259
RUN cd /root/src/mongo-c-driver && ./autogen.sh
RUN cd /root/src/mongo-c-driver && make install
RUN cd /root/src && git clone git://github.com/mongofill/mongofill-hhvm && cd mongofill-hhvm && git checkout 5891ae10f1d3acf666c181dda4acdff63fe664d0
RUN cd /root/src/mongofill-hhvm && export HPHP_HOME=/root/src/hhvm && ./build.sh && make install
RUN echo "net.core.somaxconn=65535" >> /etc/sysctl.conf
RUN echo "*               hard    nofile          65535" >> /etc/security/limits.conf
RUN echo "*               soft    nofile          65535" >> /etc/security/limits.conf
RUN /bin/rm -rf /root/src && /bin/rm -rf /root/software
RUN yum -y remove gcc gcc-c++ cmake git gmp-devel binutils-devel boost-devel libmcrypt-devel libmemcached-devel jemalloc-devel libevent-devel sqlite-devel libxslt-devel libicu-devel tbb-devel libzip-devel mysql-devel bzip2-devel openldap-devel readline-devel elfutils-libelf-devel libcap-devel libyaml-devel libedit-devel lz4-devel libvpx-devel unixODBC-devel libgmp-devel libpng-devel ImageMagick-devel expat-devel openssl-devel patch make libtool libidn-devel
