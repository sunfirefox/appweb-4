#
#   win-i686-debug.mk -- Build It Makefile to build Embedthis Appweb for win on i686
#

VS             := $(VSINSTALLDIR)
VS             ?= \Users\mob\git\appweb\$(VS)
SDK            := $(WindowsSDKDir)
SDK            ?= $(SDK)

export         SDK VS
export PATH    := $(SDK)/Bin:$(VS)/VC/Bin:$(VS)/Common7/IDE:$(VS)/Common7/Tools:$(VS)/SDK/v3.5/bin:$(VS)/VC/VCPackages;$(PATH)
export INCLUDE := $(INCLUDE);$(SDK)/INCLUDE:$(VS)/VC/INCLUDE
export LIB     := $(LIB);$(SDK)/lib:$(VS)/VC/lib

OS       := win
CONFIG   := $(OS)-i686-debug
CC       := cl.exe
LD       := link.exe
CFLAGS   := -nologo -GR- -W3 -Zi -Od -MDd
DFLAGS   := -D_REENTRANT -D_MT
IFLAGS   := -I$(CONFIG)/inc
LDFLAGS  := '-nologo' '-nodefaultlib' '-incremental:no' '-debug' '-machine:x86'
LIBPATHS := -libpath:$(CONFIG)/bin
LIBS     := ws2_32.lib advapi32.lib user32.lib kernel32.lib oldnames.lib msvcrt.lib shell32.lib

all: prep \
        $(CONFIG)/bin/libmpr.dll \
        $(CONFIG)/bin/libmprssl.dll \
        $(CONFIG)/bin/appman.exe \
        $(CONFIG)/bin/makerom.exe \
        $(CONFIG)/bin/libpcre.dll \
        $(CONFIG)/bin/libhttp.dll \
        $(CONFIG)/bin/http.exe \
        $(CONFIG)/bin/libsqlite3.dll \
        $(CONFIG)/bin/sqlite.exe \
        $(CONFIG)/bin/libappweb.dll \
        $(CONFIG)/bin/mod_esp.dll \
        $(CONFIG)/bin/esp.exe \
        $(CONFIG)/bin/esp.conf \
        $(CONFIG)/bin/esp-www \
        $(CONFIG)/bin/mod_cgi.dll \
        $(CONFIG)/bin/auth.exe \
        $(CONFIG)/bin/cgiProgram.exe \
        $(CONFIG)/bin/setConfig.exe \
        $(CONFIG)/bin/appweb.exe \
        $(CONFIG)/bin/appwebMonitor.exe \
        $(CONFIG)/bin/appwebMonitor.ico \
        $(CONFIG)/bin/testAppweb.exe \
        test/cgi-bin/testScript \
        test/web/caching/cache.cgi \
        test/web/basic/basic.cgi \
        test/cgi-bin/cgiProgram.exe \
        $(CONFIG)/bin/removeFiles.exe

.PHONY: prep

prep:
	@[ ! -x $(CONFIG)/inc ] && mkdir -p $(CONFIG)/inc $(CONFIG)/obj $(CONFIG)/lib $(CONFIG)/bin ; true
	@[ ! -f $(CONFIG)/inc/bit.h ] && cp projects/appweb-$(OS)-bit.h $(CONFIG)/inc/bit.h ; true
	@if ! diff $(CONFIG)/inc/bit.h projects/appweb-$(OS)-bit.h >/dev/null ; then\
		echo cp projects/appweb-$(OS)-bit.h $(CONFIG)/inc/bit.h  ; \
		cp projects/appweb-$(OS)-bit.h $(CONFIG)/inc/bit.h  ; \
	fi; true

