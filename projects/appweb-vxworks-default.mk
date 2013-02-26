#
#   appweb-vxworks-default.mk -- Makefile to build Embedthis Appweb for vxworks
#

export WIND_BASE := $(WIND_BASE)
export WIND_HOME := $(WIND_BASE)/..
export WIND_PLATFORM := $(WIND_PLATFORM)

PRODUCT         := appweb
VERSION         := 4.3.0
BUILD_NUMBER    := 0
PROFILE         := default
ARCH            := $(shell uname -m | sed 's/i.86/x86/;s/x86_64/x64/;s/arm.*/arm/;s/mips.*/mips/')
OS              := vxworks
CC              := ccpentium
LD              := /usr/bin/ld
CONFIG          := $(OS)-$(ARCH)-$(PROFILE)
LBIN            := $(CONFIG)/bin

CFLAGS          += -fno-builtin -fno-defer-pop -fvolatile -w
DFLAGS          += -D_REENTRANT -DVXWORKS -DRW_MULTI_THREAD -D_GNU_TOOL -DCPU=PENTIUM $(patsubst %,-D%,$(filter BIT_%,$(MAKEFLAGS)))
IFLAGS          += -I$(CONFIG)/inc -I$(WIND_BASE)/target/h -I$(WIND_BASE)/target/h/wrn/coreip
LDFLAGS         += '-Wl,-r'
LIBPATHS        += -L$(CONFIG)/bin
LIBS            += 

DEBUG           := debug
CFLAGS-debug    := -g
DFLAGS-debug    := -DBIT_DEBUG
LDFLAGS-debug   := -g
DFLAGS-release  := 
CFLAGS-release  := -O2
LDFLAGS-release := 
CFLAGS          += $(CFLAGS-$(DEBUG))
DFLAGS          += $(DFLAGS-$(DEBUG))
LDFLAGS         += $(LDFLAGS-$(DEBUG))

BIT_PACK_EST          := 0
BIT_PACK_EJSCRIPT     := 1
BIT_PACK_PHP          := 0
BIT_PACK_CGI          := 1
BIT_PACK_ESP          := 1
BIT_PACK_SQLITE       := 1

BIT_ROOT_PREFIX       := deploy
BIT_BASE_PREFIX       := $(BIT_ROOT_PREFIX)
BIT_DATA_PREFIX       := $(BIT_VAPP_PREFIX)
BIT_STATE_PREFIX      := $(BIT_VAPP_PREFIX)
BIT_BIN_PREFIX        := $(BIT_VAPP_PREFIX)
BIT_INC_PREFIX        := $(BIT_VAPP_PREFIX)/inc
BIT_LIB_PREFIX        := $(BIT_VAPP_PREFIX)
BIT_MAN_PREFIX        := $(BIT_VAPP_PREFIX)
BIT_SBIN_PREFIX       := $(BIT_VAPP_PREFIX)
BIT_ETC_PREFIX        := $(BIT_VAPP_PREFIX)
BIT_WEB_PREFIX        := $(BIT_VAPP_PREFIX)/web
BIT_LOG_PREFIX        := $(BIT_VAPP_PREFIX)
BIT_SPOOL_PREFIX      := $(BIT_VAPP_PREFIX)
BIT_CACHE_PREFIX      := $(BIT_VAPP_PREFIX)
BIT_APP_PREFIX        := $(BIT_BASE_PREFIX)
BIT_VAPP_PREFIX       := $(BIT_APP_PREFIX)
BIT_SRC_PREFIX        := $(BIT_ROOT_PREFIX)/usr/src/$(PRODUCT)-$(VERSION)

WEB_USER    = $(shell egrep 'www-data|_www|nobody' /etc/passwd | sed 's/:.*$$//' |  tail -1)
WEB_GROUP   = $(shell egrep 'www-data|_www|nobody|nogroup' /etc/group | sed 's/:.*$$//' |  tail -1)

TARGETS     += $(CONFIG)/bin/libmpr.out
TARGETS     += $(CONFIG)/bin/libmprssl.out
TARGETS     += $(CONFIG)/bin/appman.out
TARGETS     += $(CONFIG)/bin/makerom.out
ifeq ($(BIT_PACK_EST),1)
TARGETS += $(CONFIG)/bin/libest.out
endif
TARGETS     += $(CONFIG)/bin/ca.crt
TARGETS     += $(CONFIG)/bin/libpcre.out
TARGETS     += $(CONFIG)/bin/libhttp.out
TARGETS     += $(CONFIG)/bin/http.out
ifeq ($(BIT_PACK_SQLITE),1)
TARGETS += $(CONFIG)/bin/libsqlite3.out
endif
ifeq ($(BIT_PACK_SQLITE),1)
TARGETS += $(CONFIG)/bin/sqlite.out
endif
TARGETS     += $(CONFIG)/bin/libappweb.out
ifeq ($(BIT_PACK_ESP),1)
TARGETS += $(CONFIG)/bin/libmod_esp.out
endif
ifeq ($(BIT_PACK_ESP),1)
TARGETS += $(CONFIG)/bin/esp.out
endif
ifeq ($(BIT_PACK_ESP),1)
TARGETS += $(CONFIG)/bin/esp.conf
endif
ifeq ($(BIT_PACK_ESP),1)
TARGETS += src/server/esp.conf
endif
ifeq ($(BIT_PACK_ESP),1)
TARGETS += $(CONFIG)/bin/esp-www
endif
ifeq ($(BIT_PACK_ESP),1)
TARGETS += $(CONFIG)/bin/esp-appweb.conf
endif
ifeq ($(BIT_PACK_EJSCRIPT),1)
TARGETS += $(CONFIG)/bin/libejs.out
endif
ifeq ($(BIT_PACK_EJSCRIPT),1)
TARGETS += $(CONFIG)/bin/ejs.out
endif
ifeq ($(BIT_PACK_EJSCRIPT),1)
TARGETS += $(CONFIG)/bin/ejsc.out
endif
ifeq ($(BIT_PACK_EJSCRIPT),1)
TARGETS += $(CONFIG)/bin/ejs.mod
endif
ifeq ($(BIT_PACK_CGI),1)
TARGETS += $(CONFIG)/bin/libmod_cgi.out
endif
ifeq ($(BIT_PACK_EJSCRIPT),1)
TARGETS += $(CONFIG)/bin/libmod_ejs.out
endif
TARGETS     += $(CONFIG)/bin/libmod_ssl.out
TARGETS     += $(CONFIG)/bin/authpass.out
ifeq ($(BIT_PACK_CGI),1)
TARGETS += $(CONFIG)/bin/cgiProgram.out
endif
TARGETS     += src/server/slink.c
TARGETS     += $(CONFIG)/bin/libapp.out
TARGETS     += $(CONFIG)/bin/appweb.out
TARGETS     += src/server/cache
TARGETS     += $(CONFIG)/bin/testAppweb.out
ifeq ($(BIT_PACK_CGI),1)
TARGETS += test/cgi-bin/testScript
endif
ifeq ($(BIT_PACK_CGI),1)
TARGETS += test/web/caching/cache.cgi
endif
ifeq ($(BIT_PACK_CGI),1)
TARGETS += test/web/auth/basic/basic.cgi
endif
ifeq ($(BIT_PACK_CGI),1)
TARGETS += test/cgi-bin/cgiProgram.out
endif
TARGETS     += test/web/js

unexport CDPATH

ifndef SHOW
.SILENT:
endif

all build compile: prep $(TARGETS)

.PHONY: prep

prep:
	@echo "      [Info] Use "make SHOW=1" to trace executed commands."
	@if [ "$(CONFIG)" = "" ] ; then echo WARNING: CONFIG not set ; exit 255 ; fi
	@if [ "$(BIT_APP_PREFIX)" = "" ] ; then echo WARNING: BIT_APP_PREFIX not set ; exit 255 ; fi
	@[ ! -x $(CONFIG)/bin ] && mkdir -p $(CONFIG)/bin; true
	@[ ! -x $(CONFIG)/inc ] && mkdir -p $(CONFIG)/inc; true
	@[ ! -x $(CONFIG)/obj ] && mkdir -p $(CONFIG)/obj; true
	@[ ! -f $(CONFIG)/inc/bit.h ] && cp projects/appweb-vxworks-default-bit.h $(CONFIG)/inc/bit.h ; true
	@[ ! -f $(CONFIG)/inc/bitos.h ] && cp src/bitos.h $(CONFIG)/inc/bitos.h ; true
	@if ! diff $(CONFIG)/inc/bit.h projects/appweb-vxworks-default-bit.h >/dev/null ; then\
		echo cp projects/appweb-vxworks-default-bit.h $(CONFIG)/inc/bit.h  ; \
		cp projects/appweb-vxworks-default-bit.h $(CONFIG)/inc/bit.h  ; \
	fi; true

