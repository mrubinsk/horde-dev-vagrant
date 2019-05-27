#!/usr/bin/env bash
echo "Installing nginx"

if [ ! -e /etc/vagrant/nginx ]
then
    add-apt-repository ppa:ondrej/nginx-mainline
    apt-get update
    apt-get -y install nginx

    echo "Configuring nginx host files"
        cat >> /etc/nginx/sites-available/horde <<EOF
        server {

           listen 80;
           listen [::]:80;

            # Server domain or IP
            server_name $HORDE_HOSTNAME;

            # Root and index files
            root $WEBROOT/html;

	        index index.html index.htm index.nginx-debian.html index.php

            fastcgi_read_timeout 3660;

            client_max_body_size 0;

            location / {

            try_files   \$uri \$uri/ /horde/rampage.php?\$args;

                # Configure PHP FPM
                location ~* \.php$ {
                    fastcgi_pass unix:/run/php/$PHPVERSIONSTRING.sock;
                    include snippets/fastcgi-php.conf;
                    fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
                    include /etc/nginx/fastcgi_params;
                    fastcgi_read_timeout 3660;
                }

                location ^~ /horde/static/ {
                    expires                     4w;
                    add_header                  Cache-Control public;
                }

                location ^~ /horde/themes/ {
                    expires                     4w;
                    add_header                  Cache-Control public;
                }

                # AJAX services
                location ^~ /horde/services/ajax.php {
                    fastcgi_split_path_info     ^(.+\.php)(/.+)\$;
                    fastcgi_pass                unix:/run/php/$PHPVERSIONSTRING.sock;
                    include                     snippets/fastcgi-php.conf;
                    fastcgi_param               SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
                }

                # ActiveSync configuration
                location /Microsoft-Server-ActiveSync {
                    alias                       $HOREDIR/rpc.php;
                    fastcgi_split_path_info     ^(.+\.php)(/.+)\$;
                    fastcgi_pass                unix:/var/run/php/$PHPVERSIONSTRING.sock;
                    include                     /etc/nginx/fastcgi.conf;
                    fastcgi_intercept_errors    on;
                    client_max_body_size        20m;
                    client_body_buffer_size     128k;
                }

                location /autodiscover/autodiscover.xml {
                    alias                       $HORDEDIR/rpc.php;
                    fastcgi_split_path_info     ^(.+\.php)(/.+)\$;
                    fastcgi_pass                unix:/var/run/php/$PHPVERSIONSTRING.sock;
                    include                     /etc/nginx/fastcgi.conf;
                }

                location /Autodiscover/Autodiscover.xml {
                    alias                       $HORDEDIR/rpc.php;
                    fastcgi_split_path_info     ^(.+\.php)(/.+)\$;
                    fastcgi_pass                unix:/var/run/php/$PHPVERSIONSTRING.sock;
                    include                     /etc/nginx/fastcgi.conf;
                }

                # CALDAV
                location /.well-known/caldav {
                    alias                       $HORDEDIR/rpc.php;
                    fastcgi_split_path_info         ^(.+\.php)(/.+)\$;
                    fastcgi_pass                unix:/var/run/php/$PHPVERSIONSTRING.sock;
                    include                     /etc/nginx/fastcgi.conf;
                }

                location /.well-known/carddav {
                    alias                       $HORDEDIR/rpc.php;
                    fastcgi_split_path_info     ^(.+\.php)(/.+)\$;
                    fastcgi_pass                unix:/var/run/php/$PHPVERSIONSTRING.sock;
                    include                     /etc/nginx/fastcgi.conf;
                }

                # Ansel TODO
                # location /ansel-images/ {
                #     alias /var/vfs/.horde/ansel/;
                # }

                location /horde/ansel/ {
                    rewrite ^/horde/ansel/user/?(?:\?(.*))?\$ /horde/ansel/group.php?groupby=owner&\$1 last;
                    rewrite ^/horde/ansel/category/?(?:\?(.*))?\$ /horde/ansel/group.php?groupby=category&\$1 last;
                    rewrite ^/horde/ansel/all/?(?:\?(.*))?\$ /horde/ansel/view.php?view=List&groupby=none&\$1 last;

                    rewrite ^/horde/ansel/user/([@a-zA-Z0-9%_+.!*',()~-]*)/rss/? /horde/ansel/rss.php?stream_type=user&id=\$1 last;
                    rewrite ^/horde/ansel/user/([@a-zA-Z0-9%_+.!*',()~-]*)/?(?:\?(.*))?\$ /horde/ansel/view.php?view=List&groupby=owner&owner=\$1&\$2 last;
                    rewrite ^/horde/ansel/category/([@a-zA-Z0-9%_+.!*',()~-]*)/?(?:\?(.*))?\$ /horde/ansel/view.php?view=List&groupby=category&category=\$1&\$2 last;

                    rewrite ^/horde/ansel/gallery/id/([0-9]+)/([0-9]+)/?(?:\?(.*))?\$  /horde/ansel/view.php?view=Image&gallery=\$1&image=\$2&\$3 last;
                    rewrite ^/horde/ansel/gallery/id/([0-9]+)/rss/?\$  /horde/ansel/rss.php?stream_type=gallery&id=\$1 last;
                    rewrite ^/horde/ansel/gallery/id/([0-9]+)/\$ /horde/ansel/view.php?view=Gallery&gallery=\$1 last;
                    rewrite ^/horde/ansel/gallery/id/([0-9]+)/?(?:\?(.*))?\$ /horde/ansel/view.php?view=Gallery&gallery=\$1&\$2 last;

                    rewrite ^/horde/ansel/gallery/([a-zA-Z0-9_@]+)/([0-9]+)/?(?:\?(.*))?\$ /horde/ansel/view.php?view=Image&slug=\$1&image=\$2;
                    rewrite ^/horde/ansel/gallery/([a-zA-Z0-9_@]+)/rss/?\$ /horde/ansel/rss.php?stream_type=gallery&slug=\$1;
                    rewrite ^/horde/ansel/gallery/([a-zA-Z0-9_@]+)/?(?:\?(.*))?\$ /horde/ansel/view.php?view=Gallery&slug=\$1&\$2;

                    rewrite ^/horde/ansel/tag/?(?:\?(.*))?\$ /horde/ansel/view.php?view=Results&\$1 last;
                    rewrite ^/horde/ansel/tag/([a-zA-Z0-9%_+.!*',()~-]*)/rss/?\$ /horde/ansel/rss.php?stream_type=tag&id=\$1 last;
                    rewrite ^/horde/ansel/tag/([a-zA-Z0-9%_+.!*',()~-]*)/?(?:\?(.*))?\$ /horde/ansel/view.php?view=Results&tag=\$1&\$2 last;
               }
            }

            # Debugging
            access_log /var/log/nginx/localhost_access.log;
            error_log /var/log/nginx/localhost_error.log;
            rewrite_log on;
        }
EOF

    ln -s /etc/nginx/sites-available/horde /etc/nginx/sites-enabled/
    service nginx restart
    service $PHPVERSIONSTRING restart
    mkdir /etc/vagrant
    touch /etc/vagrant/nginx

else
    echo ">>> nginx already setup..."
fi

