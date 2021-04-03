
# FusionPBX Settings
domain_name=fusionpbx.free-solutions.org	# hostname, ip_address or a custom value
system_username=admin           # default username admin
system_password=FS_OS2610	# random or a custom value
system_branch=master            # master, stable

# FreeSWITCH Settings
switch_branch=master 		# master, stable
switch_source=false             # true or false
switch_package=true             # true or false
switch_package_all=true         # Added all parameter
switch_version=1.10.6           # only for source
switch_tls=true                 # true or false

# Database Settings
database_password=FS_OS2610	# random or a custom value (safe characters A-Z, a-z, 0-9)
database_repo=official          # PostgreSQL official, system, 2ndquadrant
database_version=latest         # requires repo official
database_host=127.0.0.1         # hostname or IP address
database_port=5432              # port number
database_backup=true # true or false

# General Settings
php_version=7.3                 # PHP version 5.6 or 7.0, 7.1, 7.2
letsencrypt_folder=true         # true or false
