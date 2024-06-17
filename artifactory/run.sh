#!/bin/bash

set -eu

process_template() {
    allow_non_postgre_sql_placeholder="{ALLOW_NON_POSTGRE_SQL}"
    database_type_placeholder="{DATABASE_TYPE}"
    database_driver_placeholder="{DATABASE_DRIVER}"
    database_url_placeholder="{DATABASE_URL}"
    database_username_placeholder="{DATABASE_USERNAME}"
    database_password_placeholder="{DATABASE_PASSWORD}"

    input_file=$1
    output_file=$2

    allow_non_postgre_sql=$3
    database_type=$4
    database_driver=$5
    database_url=$6
    database_username=$7
    database_password=$8

    sed -e s/${allow_non_postgre_sql_placeholder}/${allow_non_postgre_sql}/g \
        -e s/${database_type_placeholder}/${database_type}/g \
        -e s/${database_driver_placeholder}/${database_driver}/g \
        -e s/${database_url_placeholder}/${database_url}/g \
        -e s/${database_username_placeholder}/${database_username}/g \
        -e s/${database_password_placeholder}/${database_password}/g \
        ${input_file} > ${output_file}

}

to_boolean() {
    value=$1
    if [  -z ${value} ]; then
        value=false
    else
        # Convert to lowercase and trim
        value=`echo ${value} | tr '[:upper:]' '[:lower:]'` | xargs
        if [ ${value} != "true" ]; then
            value=false
        fi
    fi
    echo ${value}
}

get_or_default() {
    value=$1
    default=$2
    if [  -z ${value} ]; then
        echo ${default}
    else
        echo $value
    fi
}

system_template_yaml=/opt/jfrog/artifactory/templates/system-template.yaml
system_yaml=/opt/jfrog/artifactory/var/etc/system.yaml

allow_non_postgre_sql=`to_boolean ${ALLOW_NON_POSTGRE_SQL:-}`
database_type=`get_or_default ${DATABASE_TYPE} postgresql`
database_driver=`get_or_default ${DATABASE_DRIVER} org.postgresql.Driver`

database_url=`cat ${DATABASE_URL_FILE}`
database_username=`cat ${DATABASE_USERNAME_FILE}`
database_password=`cat ${DATABASE_PASSWORD_FILE}`

process_template \
    ${system_template_yaml} \
    ${system_yaml} \
    ${allow_non_postgre_sql} \
    ${database_type} \
    ${database_driver} \
    ${database_url} \
    ${database_username} \
    ${database_password}

/entrypoint-artifactory.sh