docker-metronome (luajit branch)
=============

This is a small [CentOS](http://www.centos.org/)-based image for [Docker](http://docker.io/), with [Metronome IM](http://www.lightwitch.org/metronome) (an XMPP/Jabber server) installed.

This branch uses LuaJIT instead of Lua, currently version 2.0.3.

This is based on CentOS 6.5 and has `metronome` as the entrypoint.

It comes with a very small `metronome.cfg.lua` file, but this is meant to
have your own configuration setup by using data volumes.

Neat things about this build:

* Metronome and its [Lua](http://www.lua.org/) dependencies installed to `/opt/metronome`
* `/opt/metronome/etc` and `/opt/metronome/var` are data volumes
* Metronome is run as a non-privileged user

This build uses the following Lua packages/programs/modules:

* [LuaEnv](http://github.com/cehoffman/luaenv)
* [LuaRocks](http://www.luarocks.org/)
* [LuaSocket](http://github.com/diegonehab/luasocket)
* [LuaExpat](http://matthewwild.co.uk/projects/luaexpat/)
* [LuaEvent](http://github.com/harningt/luaevent)
* [lua-zlib](http://github.com/brimworks/lua-zlib) 
* [luafilesystem](http://github.com/keplerproject/luafilesystem)
* [LuaSec](http://github.com/brunoos/luasec)
* [LuaDBI](http://code.google.com/p/luadbi/), with support for MySQL, PostgreSQL, and SQLite.

Additionally, this installs [LuaLDAP](http://github.com/jprjr/lualdap) though this
is not currently used by Metronome.
