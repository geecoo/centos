# General configure
<VirtualHost *:80>
    ServerAdmin jackjie009@gmail.com
    ServerName sf.dev 
    DocumentRoot "/data/www/symfony/web"
    ErrorLog "/data/logs/sf.dev-error.log"
    CustomLog "/data/logs/sf.dev-access.log" common
    <Directory "/data/www/symfony/web" >
#       Options Indexes FollowSymLinks 
        AllowOverride All 
        Require all granted
    </Directory>
    <Location /status>
        SetHandler server-status
        Require all granted
    </Location>
    #ProxyRequests Off
    #ProxyPassMatch ^/(.*.php)$ fcgi://127.0.0.1:9000/data/www/sys2.daoxila.dev/$1
</VirtualHost>


# ssl
<VirtualHost *:443>
    SSLEngine On
    SSLOptions +StrictRequire
    SSLCertificateFile /data/www/SSL/server.crt
    SSLCertificateKeyFile /data/www/SSL/server.key
    DocumentRoot "/data/www/app/public"
    ServerName api.com
    ServerAlias api.dev
    CustomLog "/data/logs/api.com-access.log" common
    ErrorLog "/data/logs/api.com-error.log"
    LogLevel notice

    <Directory "/data/www/app/public">
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>