clean:
	rm -rf $(CONFIG)/bin/libmpr.dll
	rm -rf $(CONFIG)/bin/libmprssl.dll
	rm -rf $(CONFIG)/bin/appman.exe
	rm -rf $(CONFIG)/bin/makerom.exe
	rm -rf $(CONFIG)/bin/libpcre.dll
	rm -rf $(CONFIG)/bin/libhttp.dll
	rm -rf $(CONFIG)/bin/http.exe
	rm -rf $(CONFIG)/bin/libsqlite3.dll
	rm -rf $(CONFIG)/bin/sqlite.exe
	rm -rf $(CONFIG)/bin/libappweb.dll
	rm -rf $(CONFIG)/bin/mod_esp.dll
	rm -rf $(CONFIG)/bin/esp.exe
	rm -rf $(CONFIG)/bin/esp.conf
	rm -rf $(CONFIG)/bin/esp-www
	rm -rf $(CONFIG)/bin/mod_cgi.dll
	rm -rf $(CONFIG)/bin/mod_ejs.dll
	rm -rf $(CONFIG)/bin/mod_php.dll
	rm -rf $(CONFIG)/bin/mod_ssl.dll
	rm -rf $(CONFIG)/bin/auth.exe
	rm -rf $(CONFIG)/bin/cgiProgram.exe
	rm -rf $(CONFIG)/bin/setConfig.exe
	rm -rf $(CONFIG)/bin/appweb.exe
	rm -rf $(CONFIG)/bin/appwebMonitor.exe
	rm -rf $(CONFIG)/bin/appwebMonitor.ico
	rm -rf $(CONFIG)/bin/testAppweb.exe
	rm -rf test/cgi-bin/testScript
	rm -rf test/web/caching/cache.cgi
	rm -rf test/web/basic/basic.cgi
	rm -rf test/cgi-bin/cgiProgram.exe
	rm -rf $(CONFIG)/bin/removeFiles.exe
	rm -rf $(CONFIG)/obj/mprLib.obj
	rm -rf $(CONFIG)/obj/mprSsl.obj
	rm -rf $(CONFIG)/obj/manager.obj
	rm -rf $(CONFIG)/obj/makerom.obj
	rm -rf $(CONFIG)/obj/pcre.obj
	rm -rf $(CONFIG)/obj/httpLib.obj
	rm -rf $(CONFIG)/obj/http.obj
	rm -rf $(CONFIG)/obj/sqlite3.obj
	rm -rf $(CONFIG)/obj/sqlite.obj
	rm -rf $(CONFIG)/obj/config.obj
	rm -rf $(CONFIG)/obj/convenience.obj
	rm -rf $(CONFIG)/obj/dirHandler.obj
	rm -rf $(CONFIG)/obj/fileHandler.obj
	rm -rf $(CONFIG)/obj/log.obj
	rm -rf $(CONFIG)/obj/server.obj
	rm -rf $(CONFIG)/obj/edi.obj
	rm -rf $(CONFIG)/obj/espAbbrev.obj
	rm -rf $(CONFIG)/obj/espFramework.obj
	rm -rf $(CONFIG)/obj/espHandler.obj
	rm -rf $(CONFIG)/obj/espHtml.obj
	rm -rf $(CONFIG)/obj/espSession.obj
	rm -rf $(CONFIG)/obj/espTemplate.obj
	rm -rf $(CONFIG)/obj/mdb.obj
	rm -rf $(CONFIG)/obj/sdb.obj
	rm -rf $(CONFIG)/obj/esp.obj
	rm -rf $(CONFIG)/obj/cgiHandler.obj
	rm -rf $(CONFIG)/obj/ejsHandler.obj
	rm -rf $(CONFIG)/obj/phpHandler.obj
	rm -rf $(CONFIG)/obj/sslModule.obj
	rm -rf $(CONFIG)/obj/auth.obj
	rm -rf $(CONFIG)/obj/cgiProgram.obj
	rm -rf $(CONFIG)/obj/setConfig.obj
	rm -rf $(CONFIG)/obj/appweb.obj
	rm -rf $(CONFIG)/obj/appwebMonitor.obj
	rm -rf $(CONFIG)/obj/testAppweb.obj
	rm -rf $(CONFIG)/obj/testHttp.obj
	rm -rf $(CONFIG)/obj/removeFiles.obj

clobber: clean
	rm -fr ./$(CONFIG)

$(CONFIG)/inc/mpr.h: 
	rm -fr $(CONFIG)/inc/mpr.h
	cp -r src/deps/mpr/mpr.h $(CONFIG)/inc/mpr.h

$(CONFIG)/obj/mprLib.obj: \
        src/deps/mpr/mprLib.c \
        $(CONFIG)/inc/bit.h
	"$(CC)" -c -Fo$(CONFIG)/obj/mprLib.obj -Fd$(CONFIG)/obj/mprLib.pdb $(CFLAGS) $(DFLAGS) -I$(CONFIG)/inc src/deps/mpr/mprLib.c

$(CONFIG)/bin/libmpr.dll:  \
        $(CONFIG)/inc/mpr.h \
        $(CONFIG)/obj/mprLib.obj
	"$(LD)" -dll -out:$(CONFIG)/bin/libmpr.dll -entry:_DllMainCRTStartup@12 -def:$(CONFIG)/bin/libmpr.def $(LDFLAGS) $(LIBPATHS) $(CONFIG)/obj/mprLib.obj $(LIBS)

$(CONFIG)/obj/mprSsl.obj: \
        src/deps/mpr/mprSsl.c \
        $(CONFIG)/inc/bit.h
	"$(CC)" -c -Fo$(CONFIG)/obj/mprSsl.obj -Fd$(CONFIG)/obj/mprSsl.pdb $(CFLAGS) $(DFLAGS) -I$(CONFIG)/inc src/deps/mpr/mprSsl.c

