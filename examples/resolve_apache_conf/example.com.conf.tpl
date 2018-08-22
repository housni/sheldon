# Ensure that Apache listens on port 80
Listen {{ port }}
<VirtualHost *:{{ port }}>
    DocumentRoot "/var/www/{{ document_root }}"
    ServerName {{ server_name }}

    # Other directives here
</VirtualHost>