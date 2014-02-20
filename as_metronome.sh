#!/usr/bin/env bash
set -e
set -x

lua_version=5.1.5
lua_name="luajit-"
luajit_version=2.0.2
luarocks_version=2.1.2
metronome_version=3.3
lua_major_rev=${lua_version:0:3}

# now for the libraries and whatnot
prefix="$HOME/.luaenv/versions/${lua_name}${luajit_version}"
lua_libdir="$prefix/lib/lua/${lua_major_rev}"
lua_shrdir="$prefix/share/lua/${lua_major_rev}"
lua_incdir="$prefix/include/luajit-2.0"

cd $HOME

# First, install luaenv + lua
\curl -R -L -O http://github.com/cehoffman/luaenv/archive/master.tar.gz
tar xf master.tar.gz
rm master.tar.gz
mv luaenv-master .luaenv

mkdir -p .luaenv/plugins && cd .luaenv/plugins

\curl -R -L -O http://github.com/cehoffman/lua-build/archive/master.tar.gz
tar xf master.tar.gz
rm master.tar.gz
mv lua-build-master lua-build

cd $HOME

echo 'export PATH="$HOME/.luaenv/shims:$HOME/.luaenv/bin:$PATH"' >> ~/.bash_profile
export PATH="$HOME/.luaenv/shims:$HOME/.luaenv/bin:$PATH"

hash -r

luaenv install luajit-${luajit_version}
luaenv global luajit-${luajit_version}
luaenv rehash

# Install luarocks
\curl -R -L -O http://luarocks.org/releases/luarocks-${luarocks_version}.tar.gz
tar xf luarocks-${luarocks_version}.tar.gz
rm luarocks-${luarocks_version}.tar.gz
cd luarocks-${luarocks_version}
./configure --prefix="${prefix}" --with-lua="${prefix}" --with-lua-include="${lua_incdir}"
make
make install

cd $HOME
rm -rf luarocks-${luarocks_version}

luaenv rehash

# luarocks doesn't look in /usr/lib64
echo 'external_deps_subdirs = { bin = "bin", lib = "lib64", include = "include" }' >> "${prefix}/etc/luarocks/config-5.1.lua"

luarocks install luafilesystem
luarocks install luasocket
luarocks install luaexpat
luarocks install lzlib
luarocks install luadbi
luarocks install luadbi-sqlite3
luarocks install luadbi-mysql MYSQL_INCDIR=/usr/include/mysql MYSQL_LIBDIR=/usr/lib64/mysql
luarocks install luadbi-postgresql

# Workaround for luasec
luarocks download luasec
luarocks unpack luasec*.rock
rm *.rock

cd luasec*
sed -e 's|src/|luasec/src/|g' -ibak *.rockspec
sed -e 's|samples|luasec/samples|g' -ibak *.rockspec
luarocks make
cd ..
rm -rf luasec*

# luaevent is not on luarocks
\curl -R -L -O http://github.com/harningt/luaevent/tarball/3ddb7c8e86a103126b63bd3e385285e0b0781e74
tar xf 3ddb7c8e86a103126b63bd3e385285e0b0781e74
rm 3ddb7c8e86a103126b63bd3e385285e0b0781e74

cd harningt-luaevent-3ddb7c8
LUA_INC_DIR=$lua_incdir INSTALL_DIR_LUA=$lua_shrdir INSTALL_DIR_BIN=$lua_libdir make
LUA_INC_DIR=$lua_incdir INSTALL_DIR_LUA=$lua_shrdir INSTALL_DIR_BIN=$lua_libdir make install
cd $HOME
rm -rf harningt-luaevent-3ddb7c8

# download + patch for shared libraries
#luasocket
#luaexapt
#luaevent
# lua-zlib
#luafilesystem
#luasec
#luadbi
# metronome
\curl -R -L -O http://github.com/maranda/metronome/archive/v${metronome_version}.tar.gz
tar xf v${metronome_version}.tar.gz
rm v${metronome_version}.tar.gz
cd metronome-${metronome_version}
./configure --prefix=${prefix} --datadir=/opt/metronome/var --with-lua=${prefix} --with-lua-include=${lua_incdir} --sysconfdir=/opt/metronome/etc
make
make install
cd $HOME
rm -rf metronome-${metronome_version}
# 
luaenv rehash
hash -r

# useful modules
# cd ${prefix}/lib/metronome/modules
# \curl -R -L -O http://prosody-modules.googlecode.com/hg/mod_auth_ldap/mod_auth_ldap.lua
# \curl -R -L -O http://prosody-modules.googlecode.com/hg/mod_auth_ldap2/mod_auth_ldap2.lua
# \curl -R -L -O http://prosody-modules.googlecode.com/hg/mod_lib_ldap/ldap.lib.lua
# \curl -R -L -O http://prosody-modules.googlecode.com/hg/mod_storage_ldap/mod_storage_ldap.lua