$(CONFIG)/bin/libmprssl.dll:  \
        $(CONFIG)/bin/libmpr.dll \
        $(CONFIG)/obj/mprSsl.obj
	"$(LD)" -dll -out:$(CONFIG)/bin/libmprssl.dll -entry:_DllMainCRTStartup@12 -def:$(CONFIG)/bin/libmprssl.def $(LDFLAGS) $(LIBPATHS) $(CONFIG)/obj/mprSsl.obj $(LIBS) libmpr.lib

$(CONFIG)/obj/manager.obj: \
        src/deps/mpr/manager.c \
        $(CONFIG)/inc/bit.h
	"$(CC)" -c -Fo$(CONFIG)/obj/manager.obj -Fd$(CONFIG)/obj/manager.pdb $(CFLAGS) $(DFLAGS) -I$(CONFIG)/inc src/deps/mpr/manager.c

$(CONFIG)/bin/appman.exe:  \
        $(CONFIG)/bin/libmpr.dll \
        $(CONFIG)/obj/manager.obj
	"$(LD)" -out:$(CONFIG)/bin/appman.exe -entry:WinMainCRTStartup -subsystem:Windows $(LDFLAGS) $(LIBPATHS) $(CONFIG)/obj/manager.obj $(LIBS) libmpr.lib

$(CONFIG)/obj/makerom.obj: \
        src/deps/mpr/makerom.c \
        $(CONFIG)/inc/bit.h
	"$(CC)" -c -Fo$(CONFIG)/obj/makerom.obj -Fd$(CONFIG)/obj/makerom.pdb $(CFLAGS) $(DFLAGS) -I$(CONFIG)/inc src/deps/mpr/makerom.c

$(CONFIG)/bin/makerom.exe:  \
        $(CONFIG)/bin/libmpr.dll \
        $(CONFIG)/obj/makerom.obj
	"$(LD)" -out:$(CONFIG)/bin/makerom.exe -entry:mainCRTStartup -subsystem:console $(LDFLAGS) $(LIBPATHS) $(CONFIG)/obj/makerom.obj $(LIBS) libmpr.lib

$(CONFIG)/inc/pcre.h: 
	rm -fr $(CONFIG)/inc/pcre.h
	cp -r src/deps/pcre/pcre.h $(CONFIG)/inc/pcre.h

$(CONFIG)/obj/pcre.obj: \
        src/deps/pcre/pcre.c \
        $(CONFIG)/inc/bit.h
	"$(CC)" -c -Fo$(CONFIG)/obj/pcre.obj -Fd$(CONFIG)/obj/pcre.pdb $(CFLAGS) $(DFLAGS) -I$(CONFIG)/inc src/deps/pcre/pcre.c

$(CONFIG)/bin/libpcre.dll:  \
        $(CONFIG)/inc/pcre.h \
        $(CONFIG)/obj/pcre.obj
	"$(LD)" -dll -out:$(CONFIG)/bin/libpcre.dll -entry:_DllMainCRTStartup@12 -def:$(CONFIG)/bin/libpcre.def $(LDFLAGS) $(LIBPATHS) $(CONFIG)/obj/pcre.obj $(LIBS)

$(CONFIG)/inc/http.h: 
	rm -fr $(CONFIG)/inc/http.h
	cp -r src/deps/http/http.h $(CONFIG)/inc/http.h

$(CONFIG)/obj/httpLib.obj: \
        src/deps/http/httpLib.c \
        $(CONFIG)/inc/bit.h
	"$(CC)" -c -Fo$(CONFIG)/obj/httpLib.obj -Fd$(CONFIG)/obj/httpLib.pdb $(CFLAGS) $(DFLAGS) -I$(CONFIG)/inc src/deps/http/httpLib.c

$(CONFIG)/bin/libhttp.dll:  \
        $(CONFIG)/bin/libmpr.dll \
        $(CONFIG)/bin/libpcre.dll \
        $(CONFIG)/bin/libmprssl.dll \
        $(CONFIG)/inc/http.h \
        $(CONFIG)/obj/httpLib.obj
	"$(LD)" -dll -out:$(CONFIG)/bin/libhttp.dll -entry:_DllMainCRTStartup@12 -def:$(CONFIG)/bin/libhttp.def $(LDFLAGS) $(LIBPATHS) $(CONFIG)/obj/httpLib.obj $(LIBS) libmpr.lib libpcre.lib libmprssl.lib

$(CONFIG)/obj/http.obj: \
        src/deps/http/http.c \
        $(CONFIG)/inc/bit.h
	"$(CC)" -c -Fo$(CONFIG)/obj/http.obj -Fd$(CONFIG)/obj/http.pdb $(CFLAGS) $(DFLAGS) -I$(CONFIG)/inc src/deps/http/http.c

$(CONFIG)/bin/http.exe:  \
        $(CONFIG)/bin/libhttp.dll \
        $(CONFIG)/obj/http.obj
	"$(LD)" -out:$(CONFIG)/bin/http.exe -entry:mainCRTStartup -subsystem:console $(LDFLAGS) $(LIBPATHS) $(CONFIG)/obj/http.obj $(LIBS) libhttp.lib libmpr.lib libpcre.lib libmprssl.lib

