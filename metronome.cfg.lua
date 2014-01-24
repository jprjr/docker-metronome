-- Basic metronome config file

modules_enabled = {
    "roster";
    "saslauth";
    "tls";
    "dialback";
    "disco";
    "private";
    "version";
    "uptime";
    "time";
    "ping";
    "posix";
};

daemonize = false;
allow_registration = false;

ssl = {
    key = "/opt/metronome/etc/certs/localhost.key";
    certificate = "/opt/metronome/etc/certs/localhost.cert";
}

VirtualHost "localhost"
