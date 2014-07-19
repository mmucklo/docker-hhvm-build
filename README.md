Dockerfile for Building HHVM
============================

This checks out the 3.2 version of hhvm and compiles it.

This also builds relevant libraries such as libdwarf, libiconv, double-conversion, plus the mongo-c-driver (which is needed by mongofill-hhvm which is also built as an extension)

Extensions:
* mongofill-hhvm
  * https://github.com/mongofill/mongofill-hhvm is built as well
  * The resulting extension lives here: /root/src/mongofill-hhvm/mongo.so

Other:
* Ubuntu 14.10 image used
* patch for libiconv