$(CONFIG)/inc/sqlite3.h: 
	rm -fr $(CONFIG)/inc/sqlite3.h
	cp -r src/deps/sqlite/sqlite3.h $(CONFIG)/inc/sqlite3.h

$(CONFIG)/obj/sqlite3.obj: \
        src/deps/sqlite/sqlite3.c \
        $(CONFIG)/inc/bit.h
	"$(CC)" -c -Fo$(CONFIG)/obj/sqlite3.obj -Fd$(CONFIG)/obj/sqlite3.pdb $(CFLAGS) $(DFLAGS) -I$(CONFIG)/inc src/deps/sqlite/sqlite3.c

$(CONFIG)/bin/libsqlite3.dll:  \
        $(CONFIG)/inc/sqlite3.h \
        $(CONFIG)/obj/sqlite3.obj
	"$(LD)" -dll -out:$(CONFIG)/bin/libsqlite3.dll -entry:_DllMainCRTStartup@12 -def:$(CONFIG)/bin/libsqlite3.def $(LDFLAGS) $(LIBPATHS) $(CONFIG)/obj/sqlite3.obj $(LIBS)

$(CONFIG)/obj/sqlite.obj: \
        src/deps/sqlite/sqlite.c \
        $(CONFIG)/inc/bit.h
	"$(CC)" -c -Fo$(CONFIG)/obj/sqlite.obj -Fd$(CONFIG)/obj/sqlite.pdb $(CFLAGS) $(DFLAGS) -I$(CONFIG)/inc src/deps/sqlite/sqlite.c

$(CONFIG)/bin/sqlite.exe:  \
        $(CONFIG)/bin/libsqlite3.dll \
        $(CONFIG)/obj/sqlite.obj
	"$(LD)" -out:$(CONFIG)/bin/sqlite.exe -entry:mainCRTStartup -subsystem:console $(LDFLAGS) $(LIBPATHS) $(CONFIG)/obj/sqlite.obj $(LIBS) libsqlite3.lib

$(CONFIG)/inc/appweb.h: 
	rm -fr $(CONFIG)/inc/appweb.h
	cp -r src/appweb.h $(CONFIG)/inc/appweb.h

$(CONFIG)/inc/customize.h: 
	rm -fr $(CONFIG)/inc/customize.h
	cp -r src/customize.h $(CONFIG)/inc/customize.h

$(CONFIG)/obj/config.obj: \
        src/config.c \
        $(CONFIG)/inc/bit.h
	"$(CC)" -c -Fo$(CONFIG)/obj/config.obj -Fd$(CONFIG)/obj/config.pdb $(CFLAGS) $(DFLAGS) -I$(CONFIG)/inc src/config.c

$(CONFIG)/obj/convenience.obj: \
        src/convenience.c \
        $(CONFIG)/inc/bit.h
	"$(CC)" -c -Fo$(CONFIG)/obj/convenience.obj -Fd$(CONFIG)/obj/convenience.pdb $(CFLAGS) $(DFLAGS) -I$(CONFIG)/inc src/convenience.c

$(CONFIG)/obj/dirHandler.obj: \
        src/dirHandler.c \
        $(CONFIG)/inc/bit.h
	"$(CC)" -c -Fo$(CONFIG)/obj/dirHandler.obj -Fd$(CONFIG)/obj/dirHandler.pdb $(CFLAGS) $(DFLAGS) -I$(CONFIG)/inc src/dirHandler.c

$(CONFIG)/obj/fileHandler.obj: \
        src/fileHandler.c \
        $(CONFIG)/inc/bit.h
	"$(CC)" -c -Fo$(CONFIG)/obj/fileHandler.obj -Fd$(CONFIG)/obj/fileHandler.pdb $(CFLAGS) $(DFLAGS) -I$(CONFIG)/inc src/fileHandler.c

$(CONFIG)/obj/log.obj: \
        src/log.c \
        $(CONFIG)/inc/bit.h
	"$(CC)" -c -Fo$(CONFIG)/obj/log.obj -Fd$(CONFIG)/obj/log.pdb $(CFLAGS) $(DFLAGS) -I$(CONFIG)/inc src/log.c

$(CONFIG)/obj/server.obj: \
        src/server.c \
        $(CONFIG)/inc/bit.h
	"$(CC)" -c -Fo$(CONFIG)/obj/server.obj -Fd$(CONFIG)/obj/server.pdb $(CFLAGS) $(DFLAGS) -I$(CONFIG)/inc src/server.c