clean:
	rm -rf $(CONFIG)/bin/libmpr.out
	rm -rf $(CONFIG)/bin/libmprssl.out
	rm -rf $(CONFIG)/bin/appman.out
	rm -rf $(CONFIG)/bin/makerom.out
	rm -rf $(CONFIG)/bin/libest.out
	rm -rf $(CONFIG)/bin/ca.crt
	rm -rf $(CONFIG)/bin/libpcre.out
	rm -rf $(CONFIG)/bin/libhttp.out
	rm -rf $(CONFIG)/bin/http.out
	rm -rf $(CONFIG)/bin/libsqlite3.out
	rm -rf $(CONFIG)/bin/sqlite.out
	rm -rf $(CONFIG)/bin/libappweb.out
	rm -rf $(CONFIG)/bin/libmod_esp.out
	rm -rf $(CONFIG)/bin/esp.out
	rm -rf $(CONFIG)/bin/esp.conf
	rm -rf src/server/esp.conf
	rm -rf $(CONFIG)/bin/esp-www
	rm -rf $(CONFIG)/bin/esp-appweb.conf
	rm -rf $(CONFIG)/bin/libejs.out
	rm -rf $(CONFIG)/bin/ejs.out
	rm -rf $(CONFIG)/bin/ejsc.out
	rm -rf $(CONFIG)/bin/ejs.mod
	rm -rf $(CONFIG)/bin/libmod_cgi.out
	rm -rf $(CONFIG)/bin/libmod_ejs.out
	rm -rf $(CONFIG)/bin/libmod_ssl.out
	rm -rf $(CONFIG)/bin/authpass.out
	rm -rf $(CONFIG)/bin/cgiProgram.out
	rm -rf $(CONFIG)/bin/libapp.out
	rm -rf $(CONFIG)/bin/appweb.out
	rm -rf $(CONFIG)/bin/testAppweb.out
	rm -rf test/cgi-bin/testScript
	rm -rf test/web/caching/cache.cgi
	rm -rf test/web/auth/basic/basic.cgi
	rm -rf test/cgi-bin/cgiProgram.out
	rm -rf test/web/js
	rm -rf $(CONFIG)/obj/mprLib.o
	rm -rf $(CONFIG)/obj/mprSsl.o
	rm -rf $(CONFIG)/obj/manager.o
	rm -rf $(CONFIG)/obj/makerom.o
	rm -rf $(CONFIG)/obj/estLib.o
	rm -rf $(CONFIG)/obj/pcre.o
	rm -rf $(CONFIG)/obj/httpLib.o
	rm -rf $(CONFIG)/obj/http.o
	rm -rf $(CONFIG)/obj/sqlite3.o
	rm -rf $(CONFIG)/obj/sqlite.o
	rm -rf $(CONFIG)/obj/config.o
	rm -rf $(CONFIG)/obj/convenience.o
	rm -rf $(CONFIG)/obj/dirHandler.o
	rm -rf $(CONFIG)/obj/fileHandler.o
	rm -rf $(CONFIG)/obj/log.o
	rm -rf $(CONFIG)/obj/server.o
	rm -rf $(CONFIG)/obj/edi.o
	rm -rf $(CONFIG)/obj/esp.o
	rm -rf $(CONFIG)/obj/espAbbrev.o
	rm -rf $(CONFIG)/obj/espFramework.o
	rm -rf $(CONFIG)/obj/espHandler.o
	rm -rf $(CONFIG)/obj/espHtml.o
	rm -rf $(CONFIG)/obj/espTemplate.o
	rm -rf $(CONFIG)/obj/mdb.o
	rm -rf $(CONFIG)/obj/sdb.o
	rm -rf $(CONFIG)/obj/ejsLib.o
	rm -rf $(CONFIG)/obj/ejs.o
	rm -rf $(CONFIG)/obj/ejsc.o
	rm -rf $(CONFIG)/obj/cgiHandler.o
	rm -rf $(CONFIG)/obj/ejsHandler.o
	rm -rf $(CONFIG)/obj/sslModule.o
	rm -rf $(CONFIG)/obj/authpass.o
	rm -rf $(CONFIG)/obj/cgiProgram.o
	rm -rf $(CONFIG)/obj/slink.o
	rm -rf $(CONFIG)/obj/appweb.o
	rm -rf $(CONFIG)/obj/testAppweb.o
	rm -rf $(CONFIG)/obj/testHttp.o

clobber: clean
	rm -fr ./$(CONFIG)

#
#   mpr.h
#
$(CONFIG)/inc/mpr.h: $(DEPS_1)
	@echo '      [File] $(CONFIG)/inc/mpr.h'
	mkdir -p "$(CONFIG)/inc"
	cp "src/deps/mpr/mpr.h" "$(CONFIG)/inc/mpr.h"

#
#   bit.h
#
$(CONFIG)/inc/bit.h: $(DEPS_2)

#
#   bitos.h
#
DEPS_3 += $(CONFIG)/inc/bit.h

$(CONFIG)/inc/bitos.h: $(DEPS_3)
	@echo '      [File] $(CONFIG)/inc/bitos.h'
	mkdir -p "$(CONFIG)/inc"
	cp "src/bitos.h" "$(CONFIG)/inc/bitos.h"

#
#   mprLib.o
#
DEPS_4 += $(CONFIG)/inc/bit.h
DEPS_4 += $(CONFIG)/inc/mpr.h
DEPS_4 += $(CONFIG)/inc/bitos.h

$(CONFIG)/obj/mprLib.o: \
    src/deps/mpr/mprLib.c $(DEPS_4)
	@echo '   [Compile] src/deps/mpr/mprLib.c'
	$(CC) -c -o $(CONFIG)/obj/mprLib.o $(CFLAGS) $(DFLAGS) $(IFLAGS) src/deps/mpr/mprLib.c

#
#   libmpr
#
DEPS_5 += $(CONFIG)/inc/mpr.h
DEPS_5 += $(CONFIG)/obj/mprLib.o

$(CONFIG)/bin/libmpr.out: $(DEPS_5)
	@echo '      [Link] libmpr'
	$(CC) -r -o $(CONFIG)/bin/libmpr.out $(LDFLAGS) $(LIBPATHS) $(CONFIG)/obj/mprLib.o 

#
#   est.h
#
$(CONFIG)/inc/est.h: $(DEPS_6)
	@echo '      [File] $(CONFIG)/inc/est.h'
	mkdir -p "$(CONFIG)/inc"
	cp "src/deps/est/est.h" "$(CONFIG)/inc/est.h"

#
#   estLib.o
#
DEPS_7 += $(CONFIG)/inc/bit.h
DEPS_7 += $(CONFIG)/inc/est.h
DEPS_7 += $(CONFIG)/inc/bitos.h

$(CONFIG)/obj/estLib.o: \
    src/deps/est/estLib.c $(DEPS_7)
	@echo '   [Compile] src/deps/est/estLib.c'
	$(CC) -c -o $(CONFIG)/obj/estLib.o -fno-builtin -fno-defer-pop -fvolatile $(DFLAGS) $(IFLAGS) src/deps/est/estLib.c

ifeq ($(BIT_PACK_EST),1)
#
#   libest
#
DEPS_8 += $(CONFIG)/inc/est.h
DEPS_8 += $(CONFIG)/obj/estLib.o

$(CONFIG)/bin/libest.out: $(DEPS_8)
	@echo '      [Link] libest'
	$(CC) -r -o $(CONFIG)/bin/libest.out $(LDFLAGS) $(LIBPATHS) $(CONFIG)/obj/estLib.o 
endif

#
#   mprSsl.o
#
DEPS_9 += $(CONFIG)/inc/bit.h
DEPS_9 += $(CONFIG)/inc/mpr.h
DEPS_9 += $(CONFIG)/inc/est.h

