#!/usr/bin/env bash
set -e
set -x

lua_version=5.1.5
lua_major_rev=${lua_version:0:3}

# now for the libraries and whatnot
prefix=$HOME/.luaenv/versions/${lua_version}
lua_libdir=$prefix/lib/lua/${lua_major_rev}
lua_shrdir=$prefix/share/lua/${lua_major_rev}
lua_incdir=$prefix/include

cd $HOME

# First, install luaenv + lua
\curl -R -L -O http://github.com/cehoffman/luaenv/tarball/62c75ef09bfc521765c83e3c1c5cb7b06b999091
tar xf 62c75ef09bfc521765c83e3c1c5cb7b06b999091
rm 62c75ef09bfc521765c83e3c1c5cb7b06b999091
mv cehoffman-luaenv-62c75ef .luaenv

mkdir -p .luaenv/plugins && cd .luaenv/plugins

\curl -R -L -O http://github.com/cehoffman/lua-build/tarball/2a4f206a23e99708e813ec06131f1368129f4d3e
tar xf 2a4f206a23e99708e813ec06131f1368129f4d3e
rm 2a4f206a23e99708e813ec06131f1368129f4d3e
mv cehoffman-lua-build-2a4f206 lua-build

cd $HOME

echo 'export PATH="$HOME/.luaenv/shims:$HOME/.luaenv/bin:$PATH"' >> ~/.bash_profile
export PATH="$HOME/.luaenv/shims:$HOME/.luaenv/bin:$PATH"

hash -r

# download + patch for shared libraries
\curl -R -L -O https://gist.github.com/jprjr/8476378/raw/lua-${lua_version}-build
mv lua-${lua_version}-build ${lua_version}
luaenv install ./${lua_version}
rm ./${lua_version}
luaenv global ${lua_version}
luaenv rehash

#lualdap
\curl -R -L -O http://github.com/jprjr/lualdap/tarball/8c3b33c0eee9c7265f7fcbf4319a3f174fcecfc9
tar xf 8c3b33c0eee9c7265f7fcbf4319a3f174fcecfc9
rm 8c3b33c0eee9c7265f7fcbf4319a3f174fcecfc9

cd jprjr-lualdap-8c3b33c

sed -i '/^LUA_LIBDIR/d' config
sed -i '/^LUA_INC/d' config
sed -i '/^OPENLDAP_INC/d' config
echo "LUA_LIBDIR=$lua_libdir" >> config
echo "LUA_INC=$lua_incdir" >> config
echo "OPENLDAP_INC=/usr/include" >> config
make
make install
cd $HOME
rm -rf jprjr-lualdap-8c3b33c

#luasocket
\curl -R -L -O http://github.com/diegonehab/luasocket/tarball/6d5e40c324c84d9c1453ae88e0ad5bdd0a631448
tar xf 6d5e40c324c84d9c1453ae88e0ad5bdd0a631448
rm 6d5e40c324c84d9c1453ae88e0ad5bdd0a631448

cd diegonehab-luasocket-6d5e40c
prefix=${prefix} LUAV=${lua_major_rev} LUAINC_linux=$lua_incdir LUALIB_linux=$lua_libdir make
prefix=${prefix} LUAV=${lua_major_rev} LUAINC_linux=$lua_incdir LUALIB_linux=$lua_libdir make install
cd $HOME
rm -rf diegonehab-luasocket-6d5e40c

#luaexapt
\curl -R -L -O http://code.matthewwild.co.uk/lua-expat/archive/1f41c74ce686.tar.gz
tar xf 1f41c74ce686.tar.gz
rm 1f41c74ce686.tar.gz
cd lua-expat-1f41c74ce686
LUA_V=${lua_major_rev} LUA_LDIR=${lua_shrdir} LUA_CDIR=${lua_libdir} LUA_INC=-I${lua_incdir} make
LUA_V=${lua_major_rev} LUA_LDIR=${lua_shrdir} LUA_CDIR=${lua_libdir} LUA_INC=-I${lua_incdir} make install
cd $HOME
rm -rf lua-expat-1f41c74ce686

#luaevent
\curl -R -L -O http://github.com/harningt/luaevent/tarball/3ddb7c8e86a103126b63bd3e385285e0b0781e74
tar xf 3ddb7c8e86a103126b63bd3e385285e0b0781e74
rm 3ddb7c8e86a103126b63bd3e385285e0b0781e74

cd harningt-luaevent-3ddb7c8
LUA_INC_DIR=$lua_incdir INSTALL_DIR_LUA=$lua_shrdir INSTALL_DIR_BIN=$lua_libdir make
LUA_INC_DIR=$lua_incdir INSTALL_DIR_LUA=$lua_shrdir INSTALL_DIR_BIN=$lua_libdir make install
cd $HOME
rm -rf harningt-luaevent-3ddb7c8

# lua-zlib
\curl -R -L -O http://github.com/jprjr/lua-zlib/tarball/c43166a8ef1c06a1c25ac14636bbd86f06391a9d
tar xf c43166a8ef1c06a1c25ac14636bbd86f06391a9d
rm c43166a8ef1c06a1c25ac14636bbd86f06391a9d