$(CONFIG)/bin/libappweb.dll:  \
        $(CONFIG)/bin/libhttp.dll \
        $(CONFIG)/inc/appweb.h \
        $(CONFIG)/inc/customize.h \
        $(CONFIG)/obj/config.obj \
        $(CONFIG)/obj/convenience.obj \
        $(CONFIG)/obj/dirHandler.obj \
        $(CONFIG)/obj/fileHandler.obj \
        $(CONFIG)/obj/log.obj \
        $(CONFIG)/obj/server.obj
	"$(LD)" -dll -out:$(CONFIG)/bin/libappweb.dll -entry:_DllMainCRTStartup@12 -def:$(CONFIG)/bin/libappweb.def $(LDFLAGS) $(LIBPATHS) $(CONFIG)/obj/config.obj $(CONFIG)/obj/convenience.obj $(CONFIG)/obj/dirHandler.obj $(CONFIG)/obj/fileHandler.obj $(CONFIG)/obj/log.obj $(CONFIG)/obj/server.obj $(LIBS) libhttp.lib libmpr.lib libpcre.lib libmprssl.lib

$(CONFIG)/inc/edi.h: 
	rm -fr $(CONFIG)/inc/edi.h
	cp -r src/esp/edi.h $(CONFIG)/inc/edi.h

$(CONFIG)/inc/esp-app.h: 
	rm -fr $(CONFIG)/inc/esp-app.h
	cp -r src/esp/esp-app.h $(CONFIG)/inc/esp-app.h

$(CONFIG)/inc/esp.h: 
	rm -fr $(CONFIG)/inc/esp.h
	cp -r src/esp/esp.h $(CONFIG)/inc/esp.h

$(CONFIG)/inc/mdb.h: 
	rm -fr $(CONFIG)/inc/mdb.h
	cp -r src/esp/mdb.h $(CONFIG)/inc/mdb.h

$(CONFIG)/obj/edi.obj: \
        src/esp/edi.c \
        $(CONFIG)/inc/bit.h
	"$(CC)" -c -Fo$(CONFIG)/obj/edi.obj -Fd$(CONFIG)/obj/edi.pdb $(CFLAGS) $(DFLAGS) -I$(CONFIG)/inc src/esp/edi.c

$(CONFIG)/obj/espAbbrev.obj: \
        src/esp/espAbbrev.c \
        $(CONFIG)/inc/bit.h
	"$(CC)" -c -Fo$(CONFIG)/obj/espAbbrev.obj -Fd$(CONFIG)/obj/espAbbrev.pdb $(CFLAGS) $(DFLAGS) -I$(CONFIG)/inc src/esp/espAbbrev.c

$(CONFIG)/obj/espFramework.obj: \
        src/esp/espFramework.c \
        $(CONFIG)/inc/bit.h
	"$(CC)" -c -Fo$(CONFIG)/obj/espFramework.obj -Fd$(CONFIG)/obj/espFramework.pdb $(CFLAGS) $(DFLAGS) -I$(CONFIG)/inc src/esp/espFramework.c

$(CONFIG)/obj/espHandler.obj: \
        src/esp/espHandler.c \
        $(CONFIG)/inc/bit.h
	"$(CC)" -c -Fo$(CONFIG)/obj/espHandler.obj -Fd$(CONFIG)/obj/espHandler.pdb $(CFLAGS) $(DFLAGS) -I$(CONFIG)/inc src/esp/espHandler.c

$(CONFIG)/obj/espHtml.obj: \
        src/esp/espHtml.c \
        $(CONFIG)/inc/bit.h
	"$(CC)" -c -Fo$(CONFIG)/obj/espHtml.obj -Fd$(CONFIG)/obj/espHtml.pdb $(CFLAGS) $(DFLAGS) -I$(CONFIG)/inc src/esp/espHtml.c

$(CONFIG)/obj/espSession.obj: \
        src/esp/espSession.c \
        $(CONFIG)/inc/bit.h
	"$(CC)" -c -Fo$(CONFIG)/obj/espSession.obj -Fd$(CONFIG)/obj/espSession.pdb $(CFLAGS) $(DFLAGS) -I$(CONFIG)/inc src/esp/espSession.c

$(CONFIG)/obj/espTemplate.obj: \
        src/esp/espTemplate.c \
        $(CONFIG)/inc/bit.h
	"$(CC)" -c -Fo$(CONFIG)/obj/espTemplate.obj -Fd$(CONFIG)/obj/espTemplate.pdb $(CFLAGS) $(DFLAGS) -I$(CONFIG)/inc src/esp/espTemplate.c

$(CONFIG)/obj/mdb.obj: \
        src/esp/mdb.c \
        $(CONFIG)/inc/bit.h
	"$(CC)" -c -Fo$(CONFIG)/obj/mdb.obj -Fd$(CONFIG)/obj/mdb.pdb $(CFLAGS) $(DFLAGS) -I$(CONFIG)/inc src/esp/mdb.c