$(CONFIG)/obj/mprSsl.o: \
    src/deps/mpr/mprSsl.c $(DEPS_9)
	@echo '   [Compile] src/deps/mpr/mprSsl.c'
	$(CC) -c -o $(CONFIG)/obj/mprSsl.o $(CFLAGS) $(DFLAGS) $(IFLAGS) src/deps/mpr/mprSsl.c

#
#   libmprssl
#
DEPS_10 += $(CONFIG)/bin/libmpr.out
ifeq ($(BIT_PACK_EST),1)
    DEPS_10 += $(CONFIG)/bin/libest.out
endif
DEPS_10 += $(CONFIG)/obj/mprSsl.o

ifeq ($(BIT_PACK_EST),1)
    LIBS_10 += -lest
endif
LIBS_10 += -lmpr

$(CONFIG)/bin/libmprssl.out: $(DEPS_10)
	@echo '      [Link] libmprssl'
	$(CC) -r -o $(CONFIG)/bin/libmprssl.out $(LDFLAGS) $(LIBPATHS) $(CONFIG)/obj/mprSsl.o 

#
#   manager.o
#
DEPS_11 += $(CONFIG)/inc/bit.h
DEPS_11 += $(CONFIG)/inc/mpr.h

$(CONFIG)/obj/manager.o: \
    src/deps/mpr/manager.c $(DEPS_11)
	@echo '   [Compile] src/deps/mpr/manager.c'
	$(CC) -c -o $(CONFIG)/obj/manager.o $(CFLAGS) $(DFLAGS) $(IFLAGS) src/deps/mpr/manager.c

#
#   manager
#
DEPS_12 += $(CONFIG)/bin/libmpr.out
DEPS_12 += $(CONFIG)/obj/manager.o

LIBS_12 += -lmpr

$(CONFIG)/bin/appman.out: $(DEPS_12)
	@echo '      [Link] manager'
	$(CC) -o $(CONFIG)/bin/appman.out $(LDFLAGS) $(LIBPATHS) $(CONFIG)/obj/manager.o $(LDFLAGS)

#
#   makerom.o
#
DEPS_13 += $(CONFIG)/inc/bit.h
DEPS_13 += $(CONFIG)/inc/mpr.h

$(CONFIG)/obj/makerom.o: \
    src/deps/mpr/makerom.c $(DEPS_13)
	@echo '   [Compile] src/deps/mpr/makerom.c'
	$(CC) -c -o $(CONFIG)/obj/makerom.o $(CFLAGS) $(DFLAGS) $(IFLAGS) src/deps/mpr/makerom.c

#
#   makerom
#
DEPS_14 += $(CONFIG)/bin/libmpr.out
DEPS_14 += $(CONFIG)/obj/makerom.o

LIBS_14 += -lmpr

$(CONFIG)/bin/makerom.out: $(DEPS_14)
	@echo '      [Link] makerom'
	$(CC) -o $(CONFIG)/bin/makerom.out $(LDFLAGS) $(LIBPATHS) $(CONFIG)/obj/makerom.o $(LDFLAGS)

#
#   ca-crt
#
DEPS_15 += src/deps/est/ca.crt

$(CONFIG)/bin/ca.crt: $(DEPS_15)
	@echo '      [File] $(CONFIG)/bin/ca.crt'
	mkdir -p "$(CONFIG)/bin"
	cp "src/deps/est/ca.crt" "$(CONFIG)/bin/ca.crt"

#
#   pcre.h
#
$(CONFIG)/inc/pcre.h: $(DEPS_16)
	@echo '      [File] $(CONFIG)/inc/pcre.h'
	mkdir -p "$(CONFIG)/inc"
	cp "src/deps/pcre/pcre.h" "$(CONFIG)/inc/pcre.h"

#
#   pcre.o
#
DEPS_17 += $(CONFIG)/inc/bit.h
DEPS_17 += $(CONFIG)/inc/pcre.h

$(CONFIG)/obj/pcre.o: \
    src/deps/pcre/pcre.c $(DEPS_17)
	@echo '   [Compile] src/deps/pcre/pcre.c'
	$(CC) -c -o $(CONFIG)/obj/pcre.o $(CFLAGS) $(DFLAGS) $(IFLAGS) src/deps/pcre/pcre.c

#
#   libpcre
#
DEPS_18 += $(CONFIG)/inc/pcre.h
DEPS_18 += $(CONFIG)/obj/pcre.o

$(CONFIG)/bin/libpcre.out: $(DEPS_18)
	@echo '      [Link] libpcre'
	$(CC) -r -o $(CONFIG)/bin/libpcre.out $(LDFLAGS) $(LIBPATHS) $(CONFIG)/obj/pcre.o 

#
#   http.h
#
$(CONFIG)/inc/http.h: $(DEPS_19)
	@echo '      [File] $(CONFIG)/inc/http.h'
	mkdir -p "$(CONFIG)/inc"
	cp "src/deps/http/http.h" "$(CONFIG)/inc/http.h"

#
#   httpLib.o
#
DEPS_20 += $(CONFIG)/inc/bit.h
DEPS_20 += $(CONFIG)/inc/http.h
DEPS_20 += $(CONFIG)/inc/mpr.h

$(CONFIG)/obj/httpLib.o: \
    src/deps/http/httpLib.c $(DEPS_20)
	@echo '   [Compile] src/deps/http/httpLib.c'
	$(CC) -c -o $(CONFIG)/obj/httpLib.o $(CFLAGS) $(DFLAGS) $(IFLAGS) src/deps/http/httpLib.c

#
#   libhttp
#
DEPS_21 += $(CONFIG)/bin/libmpr.out
DEPS_21 += $(CONFIG)/bin/libpcre.out
DEPS_21 += $(CONFIG)/inc/http.h
DEPS_21 += $(CONFIG)/obj/httpLib.o

LIBS_21 += -lpcre
LIBS_21 += -lmpr

$(CONFIG)/bin/libhttp.out: $(DEPS_21)
	@echo '      [Link] libhttp'
	$(CC) -r -o $(CONFIG)/bin/libhttp.out $(LDFLAGS) $(LIBPATHS) $(CONFIG)/obj/httpLib.o 

#
#   http.o
#
DEPS_22 += $(CONFIG)/inc/bit.h
DEPS_22 += $(CONFIG)/inc/http.h

$(CONFIG)/obj/http.o: \
    src/deps/http/http.c $(DEPS_22)
	@echo '   [Compile] src/deps/http/http.c'
	$(CC) -c -o $(CONFIG)/obj/http.o $(CFLAGS) $(DFLAGS) $(IFLAGS) src/deps/http/http.c

#
#   http
#
DEPS_23 += $(CONFIG)/bin/libhttp.out
DEPS_23 += $(CONFIG)/obj/http.o

LIBS_23 += -lhttp
LIBS_23 += -lpcre
LIBS_23 += -lmpr

$(CONFIG)/bin/http.out: $(DEPS_23)
	@echo '      [Link] http'
	$(CC) -o $(CONFIG)/bin/http.out $(LDFLAGS) $(LIBPATHS) $(CONFIG)/obj/http.o $(LDFLAGS)

#
#   sqlite3.h
#
$(CONFIG)/inc/sqlite3.h: $(DEPS_24)
	@echo '      [File] $(CONFIG)/inc/sqlite3.h'
	mkdir -p "$(CONFIG)/inc"
	cp "src/deps/sqlite/sqlite3.h" "$(CONFIG)/inc/sqlite3.h"

#
#   sqlite3.o
#
DEPS_25 += $(CONFIG)/inc/bit.h
DEPS_25 += $(CONFIG)/inc/sqlite3.h

$(CONFIG)/obj/sqlite3.o: \
    src/deps/sqlite/sqlite3.c $(DEPS_25)
	@echo '   [Compile] src/deps/sqlite/sqlite3.c'
	$(CC) -c -o $(CONFIG)/obj/sqlite3.o -fno-builtin -fno-defer-pop -fvolatile $(DFLAGS) $(IFLAGS) src/deps/sqlite/sqlite3.c

ifeq ($(BIT_PACK_SQLITE),1)
#
#   libsqlite3
#
DEPS_26 += $(CONFIG)/inc/sqlite3.h
DEPS_26 += $(CONFIG)/obj/sqlite3.o

$(CONFIG)/bin/libsqlite3.out: $(DEPS_26)
	@echo '      [Link] libsqlite3'
	$(CC) -r -o $(CONFIG)/bin/libsqlite3.out $(LDFLAGS) $(LIBPATHS) $(CONFIG)/obj/sqlite3.o 
