#!/bin/bash

set -eu

process_template() {
    local allow_non_postgre_sql_placeholder="{ALLOW_NON_POSTGRE_SQL}"
    local database_type_placeholder="{DATABASE_TYPE}"
    local database_driver_placeholder="{DATABASE_DRIVER}"
    local database_url_placeholder="{DATABASE_URL}"
    local database_username_placeholder="{DATABASE_USERNAME}"
    local database_password_placeholder="{DATABASE_PASSWORD}"
    local system_template_yaml_file="/opt/jfrog/artifactory/templates/system-template.yaml"
    local system_yaml_file="/opt/jfrog/artifactory/var/etc/system.yaml"

    local allow_non_postgre_sql="${ALLOW_NON_POSTGRE_SQL:-false}"
    local database_type="${DATABASE_TYPE:-postgresql}"
    local database_driver="${DATABASE_DRIVER:-org.postgresql.Driver}"
    local database_url=`grep -m 1 . ${DATABASE_URL_FILE}`
    local database_username=`grep -m 1 . ${DATABASE_USERNAME_FILE}`
    local database_password=`grep -m 1 . ${DATABASE_PASSWORD_FILE}`

    sed -e s/${allow_non_postgre_sql_placeholder}/${allow_non_postgre_sql}/g \
        -e s/${database_type_placeholder}/${database_type}/g \
        -e s/${database_driver_placeholder}/${database_driver}/g \
        -e s/${database_url_placeholder}/${database_url}/g \
        -e s/${database_username_placeholder}/${database_username}/g \
        -e s/${database_password_placeholder}/${database_password}/g \
        ${system_template_yaml_file} > ${system_yaml_file}
}

process_template
/entrypoint-artifactory.sh