$(CONFIG)/obj/sdb.obj: \
        src/esp/sdb.c \
        $(CONFIG)/inc/bit.h
	"$(CC)" -c -Fo$(CONFIG)/obj/sdb.obj -Fd$(CONFIG)/obj/sdb.pdb $(CFLAGS) $(DFLAGS) -I$(CONFIG)/inc src/esp/sdb.c

$(CONFIG)/bin/mod_esp.dll:  \
        $(CONFIG)/bin/libappweb.dll \
        $(CONFIG)/inc/edi.h \
        $(CONFIG)/inc/esp-app.h \
        $(CONFIG)/inc/esp.h \
        $(CONFIG)/inc/mdb.h \
        $(CONFIG)/obj/edi.obj \
        $(CONFIG)/obj/espAbbrev.obj \
        $(CONFIG)/obj/espFramework.obj \
        $(CONFIG)/obj/espHandler.obj \
        $(CONFIG)/obj/espHtml.obj \
        $(CONFIG)/obj/espSession.obj \
        $(CONFIG)/obj/espTemplate.obj \
        $(CONFIG)/obj/mdb.obj \
        $(CONFIG)/obj/sdb.obj
	"$(LD)" -dll -out:$(CONFIG)/bin/mod_esp.dll -entry:_DllMainCRTStartup@12 -def:$(CONFIG)/bin/mod_esp.def $(LDFLAGS) $(LIBPATHS) $(CONFIG)/obj/edi.obj $(CONFIG)/obj/espAbbrev.obj $(CONFIG)/obj/espFramework.obj $(CONFIG)/obj/espHandler.obj $(CONFIG)/obj/espHtml.obj $(CONFIG)/obj/espSession.obj $(CONFIG)/obj/espTemplate.obj $(CONFIG)/obj/mdb.obj $(CONFIG)/obj/sdb.obj $(LIBS) libappweb.lib libhttp.lib libmpr.lib libpcre.lib libmprssl.lib

$(CONFIG)/obj/esp.obj: \
        src/esp/esp.c \
        $(CONFIG)/inc/bit.h
	"$(CC)" -c -Fo$(CONFIG)/obj/esp.obj -Fd$(CONFIG)/obj/esp.pdb $(CFLAGS) $(DFLAGS) -I$(CONFIG)/inc src/esp/esp.c

$(CONFIG)/bin/esp.exe:  \
        $(CONFIG)/bin/libappweb.dll \
        $(CONFIG)/obj/edi.obj \
        $(CONFIG)/obj/esp.obj \
        $(CONFIG)/obj/espAbbrev.obj \
        $(CONFIG)/obj/espFramework.obj \
        $(CONFIG)/obj/espHandler.obj \
        $(CONFIG)/obj/espHtml.obj \
        $(CONFIG)/obj/espSession.obj \
        $(CONFIG)/obj/espTemplate.obj \
        $(CONFIG)/obj/mdb.obj \
        $(CONFIG)/obj/sdb.obj
	"$(LD)" -out:$(CONFIG)/bin/esp.exe -entry:mainCRTStartup -subsystem:console $(LDFLAGS) $(LIBPATHS) $(CONFIG)/obj/edi.obj $(CONFIG)/obj/esp.obj $(CONFIG)/obj/espAbbrev.obj $(CONFIG)/obj/espFramework.obj $(CONFIG)/obj/espHandler.obj $(CONFIG)/obj/espHtml.obj $(CONFIG)/obj/espSession.obj $(CONFIG)/obj/espTemplate.obj $(CONFIG)/obj/mdb.obj $(CONFIG)/obj/sdb.obj $(LIBS) libappweb.lib libhttp.lib libmpr.lib libpcre.lib libmprssl.lib

$(CONFIG)/bin/esp.conf: 
	rm -fr $(CONFIG)/bin/esp.conf
	cp -r src/esp/esp.conf $(CONFIG)/bin/esp.conf

$(CONFIG)/bin/esp-www: 
	rm -fr $(CONFIG)/bin/esp-www
	cp -r src/esp/www $(CONFIG)/bin/esp-www

$(CONFIG)/obj/cgiHandler.obj: \
        src/modules/cgiHandler.c \
        $(CONFIG)/inc/bit.h
	"$(CC)" -c -Fo$(CONFIG)/obj/cgiHandler.obj -Fd$(CONFIG)/obj/cgiHandler.pdb $(CFLAGS) $(DFLAGS) -I$(CONFIG)/inc src/modules/cgiHandler.c

$(CONFIG)/bin/mod_cgi.dll:  \
        $(CONFIG)/bin/libappweb.dll \
        $(CONFIG)/obj/cgiHandler.obj
	"$(LD)" -dll -out:$(CONFIG)/bin/mod_cgi.dll -entry:_DllMainCRTStartup@12 -def:$(CONFIG)/bin/mod_cgi.def $(LDFLAGS) $(LIBPATHS) $(CONFIG)/obj/cgiHandler.obj $(LIBS) libappweb.lib libhttp.lib libmpr.lib libpcre.lib libmprssl.lib