endif

#
#   sqlite.o
#
DEPS_27 += $(CONFIG)/inc/bit.h
DEPS_27 += $(CONFIG)/inc/sqlite3.h

$(CONFIG)/obj/sqlite.o: \
    src/deps/sqlite/sqlite.c $(DEPS_27)
	@echo '   [Compile] src/deps/sqlite/sqlite.c'
	$(CC) -c -o $(CONFIG)/obj/sqlite.o $(CFLAGS) $(DFLAGS) $(IFLAGS) src/deps/sqlite/sqlite.c

ifeq ($(BIT_PACK_SQLITE),1)
#
#   sqlite
#
ifeq ($(BIT_PACK_SQLITE),1)
    DEPS_28 += $(CONFIG)/bin/libsqlite3.out
endif
DEPS_28 += $(CONFIG)/obj/sqlite.o

ifeq ($(BIT_PACK_SQLITE),1)
    LIBS_28 += -lsqlite3
endif

$(CONFIG)/bin/sqlite.out: $(DEPS_28)
	@echo '      [Link] sqlite'
	$(CC) -o $(CONFIG)/bin/sqlite.out $(LDFLAGS) $(LIBPATHS) $(CONFIG)/obj/sqlite.o $(LDFLAGS)
endif

#
#   appweb.h
#
$(CONFIG)/inc/appweb.h: $(DEPS_29)
	@echo '      [File] $(CONFIG)/inc/appweb.h'
	mkdir -p "$(CONFIG)/inc"
	cp "src/appweb.h" "$(CONFIG)/inc/appweb.h"

#
#   customize.h
#
$(CONFIG)/inc/customize.h: $(DEPS_30)
	@echo '      [File] $(CONFIG)/inc/customize.h'
	mkdir -p "$(CONFIG)/inc"
	cp "src/customize.h" "$(CONFIG)/inc/customize.h"

#
#   config.o
#
DEPS_31 += $(CONFIG)/inc/bit.h
DEPS_31 += $(CONFIG)/inc/appweb.h
DEPS_31 += $(CONFIG)/inc/pcre.h
DEPS_31 += $(CONFIG)/inc/mpr.h
DEPS_31 += $(CONFIG)/inc/http.h
DEPS_31 += $(CONFIG)/inc/customize.h

$(CONFIG)/obj/config.o: \
    src/config.c $(DEPS_31)
	@echo '   [Compile] src/config.c'
	$(CC) -c -o $(CONFIG)/obj/config.o $(CFLAGS) $(DFLAGS) $(IFLAGS) src/config.c

#
#   convenience.o
#
DEPS_32 += $(CONFIG)/inc/bit.h
DEPS_32 += $(CONFIG)/inc/appweb.h

$(CONFIG)/obj/convenience.o: \
    src/convenience.c $(DEPS_32)
	@echo '   [Compile] src/convenience.c'
	$(CC) -c -o $(CONFIG)/obj/convenience.o $(CFLAGS) $(DFLAGS) $(IFLAGS) src/convenience.c

#
#   dirHandler.o
#
DEPS_33 += $(CONFIG)/inc/bit.h
DEPS_33 += $(CONFIG)/inc/appweb.h

$(CONFIG)/obj/dirHandler.o: \
    src/dirHandler.c $(DEPS_33)
	@echo '   [Compile] src/dirHandler.c'
	$(CC) -c -o $(CONFIG)/obj/dirHandler.o $(CFLAGS) $(DFLAGS) $(IFLAGS) src/dirHandler.c

#
#   fileHandler.o
#
DEPS_34 += $(CONFIG)/inc/bit.h
DEPS_34 += $(CONFIG)/inc/appweb.h

$(CONFIG)/obj/fileHandler.o: \
    src/fileHandler.c $(DEPS_34)
	@echo '   [Compile] src/fileHandler.c'
	$(CC) -c -o $(CONFIG)/obj/fileHandler.o $(CFLAGS) $(DFLAGS) $(IFLAGS) src/fileHandler.c

#
#   log.o
#
DEPS_35 += $(CONFIG)/inc/bit.h
DEPS_35 += $(CONFIG)/inc/appweb.h

$(CONFIG)/obj/log.o: \
    src/log.c $(DEPS_35)
	@echo '   [Compile] src/log.c'
	$(CC) -c -o $(CONFIG)/obj/log.o $(CFLAGS) $(DFLAGS) $(IFLAGS) src/log.c

#
#   server.o
#
DEPS_36 += $(CONFIG)/inc/bit.h
DEPS_36 += $(CONFIG)/inc/appweb.h

$(CONFIG)/obj/server.o: \
    src/server.c $(DEPS_36)
	@echo '   [Compile] src/server.c'
	$(CC) -c -o $(CONFIG)/obj/server.o $(CFLAGS) $(DFLAGS) $(IFLAGS) src/server.c

#
#   libappweb
#
DEPS_37 += $(CONFIG)/bin/libhttp.out
DEPS_37 += $(CONFIG)/inc/appweb.h
DEPS_37 += $(CONFIG)/inc/bitos.h
DEPS_37 += $(CONFIG)/inc/customize.h
DEPS_37 += $(CONFIG)/obj/config.o
DEPS_37 += $(CONFIG)/obj/convenience.o
DEPS_37 += $(CONFIG)/obj/dirHandler.o
DEPS_37 += $(CONFIG)/obj/fileHandler.o
DEPS_37 += $(CONFIG)/obj/log.o
DEPS_37 += $(CONFIG)/obj/server.o

LIBS_37 += -lhttp
LIBS_37 += -lpcre
LIBS_37 += -lmpr

$(CONFIG)/bin/libappweb.out: $(DEPS_37)
	@echo '      [Link] libappweb'
	$(CC) -r -o $(CONFIG)/bin/libappweb.out $(LDFLAGS) $(LIBPATHS) $(CONFIG)/obj/config.o $(CONFIG)/obj/convenience.o $(CONFIG)/obj/dirHandler.o $(CONFIG)/obj/fileHandler.o $(CONFIG)/obj/log.o $(CONFIG)/obj/server.o 

#
#   edi.h
#
$(CONFIG)/inc/edi.h: $(DEPS_38)
	@echo '      [File] $(CONFIG)/inc/edi.h'
	mkdir -p "$(CONFIG)/inc"
	cp "src/esp/edi.h" "$(CONFIG)/inc/edi.h"

#
#   esp-app.h
#
$(CONFIG)/inc/esp-app.h: $(DEPS_39)
	@echo '      [File] $(CONFIG)/inc/esp-app.h'
	mkdir -p "$(CONFIG)/inc"
	cp "src/esp/esp-app.h" "$(CONFIG)/inc/esp-app.h"

#
#   esp.h
#
$(CONFIG)/inc/esp.h: $(DEPS_40)
	@echo '      [File] $(CONFIG)/inc/esp.h'
	mkdir -p "$(CONFIG)/inc"
	cp "src/esp/esp.h" "$(CONFIG)/inc/esp.h"

#
#   mdb.h
#
$(CONFIG)/inc/mdb.h: $(DEPS_41)
	@echo '      [File] $(CONFIG)/inc/mdb.h'
	mkdir -p "$(CONFIG)/inc"
	cp "src/esp/mdb.h" "$(CONFIG)/inc/mdb.h"

#
#   edi.o
#
DEPS_42 += $(CONFIG)/inc/bit.h
DEPS_42 += $(CONFIG)/inc/edi.h
DEPS_42 += $(CONFIG)/inc/pcre.h

$(CONFIG)/obj/edi.o: \
    src/esp/edi.c $(DEPS_42)
	@echo '   [Compile] src/esp/edi.c'
	$(CC) -c -o $(CONFIG)/obj/edi.o $(CFLAGS) $(DFLAGS) $(IFLAGS) src/esp/edi.c

#
#   esp.o
#
DEPS_43 += $(CONFIG)/inc/bit.h
DEPS_43 += $(CONFIG)/inc/esp.h

$(CONFIG)/obj/esp.o: \
    src/esp/esp.c $(DEPS_43)
	@echo '   [Compile] src/esp/esp.c'
	$(CC) -c -o $(CONFIG)/obj/esp.o $(CFLAGS) $(DFLAGS) $(IFLAGS) src/esp/esp.c

