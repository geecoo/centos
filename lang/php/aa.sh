#!/bin/zsh

sed -i \
    "s@^;date.timezone.*@date.timezone = Asia/Shanghai@; \
     s@^display_errors.*@display_errors = On@; \
     s@^display_startup_errors.*@display_startup_errors = On@; \
     s@^post_max_size.*@post_max_size = 64M@; \
     s@^max_execution_time.*@max_execution_time = 600@; \
     s@^max_input_vars.*@max_input_vars = 1000@; \
     s@^memory_limit.*@memory_limit = 512M@; \
     s@^error_reporting.*@error_reporting = E_ALL@; \
     s@^upload_max_filesize.*@upload_max_filesize = 20M@" \
     /etc/php.ini 