$(CONFIG)/obj/auth.obj: \
        src/utils/auth.c \
        $(CONFIG)/inc/bit.h
	"$(CC)" -c -Fo$(CONFIG)/obj/auth.obj -Fd$(CONFIG)/obj/auth.pdb $(CFLAGS) $(DFLAGS) -I$(CONFIG)/inc src/utils/auth.c

$(CONFIG)/bin/auth.exe:  \
        $(CONFIG)/bin/libmpr.dll \
        $(CONFIG)/obj/auth.obj
	"$(LD)" -out:$(CONFIG)/bin/auth.exe -entry:mainCRTStartup -subsystem:console $(LDFLAGS) $(LIBPATHS) $(CONFIG)/obj/auth.obj $(LIBS) libmpr.lib

$(CONFIG)/obj/cgiProgram.obj: \
        src/utils/cgiProgram.c \
        $(CONFIG)/inc/bit.h
	"$(CC)" -c -Fo$(CONFIG)/obj/cgiProgram.obj -Fd$(CONFIG)/obj/cgiProgram.pdb $(CFLAGS) $(DFLAGS) -I$(CONFIG)/inc src/utils/cgiProgram.c

$(CONFIG)/bin/cgiProgram.exe:  \
        $(CONFIG)/obj/cgiProgram.obj
	"$(LD)" -out:$(CONFIG)/bin/cgiProgram.exe -entry:mainCRTStartup -subsystem:console $(LDFLAGS) $(LIBPATHS) $(CONFIG)/obj/cgiProgram.obj $(LIBS)

$(CONFIG)/obj/setConfig.obj: \
        src/utils/setConfig.c \
        $(CONFIG)/inc/bit.h
	"$(CC)" -c -Fo$(CONFIG)/obj/setConfig.obj -Fd$(CONFIG)/obj/setConfig.pdb $(CFLAGS) $(DFLAGS) -I$(CONFIG)/inc src/utils/setConfig.c

$(CONFIG)/bin/setConfig.exe:  \
        $(CONFIG)/bin/libmpr.dll \
        $(CONFIG)/obj/setConfig.obj
	"$(LD)" -out:$(CONFIG)/bin/setConfig.exe -entry:WinMainCRTStartup -subsystem:Windows $(LDFLAGS) $(LIBPATHS) $(CONFIG)/obj/setConfig.obj $(LIBS) libmpr.lib

$(CONFIG)/inc/appwebMonitor.h: 
	rm -fr $(CONFIG)/inc/appwebMonitor.h
	cp -r src/server/appwebMonitor.h $(CONFIG)/inc/appwebMonitor.h

$(CONFIG)/obj/appweb.obj: \
        src/server/appweb.c \
        $(CONFIG)/inc/bit.h
	"$(CC)" -c -Fo$(CONFIG)/obj/appweb.obj -Fd$(CONFIG)/obj/appweb.pdb $(CFLAGS) $(DFLAGS) -I$(CONFIG)/inc src/server/appweb.c

$(CONFIG)/bin/appweb.exe:  \
        $(CONFIG)/bin/libappweb.dll \
        $(CONFIG)/inc/appwebMonitor.h \
        $(CONFIG)/obj/appweb.obj
	"$(LD)" -out:$(CONFIG)/bin/appweb.exe -entry:mainCRTStartup -subsystem:console $(LDFLAGS) $(LIBPATHS) $(CONFIG)/obj/appweb.obj $(LIBS) libappweb.lib libhttp.lib libmpr.lib libpcre.lib libmprssl.lib

$(CONFIG)/obj/appwebMonitor.res: \
        src/server/WIN/appwebMonitor.rc
	"rc" -nologo -Fo $(CONFIG)/obj/appwebMonitor.res src/server/WIN/appwebMonitor.rc

$(CONFIG)/obj/appwebMonitor.obj: \
        src/server/WIN/appwebMonitor.c \
        $(CONFIG)/inc/bit.h
	"$(CC)" -c -Fo$(CONFIG)/obj/appwebMonitor.obj -Fd$(CONFIG)/obj/appwebMonitor.pdb $(CFLAGS) $(DFLAGS) -I$(CONFIG)/inc src/server/WIN/appwebMonitor.c

$(CONFIG)/bin/appwebMonitor.exe:  \
        $(CONFIG)/bin/libappweb.dll \
        $(CONFIG)/obj/appwebMonitor.res \
        $(CONFIG)/obj/appwebMonitor.obj
	"$(LD)" -out:$(CONFIG)/bin/appwebMonitor.exe -entry:WinMainCRTStartup -subsystem:Windows $(LDFLAGS) $(LIBPATHS) $(CONFIG)/obj/appwebMonitor.res $(CONFIG)/obj/appwebMonitor.obj shell32.lib libappweb.lib ws2_32.lib advapi32.lib user32.lib kernel32.lib oldnames.lib msvcrt.lib libhttp.lib libmpr.lib libpcre.lib libmprssl.lib