#
#   espAbbrev.o
#
DEPS_44 += $(CONFIG)/inc/bit.h
DEPS_44 += $(CONFIG)/inc/esp.h

$(CONFIG)/obj/espAbbrev.o: \
    src/esp/espAbbrev.c $(DEPS_44)
	@echo '   [Compile] src/esp/espAbbrev.c'
	$(CC) -c -o $(CONFIG)/obj/espAbbrev.o $(CFLAGS) $(DFLAGS) $(IFLAGS) src/esp/espAbbrev.c

#
#   espFramework.o
#
DEPS_45 += $(CONFIG)/inc/bit.h
DEPS_45 += $(CONFIG)/inc/esp.h

$(CONFIG)/obj/espFramework.o: \
    src/esp/espFramework.c $(DEPS_45)
	@echo '   [Compile] src/esp/espFramework.c'
	$(CC) -c -o $(CONFIG)/obj/espFramework.o $(CFLAGS) $(DFLAGS) $(IFLAGS) src/esp/espFramework.c

#
#   espHandler.o
#
DEPS_46 += $(CONFIG)/inc/bit.h
DEPS_46 += $(CONFIG)/inc/appweb.h
DEPS_46 += $(CONFIG)/inc/esp.h
DEPS_46 += $(CONFIG)/inc/edi.h

$(CONFIG)/obj/espHandler.o: \
    src/esp/espHandler.c $(DEPS_46)
	@echo '   [Compile] src/esp/espHandler.c'
	$(CC) -c -o $(CONFIG)/obj/espHandler.o $(CFLAGS) $(DFLAGS) $(IFLAGS) src/esp/espHandler.c

#
#   espHtml.o
#
DEPS_47 += $(CONFIG)/inc/bit.h
DEPS_47 += $(CONFIG)/inc/esp.h
DEPS_47 += $(CONFIG)/inc/edi.h

$(CONFIG)/obj/espHtml.o: \
    src/esp/espHtml.c $(DEPS_47)
	@echo '   [Compile] src/esp/espHtml.c'
	$(CC) -c -o $(CONFIG)/obj/espHtml.o $(CFLAGS) $(DFLAGS) $(IFLAGS) src/esp/espHtml.c

#
#   espTemplate.o
#
DEPS_48 += $(CONFIG)/inc/bit.h
DEPS_48 += $(CONFIG)/inc/esp.h

$(CONFIG)/obj/espTemplate.o: \
    src/esp/espTemplate.c $(DEPS_48)
	@echo '   [Compile] src/esp/espTemplate.c'
	$(CC) -c -o $(CONFIG)/obj/espTemplate.o $(CFLAGS) $(DFLAGS) $(IFLAGS) src/esp/espTemplate.c

#
#   mdb.o
#
DEPS_49 += $(CONFIG)/inc/bit.h
DEPS_49 += $(CONFIG)/inc/appweb.h
DEPS_49 += $(CONFIG)/inc/edi.h
DEPS_49 += $(CONFIG)/inc/mdb.h
DEPS_49 += $(CONFIG)/inc/pcre.h

$(CONFIG)/obj/mdb.o: \
    src/esp/mdb.c $(DEPS_49)
	@echo '   [Compile] src/esp/mdb.c'
	$(CC) -c -o $(CONFIG)/obj/mdb.o $(CFLAGS) $(DFLAGS) $(IFLAGS) src/esp/mdb.c

#
#   sdb.o
#
DEPS_50 += $(CONFIG)/inc/bit.h
DEPS_50 += $(CONFIG)/inc/appweb.h
DEPS_50 += $(CONFIG)/inc/edi.h

$(CONFIG)/obj/sdb.o: \
    src/esp/sdb.c $(DEPS_50)
	@echo '   [Compile] src/esp/sdb.c'
	$(CC) -c -o $(CONFIG)/obj/sdb.o $(CFLAGS) $(DFLAGS) $(IFLAGS) src/esp/sdb.c

ifeq ($(BIT_PACK_ESP),1)
#
#   libmod_esp
#
DEPS_51 += $(CONFIG)/bin/libappweb.out
DEPS_51 += $(CONFIG)/inc/edi.h
DEPS_51 += $(CONFIG)/inc/esp-app.h
DEPS_51 += $(CONFIG)/inc/esp.h
DEPS_51 += $(CONFIG)/inc/mdb.h
DEPS_51 += $(CONFIG)/obj/edi.o
DEPS_51 += $(CONFIG)/obj/esp.o
DEPS_51 += $(CONFIG)/obj/espAbbrev.o
DEPS_51 += $(CONFIG)/obj/espFramework.o
DEPS_51 += $(CONFIG)/obj/espHandler.o
DEPS_51 += $(CONFIG)/obj/espHtml.o
DEPS_51 += $(CONFIG)/obj/espTemplate.o
DEPS_51 += $(CONFIG)/obj/mdb.o
DEPS_51 += $(CONFIG)/obj/sdb.o

LIBS_51 += -lappweb
LIBS_51 += -lhttp
LIBS_51 += -lpcre
LIBS_51 += -lmpr

$(CONFIG)/bin/libmod_esp.out: $(DEPS_51)
	@echo '      [Link] libmod_esp'
	$(CC) -r -o $(CONFIG)/bin/libmod_esp.out $(LDFLAGS) $(LIBPATHS) $(CONFIG)/obj/edi.o $(CONFIG)/obj/esp.o $(CONFIG)/obj/espAbbrev.o $(CONFIG)/obj/espFramework.o $(CONFIG)/obj/espHandler.o $(CONFIG)/obj/espHtml.o $(CONFIG)/obj/espTemplate.o $(CONFIG)/obj/mdb.o $(CONFIG)/obj/sdb.o 
endif

ifeq ($(BIT_PACK_ESP),1)
#
#   esp
#
DEPS_52 += $(CONFIG)/bin/libappweb.out
DEPS_52 += $(CONFIG)/obj/edi.o
DEPS_52 += $(CONFIG)/obj/esp.o
DEPS_52 += $(CONFIG)/obj/espAbbrev.o
DEPS_52 += $(CONFIG)/obj/espFramework.o
DEPS_52 += $(CONFIG)/obj/espHandler.o
DEPS_52 += $(CONFIG)/obj/espHtml.o
DEPS_52 += $(CONFIG)/obj/espTemplate.o
DEPS_52 += $(CONFIG)/obj/mdb.o
DEPS_52 += $(CONFIG)/obj/sdb.o

LIBS_52 += -lappweb
LIBS_52 += -lhttp
LIBS_52 += -lpcre
LIBS_52 += -lmpr

$(CONFIG)/bin/esp.out: $(DEPS_52)
	@echo '      [Link] esp'
	$(CC) -o $(CONFIG)/bin/esp.out $(LDFLAGS) $(LIBPATHS) $(CONFIG)/obj/edi.o $(CONFIG)/obj/esp.o $(CONFIG)/obj/espAbbrev.o $(CONFIG)/obj/espFramework.o $(CONFIG)/obj/espHandler.o $(CONFIG)/obj/espHtml.o $(CONFIG)/obj/espTemplate.o $(CONFIG)/obj/mdb.o $(CONFIG)/obj/sdb.o $(LDFLAGS)
endif

ifeq ($(BIT_PACK_ESP),1)
#
#   esp.conf
#
DEPS_53 += src/esp/esp.conf

$(CONFIG)/bin/esp.conf: $(DEPS_53)
	@echo '      [File] $(CONFIG)/bin/esp.conf'
	mkdir -p "$(CONFIG)/bin"
	cp "src/esp/esp.conf" "$(CONFIG)/bin/esp.conf"
endif

ifeq ($(BIT_PACK_ESP),1)
#
#   esp.conf.server
#
DEPS_54 += src/esp/esp.conf

src/server/esp.conf: $(DEPS_54)
	@echo '      [File] src/server/esp.conf'
	mkdir -p "src/server"
	cp "src/esp/esp.conf" "src/server/esp.conf"
endif

ifeq ($(BIT_PACK_ESP),1)
#
#   esp.www
#
DEPS_55 += src/esp/esp-www