cd jprjr-lua-zlib-c43166a
LUAPATH=$lua_shrdir LUACPATH=$lua_libdir INCDIR="-I$lua_incdir -I/usr/include" LIBDIR="-L$prefix/lib -L/usr/lib64 -Wl,-rpath=${prefix}/lib" make linux
LUAPATH=$lua_shrdir LUACPATH=$lua_libdir INCDIR="-I$lua_incdir -I/usr/include" LIBDIR="-L$prefix/lib -L/usr/lib64 -Wl,-rpath=${prefix}/lib" make install
cd $HOME
rm -rf jprjr-lua-zlib-c43166a

#luafilesystem
\curl -R -L -O http://github.com/keplerproject/luafilesystem/tarball/5be0c7156e0d34e3379cb13e9d487a069ac07557
tar xf 5be0c7156e0d34e3379cb13e9d487a069ac07557
rm 5be0c7156e0d34e3379cb13e9d487a069ac07557

cd keplerproject-luafilesystem-5be0c71
sed -i '/^PREFIX/d' config
sed -i '/^LUA_LIBDIR/d' config
sed -i '/^LUA_INC/d' config
echo "PREFIX=$prefix" >> config
echo "LUA_LIBDIR=$lua_libdir" >> config
echo "LUA_INC=$lua_incdir" >> config
make
make install
cd $HOME
rm -rf keplerproject-luafilesystem-5be0c71

#luasec
\curl -R -L -O http://github.com/brunoos/luasec/tarball/46d6078e82c9084bfd0b0fd5474595a938bcf1ee
tar xf 46d6078e82c9084bfd0b0fd5474595a938bcf1ee
rm 46d6078e82c9084bfd0b0fd5474595a938bcf1ee

cd brunoos-luasec-46d6078
LUAPATH=$lua_shrdir LUACPATH=$lua_libdir INC_PATH="-I$lua_incdir -I/usr/include" LIB_PATH="-L$prefix/lib -L/usr/lib64" make linux
LUAPATH=$lua_shrdir LUACPATH=$lua_libdir INC_PATH="-I$lua_incdir -I/usr/include" LIB_PATH="-L$prefix/lib -L/usr/lib64" make install
cd $HOME
rm -rf brunoos-luasec-46d6078

#luadbi
mkdir luadbi
cd luadbi
\curl -R -L -O https://luadbi.googlecode.com/files/luadbi.0.5.tar.gz
tar xf luadbi.0.5.tar.gz
mv DBI.lua DBI.lua.orig
tail -n +3 DBI.lua.orig > DBI.lua
rm DBI.lua.orig

common_cflags="-g -pedantic -Wall -O2 -shared -fPIC -I${lua_incdir}"
postgres_cflags="-I$(pg_config --includedir) -I$(pg_config --includedir-server) -I ."
sqlite_cflags="$(pkg-config sqlite3 --cflags) -I ."
mysql_cflags="$(mysql_config --cflags) -I ."

postgres_ldflags="-lpq"
sqlite_ldflags="$(pkg-config sqlite3 --libs)"
mysql_ldflags="$(mysql_config --libs)"

make psql "CFLAGS=${common_cflags} ${postgres_cflags}" "PSQL_LDFLAGS=${postgres_ldflags}"
make sqlite3 "CFLAGS=${common_cflags} ${sqlite_cflags}" "SQLITE3_LDFLAGS=${sqlite_ldflags}"
make mysql "CFLAGS=${common_cflags} ${mysql_cflags}" "MYSQL_LDFLAGS=${mysql_ldflags}"

cp DBI.lua ${lua_libdir}/
cp dbdpostgresql.so ${lua_libdir}/
cp dbdsqlite3.so ${lua_libdir}/
cp dbdmysql.so ${lua_libdir}/

cd $HOME
rm -rf luadbi

# metronome
\curl -R -L -O http://github.com/maranda/metronome/archive/v3.3.tar.gz
tar xf v3.3.tar.gz
rm v3.3.tar.gz
cd metronome-3.3
./configure --prefix=${prefix} --datadir=/opt/metronome/var --with-lua=${prefix} --with-lua-include=${lua_incdir} --with-lua-lib=${lua_libdur} --sysconfdir=/opt/metronome/etc
make
make install
cd $HOME
rm -rf metronome-3.3

luaenv rehash
hash -r

# useful modules
# cd ${prefix}/lib/metronome/modules
# \curl -R -L -O http://prosody-modules.googlecode.com/hg/mod_auth_ldap/mod_auth_ldap.lua
# \curl -R -L -O http://prosody-modules.googlecode.com/hg/mod_auth_ldap2/mod_auth_ldap2.lua
# \curl -R -L -O http://prosody-modules.googlecode.com/hg/mod_lib_ldap/ldap.lib.lua
# \curl -R -L -O http://prosody-modules.googlecode.com/hg/mod_storage_ldap/mod_storage_ldap.lua