$(CONFIG)/bin/appwebMonitor.ico: 
	rm -fr $(CONFIG)/bin/appwebMonitor.ico
	cp -r src/server/WIN/appwebMonitor.ico $(CONFIG)/bin/appwebMonitor.ico

$(CONFIG)/inc/testAppweb.h: 
	rm -fr $(CONFIG)/inc/testAppweb.h
	cp -r test/testAppweb.h $(CONFIG)/inc/testAppweb.h

$(CONFIG)/obj/testAppweb.obj: \
        test/testAppweb.c \
        $(CONFIG)/inc/bit.h
	"$(CC)" -c -Fo$(CONFIG)/obj/testAppweb.obj -Fd$(CONFIG)/obj/testAppweb.pdb $(CFLAGS) $(DFLAGS) -I$(CONFIG)/inc test/testAppweb.c

$(CONFIG)/obj/testHttp.obj: \
        test/testHttp.c \
        $(CONFIG)/inc/bit.h
	"$(CC)" -c -Fo$(CONFIG)/obj/testHttp.obj -Fd$(CONFIG)/obj/testHttp.pdb $(CFLAGS) $(DFLAGS) -I$(CONFIG)/inc test/testHttp.c

$(CONFIG)/bin/testAppweb.exe:  \
        $(CONFIG)/bin/libappweb.dll \
        $(CONFIG)/inc/testAppweb.h \
        $(CONFIG)/obj/testAppweb.obj \
        $(CONFIG)/obj/testHttp.obj
	"$(LD)" -out:$(CONFIG)/bin/testAppweb.exe -entry:mainCRTStartup -subsystem:console $(LDFLAGS) $(LIBPATHS) $(CONFIG)/obj/testAppweb.obj $(CONFIG)/obj/testHttp.obj $(LIBS) libappweb.lib libhttp.lib libmpr.lib libpcre.lib libmprssl.lib

test/cgi-bin/testScript: 
	cd test >/dev/null ;\
		echo '#!../$(CONFIG)/bin/cgiProgram.exe' >cgi-bin/testScript ; chmod +x cgi-bin/testScript ;\
		cd - >/dev/null 

test/web/caching/cache.cgi: 
	cd test >/dev/null ;\
		echo -e '#!`type -p sh`' >web/caching/cache.cgi ;\
	echo -e '' >>web/caching/cache.cgi ;\
	echo -e 'echo HTTP/1.0 200 OK' >>web/caching/cache.cgi ;\
	echo -e 'echo Content-Type: text/plain' >>web/caching/cache.cgi ;\
	echo -e 'date' >>web/caching/cache.cgi ;\
	chmod +x web/caching/cache.cgi ;\
		cd - >/dev/null 

test/web/basic/basic.cgi: 
	cd test >/dev/null ;\
		echo -e '#!`type -p sh`' >web/basic/basic.cgi ;\
	echo -e '' >>web/basic/basic.cgi ;\
	echo -e 'echo Content-Type: text/plain' >>web/basic/basic.cgi ;\
	echo -e '/usr/bin/env' >>web/basic/basic.cgi ;\
	chmod +x web/basic/basic.cgi ;\
		cd - >/dev/null 

test/cgi-bin/cgiProgram.exe: 
	cd test >/dev/null ;\
		cp ../$(CONFIG)/bin/cgiProgram cgi-bin/cgiProgram.exe ;\
	cp ../$(CONFIG)/bin/cgiProgram cgi-bin/nph-cgiProgram.exe ;\
	cp ../$(CONFIG)/bin/cgiProgram 'cgi-bin/cgi Program.exe' ;\
	cp ../$(CONFIG)/bin/cgiProgram web/cgiProgram.cgi ;\
	chmod +x cgi-bin/* web/cgiProgram.cgi ;\
		cd - >/dev/null 

$(CONFIG)/obj/removeFiles.obj: \
        package/WIN/removeFiles.c \
        $(CONFIG)/inc/bit.h
	"$(CC)" -c -Fo$(CONFIG)/obj/removeFiles.obj -Fd$(CONFIG)/obj/removeFiles.pdb $(CFLAGS) $(DFLAGS) -I$(CONFIG)/inc package/WIN/removeFiles.c

$(CONFIG)/bin/removeFiles.exe:  \
        $(CONFIG)/bin/libmpr.dll \
        $(CONFIG)/obj/removeFiles.obj
	"$(LD)" -out:$(CONFIG)/bin/removeFiles.exe -entry:WinMainCRTStartup -subsystem:Windows $(LDFLAGS) $(LIBPATHS) $(CONFIG)/obj/removeFiles.obj $(LIBS) libmpr.lib