$(CONFIG)/bin/esp-www: $(DEPS_55)
	@echo '      [File] $(CONFIG)/bin/esp-www'
	mkdir -p "$(CONFIG)/bin/esp-www"
	cp "src/esp/esp-www/app.conf" "$(CONFIG)/bin/esp-www/app.conf"
	cp "src/esp/esp-www/appweb.conf" "$(CONFIG)/bin/esp-www/appweb.conf"
	mkdir -p "$(CONFIG)/bin/esp-www/files/layouts"
	cp "src/esp/esp-www/files/layouts/default.esp" "$(CONFIG)/bin/esp-www/files/layouts/default.esp"
	mkdir -p "$(CONFIG)/bin/esp-www/files/static/images"
	cp "src/esp/esp-www/files/static/images/banner.jpg" "$(CONFIG)/bin/esp-www/files/static/images/banner.jpg"
	cp "src/esp/esp-www/files/static/images/favicon.ico" "$(CONFIG)/bin/esp-www/files/static/images/favicon.ico"
	cp "src/esp/esp-www/files/static/images/splash.jpg" "$(CONFIG)/bin/esp-www/files/static/images/splash.jpg"
	mkdir -p "$(CONFIG)/bin/esp-www/files/static"
	cp "src/esp/esp-www/files/static/index.esp" "$(CONFIG)/bin/esp-www/files/static/index.esp"
	mkdir -p "$(CONFIG)/bin/esp-www/files/static/js"
	cp "src/esp/esp-www/files/static/js/jquery.esp.js" "$(CONFIG)/bin/esp-www/files/static/js/jquery.esp.js"
	cp "src/esp/esp-www/files/static/js/jquery.js" "$(CONFIG)/bin/esp-www/files/static/js/jquery.js"
	cp "src/esp/esp-www/files/static/js/jquery.simplemodal.js" "$(CONFIG)/bin/esp-www/files/static/js/jquery.simplemodal.js"
	cp "src/esp/esp-www/files/static/js/jquery.tablesorter.js" "$(CONFIG)/bin/esp-www/files/static/js/jquery.tablesorter.js"
	cp "src/esp/esp-www/files/static/layout.css" "$(CONFIG)/bin/esp-www/files/static/layout.css"
	mkdir -p "$(CONFIG)/bin/esp-www/files/static/themes"
	cp "src/esp/esp-www/files/static/themes/default.css" "$(CONFIG)/bin/esp-www/files/static/themes/default.css"
endif

ifeq ($(BIT_PACK_ESP),1)
#
#   esp-appweb.conf
#
DEPS_56 += src/esp/esp-appweb.conf

$(CONFIG)/bin/esp-appweb.conf: $(DEPS_56)
	@echo '      [File] $(CONFIG)/bin/esp-appweb.conf'
	mkdir -p "$(CONFIG)/bin"
	cp "src/esp/esp-appweb.conf" "$(CONFIG)/bin/esp-appweb.conf"
endif

#
#   ejs.h
#
$(CONFIG)/inc/ejs.h: $(DEPS_57)
	@echo '      [File] $(CONFIG)/inc/ejs.h'
	mkdir -p "$(CONFIG)/inc"
	cp "src/deps/ejs/ejs.h" "$(CONFIG)/inc/ejs.h"

#
#   ejs.slots.h
#
$(CONFIG)/inc/ejs.slots.h: $(DEPS_58)
	@echo '      [File] $(CONFIG)/inc/ejs.slots.h'
	mkdir -p "$(CONFIG)/inc"
	cp "src/deps/ejs/ejs.slots.h" "$(CONFIG)/inc/ejs.slots.h"

#
#   ejsByteGoto.h
#
$(CONFIG)/inc/ejsByteGoto.h: $(DEPS_59)
	@echo '      [File] $(CONFIG)/inc/ejsByteGoto.h'
	mkdir -p "$(CONFIG)/inc"
	cp "src/deps/ejs/ejsByteGoto.h" "$(CONFIG)/inc/ejsByteGoto.h"

#
#   ejsLib.o
#
DEPS_60 += $(CONFIG)/inc/bit.h
DEPS_60 += $(CONFIG)/inc/ejs.h
DEPS_60 += $(CONFIG)/inc/mpr.h
DEPS_60 += $(CONFIG)/inc/pcre.h
DEPS_60 += $(CONFIG)/inc/bitos.h
DEPS_60 += $(CONFIG)/inc/http.h
DEPS_60 += $(CONFIG)/inc/ejs.slots.h

$(CONFIG)/obj/ejsLib.o: \
    src/deps/ejs/ejsLib.c $(DEPS_60)
	@echo '   [Compile] src/deps/ejs/ejsLib.c'
	$(CC) -c -o $(CONFIG)/obj/ejsLib.o $(CFLAGS) $(DFLAGS) $(IFLAGS) src/deps/ejs/ejsLib.c

ifeq ($(BIT_PACK_EJSCRIPT),1)
#
#   libejs
#
DEPS_61 += $(CONFIG)/bin/libhttp.out
DEPS_61 += $(CONFIG)/bin/libpcre.out
DEPS_61 += $(CONFIG)/bin/libmpr.out
ifeq ($(BIT_PACK_SQLITE),1)
    DEPS_61 += $(CONFIG)/bin/libsqlite3.out
endif
DEPS_61 += $(CONFIG)/inc/ejs.h
DEPS_61 += $(CONFIG)/inc/ejs.slots.h
DEPS_61 += $(CONFIG)/inc/ejsByteGoto.h
DEPS_61 += $(CONFIG)/obj/ejsLib.o

ifeq ($(BIT_PACK_SQLITE),1)
    LIBS_61 += -lsqlite3
endif
LIBS_61 += -lmpr
LIBS_61 += -lpcre
LIBS_61 += -lhttp
LIBS_61 += -lpcre
LIBS_61 += -lmpr

$(CONFIG)/bin/libejs.out: $(DEPS_61)
	@echo '      [Link] libejs'
	$(CC) -r -o $(CONFIG)/bin/libejs.out $(LDFLAGS) $(LIBPATHS) $(CONFIG)/obj/ejsLib.o 
endif

#
#   ejs.o
#
DEPS_62 += $(CONFIG)/inc/bit.h
DEPS_62 += $(CONFIG)/inc/ejs.h

$(CONFIG)/obj/ejs.o: \
    src/deps/ejs/ejs.c $(DEPS_62)
	@echo '   [Compile] src/deps/ejs/ejs.c'
	$(CC) -c -o $(CONFIG)/obj/ejs.o $(CFLAGS) $(DFLAGS) $(IFLAGS) src/deps/ejs/ejs.c

ifeq ($(BIT_PACK_EJSCRIPT),1)
#
#   ejs
#
ifeq ($(BIT_PACK_EJSCRIPT),1)
    DEPS_63 += $(CONFIG)/bin/libejs.out
endif
DEPS_63 += $(CONFIG)/obj/ejs.o

ifeq ($(BIT_PACK_EJSCRIPT),1)
    LIBS_63 += -lejs
endif
ifeq ($(BIT_PACK_SQLITE),1)
    LIBS_63 += -lsqlite3
endif
LIBS_63 += -lmpr
LIBS_63 += -lpcre
LIBS_63 += -lhttp

$(CONFIG)/bin/ejs.out: $(DEPS_63)
	@echo '      [Link] ejs'
	$(CC) -o $(CONFIG)/bin/ejs.out $(LDFLAGS) $(LIBPATHS) $(CONFIG)/obj/ejs.o $(LDFLAGS)
endif

#
#   ejsc.o
#
DEPS_64 += $(CONFIG)/inc/bit.h
DEPS_64 += $(CONFIG)/inc/ejs.h

$(CONFIG)/obj/ejsc.o: \
    src/deps/ejs/ejsc.c $(DEPS_64)
	@echo '   [Compile] src/deps/ejs/ejsc.c'
	$(CC) -c -o $(CONFIG)/obj/ejsc.o $(CFLAGS) $(DFLAGS) $(IFLAGS) src/deps/ejs/ejsc.c

ifeq ($(BIT_PACK_EJSCRIPT),1)
#
#   ejsc
#
ifeq ($(BIT_PACK_EJSCRIPT),1)
    DEPS_65 += $(CONFIG)/bin/libejs.out
endif
DEPS_65 += $(CONFIG)/obj/ejsc.o

ifeq ($(BIT_PACK_EJSCRIPT),1)
    LIBS_65 += -lejs
endif
ifeq ($(BIT_PACK_SQLITE),1)
    LIBS_65 += -lsqlite3
endif
LIBS_65 += -lmpr
LIBS_65 += -lpcre
LIBS_65 += -lhttp

