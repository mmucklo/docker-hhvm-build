FROM ubuntu:14.10
MAINTAINER Matthew J. Mucklo <matthew.j.mucklo@qvc.com>
RUN apt-get -qq update
RUN apt-get -qqy upgrade
RUN apt-get -qqy install autoconf automake binutils-dev build-essential cmake g++ git libboost-dev libboost-filesystem-dev libboost-program-options-dev libboost-regex-dev libboost-system-dev libboost-thread-dev libbz2-dev libc-client-dev libldap2-dev libc-client2007e-dev libcap-dev libcurl4-openssl-dev libelf-dev libexpat-dev libgd2-xpm-dev libgoogle-glog-dev libgoogle-perftools-dev libicu-dev libjemalloc-dev libmcrypt-dev libmemcached-dev libmysqlclient-dev libncurses-dev libonig-dev libpcre3-dev libreadline-dev libtbb-dev libtool libxml2-dev zlib1g-dev libevent-dev libmagickwand-dev libinotifytools0-dev libiconv-hook-dev libedit-dev libiberty-dev libxslt1-dev ocaml-native-compilers php5-imagick libyaml-dev libelf-dev libsqlite3-dev unixodbc-dev libmyodbc liblz4-dev libzip-dev wget
RUN mkdir /root/software && cd /root/software && wget http://ftp.gnu.org/gnu/libiconv/libiconv-1.14.tar.gz
RUN cd /root && mkdir src && cd src && tar xzf ../software/libiconv-1.14.tar.gz
COPY libiconv_stdio.in.h.patch /root/src/libiconv-1.14/srclib/
RUN cd /root/src/libiconv-1.14/srclib && patch stdio.in.h libiconv_stdio.in.h.patch
RUN cd /root/src/libiconv-1.14 && ./configure --prefix=/usr/local && make install
RUN cd /root/software && wget https://double-conversion.googlecode.com/files/double-conversion-1.1.5.tar.gz
RUN cd /root/src && mkdir double-conversion-1.1.5 && cd double-conversion-1.1.5 && tar xzf ../../software/double-conversion-1.1.5.tar.gz
RUN cd /root/src/double-conversion-1.1.5 && cmake . && make install
RUN cd /root/software && wget http://www.prevanders.net/libdwarf-20140413.tar.gz
RUN cd /root/src && tar xzf ../software/libdwarf-20140413.tar.gz
RUN cd /root/src/dwarf-20140413 && ./configure --prefix=/usr/local && make dd && cp libdwarf/libdwarf.a /usr/local/lib/. && mkdir -p /usr/local/include/dwarf && cp libdwarf/*.h /usr/local/include/dwarf/.
RUN cd /root/src && git clone git://github.com/facebook/hhvm.git && git checkout c380b4972e48b708cd2844c7af501e0638ce0914
RUN cd /root/src/hhvm && git submodule update --init --recursive
RUN cd /root/src/hhvm && sed -i'' 's|freetype/config/ftheader.h|freetype2/config/ftheader.h|' hphp/runtime/ext/gd/libgd/gdft.cpp
RUN cd /root/src/hhvm && cmake -D CMAKE_PREFIX_PATH=/usr/local -D DOUBLE_CONVERSION_INCLUDE_DIR="/usr/local/include/double-conversion" -D DOUBLE_CONVERSION_LIBRARY="/usr/local/lib/libdouble-conversion.a" -D FREETYPE_INCLUDE_DIRS="/usr/include/freetype2" -D LIBDWARF_LIBRARIES="/usr/local/lib/libdwarf.a" -D LIBDWARF_INCLUDE_DIRS="/usr/local/include/dwarf" .
RUN cd /root/src/hhvm && make install
RUN chmod a+x /root/src/hhvm/hphp/tools/hphpize/hphpize
RUN cd /root/src && git clone git://github.com/mongodb/mongo-c-driver && cd mongo-c-driver && git checkout b5b25a3ee68209291df985ef58f95bef3dbe45ba
RUN cd /root/src/mongo-c-driver && ./autogen.sh
RUN cd /root/src/mongo-c-driver && make install
RUN cd /root/src && git clone git://github.com/mongofill/mongofill-hhvm && cd mongofill-hhvm && git checkout 76cd61abd6237947abab31b591a13d6a63a957be
RUN cd /root/src/mongofill-hhvm && export HPHP_HOME=/root/src/hhvm && ./build.sh 
RUN echo "net.core.somaxconn=65535" >> /etc/sysctl.conf
RUN echo "*               hard    nofile          65535" >> /etc/security/limits.conf
RUN echo "*               soft    nofile          65535" >> /etc/security/limits.conf 