$(CONFIG)/bin/ejsc.out: $(DEPS_65)
	@echo '      [Link] ejsc'
	$(CC) -o $(CONFIG)/bin/ejsc.out $(LDFLAGS) $(LIBPATHS) $(CONFIG)/obj/ejsc.o $(LDFLAGS)
endif

ifeq ($(BIT_PACK_EJSCRIPT),1)
#
#   ejs.mod
#
ifeq ($(BIT_PACK_EJSCRIPT),1)
    DEPS_66 += $(CONFIG)/bin/ejsc.out
endif

$(CONFIG)/bin/ejs.mod: $(DEPS_66)
	$(LBIN)/ejsc --out ./$(CONFIG)/bin/ejs.mod --optimize 9 --bind --require null src/deps/ejs/ejs.es
endif

#
#   cgiHandler.o
#
DEPS_67 += $(CONFIG)/inc/bit.h
DEPS_67 += $(CONFIG)/inc/appweb.h

$(CONFIG)/obj/cgiHandler.o: \
    src/modules/cgiHandler.c $(DEPS_67)
	@echo '   [Compile] src/modules/cgiHandler.c'
	$(CC) -c -o $(CONFIG)/obj/cgiHandler.o $(CFLAGS) $(DFLAGS) $(IFLAGS) src/modules/cgiHandler.c

ifeq ($(BIT_PACK_CGI),1)
#
#   libmod_cgi
#
DEPS_68 += $(CONFIG)/bin/libappweb.out
DEPS_68 += $(CONFIG)/obj/cgiHandler.o

LIBS_68 += -lappweb
LIBS_68 += -lhttp
LIBS_68 += -lpcre
LIBS_68 += -lmpr

$(CONFIG)/bin/libmod_cgi.out: $(DEPS_68)
	@echo '      [Link] libmod_cgi'
	$(CC) -r -o $(CONFIG)/bin/libmod_cgi.out $(LDFLAGS) $(LIBPATHS) $(CONFIG)/obj/cgiHandler.o 
endif

#
#   ejsHandler.o
#
DEPS_69 += $(CONFIG)/inc/bit.h
DEPS_69 += $(CONFIG)/inc/appweb.h

$(CONFIG)/obj/ejsHandler.o: \
    src/modules/ejsHandler.c $(DEPS_69)
	@echo '   [Compile] src/modules/ejsHandler.c'
	$(CC) -c -o $(CONFIG)/obj/ejsHandler.o $(CFLAGS) $(DFLAGS) $(IFLAGS) src/modules/ejsHandler.c

ifeq ($(BIT_PACK_EJSCRIPT),1)
#
#   libmod_ejs
#
DEPS_70 += $(CONFIG)/bin/libappweb.out
ifeq ($(BIT_PACK_EJSCRIPT),1)
    DEPS_70 += $(CONFIG)/bin/libejs.out
endif
DEPS_70 += $(CONFIG)/obj/ejsHandler.o

ifeq ($(BIT_PACK_EJSCRIPT),1)
    LIBS_70 += -lejs
endif
LIBS_70 += -lappweb
LIBS_70 += -lhttp
LIBS_70 += -lpcre
LIBS_70 += -lmpr
ifeq ($(BIT_PACK_SQLITE),1)
    LIBS_70 += -lsqlite3
endif

$(CONFIG)/bin/libmod_ejs.out: $(DEPS_70)
	@echo '      [Link] libmod_ejs'
	$(CC) -r -o $(CONFIG)/bin/libmod_ejs.out $(LDFLAGS) $(LIBPATHS) $(CONFIG)/obj/ejsHandler.o 
endif

#
#   sslModule.o
#
DEPS_71 += $(CONFIG)/inc/bit.h
DEPS_71 += $(CONFIG)/inc/appweb.h

$(CONFIG)/obj/sslModule.o: \
    src/modules/sslModule.c $(DEPS_71)
	@echo '   [Compile] src/modules/sslModule.c'
	$(CC) -c -o $(CONFIG)/obj/sslModule.o $(CFLAGS) $(DFLAGS) $(IFLAGS) src/modules/sslModule.c

#
#   libmod_ssl
#
DEPS_72 += $(CONFIG)/bin/libappweb.out
DEPS_72 += $(CONFIG)/obj/sslModule.o

LIBS_72 += -lappweb
LIBS_72 += -lhttp
LIBS_72 += -lpcre
LIBS_72 += -lmpr

$(CONFIG)/bin/libmod_ssl.out: $(DEPS_72)
	@echo '      [Link] libmod_ssl'
	$(CC) -r -o $(CONFIG)/bin/libmod_ssl.out $(LDFLAGS) $(LIBPATHS) $(CONFIG)/obj/sslModule.o 

#
#   authpass.o
#
DEPS_73 += $(CONFIG)/inc/bit.h
DEPS_73 += $(CONFIG)/inc/appweb.h

$(CONFIG)/obj/authpass.o: \
    src/utils/authpass.c $(DEPS_73)
	@echo '   [Compile] src/utils/authpass.c'
	$(CC) -c -o $(CONFIG)/obj/authpass.o $(CFLAGS) $(DFLAGS) $(IFLAGS) src/utils/authpass.c

#
#   authpass
#
DEPS_74 += $(CONFIG)/bin/libappweb.out
DEPS_74 += $(CONFIG)/obj/authpass.o

LIBS_74 += -lappweb
LIBS_74 += -lhttp
LIBS_74 += -lpcre
LIBS_74 += -lmpr

$(CONFIG)/bin/authpass.out: $(DEPS_74)
	@echo '      [Link] authpass'
	$(CC) -o $(CONFIG)/bin/authpass.out $(LDFLAGS) $(LIBPATHS) $(CONFIG)/obj/authpass.o $(LDFLAGS)

#
#   cgiProgram.o
#
DEPS_75 += $(CONFIG)/inc/bit.h

$(CONFIG)/obj/cgiProgram.o: \
    src/utils/cgiProgram.c $(DEPS_75)
	@echo '   [Compile] src/utils/cgiProgram.c'
	$(CC) -c -o $(CONFIG)/obj/cgiProgram.o $(CFLAGS) $(DFLAGS) $(IFLAGS) src/utils/cgiProgram.c

ifeq ($(BIT_PACK_CGI),1)
#
#   cgiProgram
#
DEPS_76 += $(CONFIG)/obj/cgiProgram.o

$(CONFIG)/bin/cgiProgram.out: $(DEPS_76)
	@echo '      [Link] cgiProgram'
	$(CC) -o $(CONFIG)/bin/cgiProgram.out $(LDFLAGS) $(LIBPATHS) $(CONFIG)/obj/cgiProgram.o $(LDFLAGS)
endif

#
#   slink.c
#
src/server/slink.c: $(DEPS_77)
	cd src/server; [ ! -f slink.c ] && cp slink.empty slink.c ; true ; cd ../..

#
#   slink.o
#
DEPS_78 += $(CONFIG)/inc/bit.h
DEPS_78 += $(CONFIG)/inc/esp.h

$(CONFIG)/obj/slink.o: \
    src/server/slink.c $(DEPS_78)
	@echo '   [Compile] src/server/slink.c'
	$(CC) -c -o $(CONFIG)/obj/slink.o $(CFLAGS) $(DFLAGS) $(IFLAGS) src/server/slink.c

#
#   libapp
#
DEPS_79 += src/server/slink.c
ifeq ($(BIT_PACK_ESP),1)
    DEPS_79 += $(CONFIG)/bin/esp.out
endif
ifeq ($(BIT_PACK_ESP),1)
    DEPS_79 += $(CONFIG)/bin/libmod_esp.out
endif
DEPS_79 += $(CONFIG)/obj/slink.o

ifeq ($(BIT_PACK_ESP),1)
    LIBS_79 += -lmod_esp
endif
LIBS_79 += -lappweb
LIBS_79 += -lhttp
LIBS_79 += -lpcre
LIBS_79 += -lmpr

$(CONFIG)/bin/libapp.out: $(DEPS_79)
	@echo '      [Link] libapp'
	$(CC) -r -o $(CONFIG)/bin/libapp.out $(LDFLAGS) $(LIBPATHS) $(CONFIG)/obj/slink.o 

#
#   appweb.o
#
DEPS_80 += $(CONFIG)/inc/bit.h
DEPS_80 += $(CONFIG)/inc/appweb.h
DEPS_80 += $(CONFIG)/inc/esp.h

$(CONFIG)/obj/appweb.o: \
    src/server/appweb.c $(DEPS_80)
	@echo '   [Compile] src/server/appweb.c'
	$(CC) -c -o $(CONFIG)/obj/appweb.o $(CFLAGS) $(DFLAGS) $(IFLAGS) src/server/appweb.c

#
#   appweb
#
DEPS_81 += $(CONFIG)/bin/libappweb.out
ifeq ($(BIT_PACK_ESP),1)
    DEPS_81 += $(CONFIG)/bin/libmod_esp.out
endif
DEPS_81 += $(CONFIG)/bin/libmod_ssl.out
ifeq ($(BIT_PACK_EJSCRIPT),1)
    DEPS_81 += $(CONFIG)/bin/libmod_ejs.out
endif
ifeq ($(BIT_PACK_CGI),1)
    DEPS_81 += $(CONFIG)/bin/libmod_cgi.out
endif
DEPS_81 += $(CONFIG)/bin/libapp.out
DEPS_81 += $(CONFIG)/obj/appweb.o

LIBS_81 += -lapp
ifeq ($(BIT_PACK_CGI),1)
    LIBS_81 += -lmod_cgi
endif
ifeq ($(BIT_PACK_EJSCRIPT),1)
    LIBS_81 += -lmod_ejs
endif
LIBS_81 += -lmod_ssl
ifeq ($(BIT_PACK_ESP),1)
    LIBS_81 += -lmod_esp
endif
LIBS_81 += -lappweb
LIBS_81 += -lhttp
LIBS_81 += -lpcre
LIBS_81 += -lmpr
ifeq ($(BIT_PACK_EJSCRIPT),1)
    LIBS_81 += -lejs
endif
ifeq ($(BIT_PACK_SQLITE),1)
    LIBS_81 += -lsqlite3
endif

$(CONFIG)/bin/appweb.out: $(DEPS_81)
	@echo '      [Link] appweb'
	$(CC) -o $(CONFIG)/bin/appweb.out $(LDFLAGS) $(LIBPATHS) $(CONFIG)/obj/appweb.o $(LDFLAGS)

#
#   server-cache
#
src/server/cache: $(DEPS_82)
	cd src/server; mkdir -p cache ; cd ../..

#
#   testAppweb.h
#
$(CONFIG)/inc/testAppweb.h: $(DEPS_83)
	@echo '      [File] $(CONFIG)/inc/testAppweb.h'
	mkdir -p "$(CONFIG)/inc"
	cp "test/testAppweb.h" "$(CONFIG)/inc/testAppweb.h"

#
#   testAppweb.o
#
DEPS_84 += $(CONFIG)/inc/bit.h
DEPS_84 += $(CONFIG)/inc/testAppweb.h
DEPS_84 += $(CONFIG)/inc/mpr.h
DEPS_84 += $(CONFIG)/inc/http.h

$(CONFIG)/obj/testAppweb.o: \
    test/testAppweb.c $(DEPS_84)
	@echo '   [Compile] test/testAppweb.c'
	$(CC) -c -o $(CONFIG)/obj/testAppweb.o $(CFLAGS) $(DFLAGS) $(IFLAGS) test/testAppweb.c

#
#   testHttp.o
#
DEPS_85 += $(CONFIG)/inc/bit.h
DEPS_85 += $(CONFIG)/inc/testAppweb.h

$(CONFIG)/obj/testHttp.o: \
    test/testHttp.c $(DEPS_85)
	@echo '   [Compile] test/testHttp.c'
	$(CC) -c -o $(CONFIG)/obj/testHttp.o $(CFLAGS) $(DFLAGS) $(IFLAGS) test/testHttp.c

#
#   testAppweb
#
DEPS_86 += $(CONFIG)/bin/libappweb.out
DEPS_86 += $(CONFIG)/inc/testAppweb.h
DEPS_86 += $(CONFIG)/obj/testAppweb.o
DEPS_86 += $(CONFIG)/obj/testHttp.o

LIBS_86 += -lappweb
LIBS_86 += -lhttp
LIBS_86 += -lpcre
LIBS_86 += -lmpr

$(CONFIG)/bin/testAppweb.out: $(DEPS_86)
	@echo '      [Link] testAppweb'
	$(CC) -o $(CONFIG)/bin/testAppweb.out $(LDFLAGS) $(LIBPATHS) $(CONFIG)/obj/testAppweb.o $(CONFIG)/obj/testHttp.o $(LDFLAGS)

ifeq ($(BIT_PACK_CGI),1)
#
#   test-testScript
#
ifeq ($(BIT_PACK_CGI),1)
    DEPS_87 += $(CONFIG)/bin/cgiProgram.out
endif

test/cgi-bin/testScript: $(DEPS_87)
	cd test; echo '#!../$(CONFIG)/bin/cgiProgram.out' >cgi-bin/testScript ; chmod +x cgi-bin/testScript ; cd ..
endif

ifeq ($(BIT_PACK_CGI),1)
#
#   test-cache.cgi
#
test/web/caching/cache.cgi: $(DEPS_88)
	cd test; echo "#!`type -p ejs`" >web/caching/cache.cgi ; cd ..
	cd test; echo 'print("HTTP/1.0 200 OK\nContent-Type: text/plain\n\n" + Date() + "\n")' >>web/caching/cache.cgi ; cd ..
	cd test; chmod +x web/caching/cache.cgi ; cd ..
endif

ifeq ($(BIT_PACK_CGI),1)
#
#   test-basic.cgi
#
test/web/auth/basic/basic.cgi: $(DEPS_89)
	cd test; echo "#!`type -p ejs`" >web/auth/basic/basic.cgi ; cd ..
	cd test; echo 'print("HTTP/1.0 200 OK\nContent-Type: text/plain\n\n" + serialize(App.env, {pretty: true}) + "\n")' >>web/auth/basic/basic.cgi ; cd ..
	cd test; chmod +x web/auth/basic/basic.cgi ; cd ..
endif

ifeq ($(BIT_PACK_CGI),1)
#
#   test-cgiProgram
#
ifeq ($(BIT_PACK_CGI),1)
    DEPS_90 += $(CONFIG)/bin/cgiProgram.out
endif

test/cgi-bin/cgiProgram.out: $(DEPS_90)
	cd test; cp ../$(CONFIG)/bin/cgiProgram.out cgi-bin/cgiProgram.out ; cd ..
	cd test; cp ../$(CONFIG)/bin/cgiProgram.out cgi-bin/nph-cgiProgram.out ; cd ..
	cd test; cp ../$(CONFIG)/bin/cgiProgram.out 'cgi-bin/cgi Program.out' ; cd ..
	cd test; cp ../$(CONFIG)/bin/cgiProgram.out web/cgiProgram.cgi ; cd ..
	cd test; chmod +x cgi-bin/* web/cgiProgram.cgi ; cd ..
endif

#
#   test.js
#
DEPS_91 += src/esp/esp-www/files/static/js

test/web/js: $(DEPS_91)
	@echo '      [File] test/web/js'
	mkdir -p "test/web/js"
	cp "src/esp/esp-www/files/static/js/jquery.esp.js" "test/web/js/jquery.esp.js"
	cp "src/esp/esp-www/files/static/js/jquery.js" "test/web/js/jquery.js"
	cp "src/esp/esp-www/files/static/js/jquery.simplemodal.js" "test/web/js/jquery.simplemodal.js"
	cp "src/esp/esp-www/files/static/js/jquery.tablesorter.js" "test/web/js/jquery.tablesorter.js"

#
#   version
#
version: $(DEPS_92)
	@echo 4.3.0-0

#
#   installBinary
#
installBinary: $(DEPS_93)

#
#   install
#
DEPS_94 += installBinary

install: $(DEPS_94)
	

#
#   uninstall
#
uninstall: $(DEPS_95)
	rm -f "$(BIT_VAPP_PREFIX)/install.conf"
	rm -fr "$(BIT_VAPP_PREFIX)/inc/appweb"

#
#   genslink
#
genslink: $(DEPS_96)
	cd src/server; esp --static --genlink slink.c --flat compile ; cd ../..


#
#   run
#
DEPS_97 += compile

run: $(DEPS_97)
	cd src/server; sudo ../../$(CONFIG)/bin/appweb -v ; cd ../..

