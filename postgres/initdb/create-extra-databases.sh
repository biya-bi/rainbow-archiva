#!/bin/bash

set -eu

process_sql() {
	local query_runner=( psql -v ON_ERROR_STOP=1 --username "${POSTGRES_USER}" --no-password --no-psqlrc )
	if [ -n "${POSTGRES_DB}" ]; then
		query_runner+=( --dbname "${POSTGRES_DB}" )
	fi

	PGHOST= PGHOSTADDR= "${query_runner[@]}" "$@"
}

create_database() {
	local database=$1
	local dbAlreadyExists
	dbAlreadyExists="$(
		POSTGRES_DB= process_sql --dbname postgres --set db="${database}" --tuples-only <<-'EOSQL'
			SELECT 1 FROM pg_database WHERE datname = :'db' ;
		EOSQL
	)"
	if [ -z "$dbAlreadyExists" ]; then
		POSTGRES_DB= process_sql --dbname postgres --set db="${database}" <<-'EOSQL'
			CREATE DATABASE :"db" ;
		EOSQL
		printf '\n'
	fi
}

get_databases() {
	local databases_file=`echo "${1:-}" | xargs`
	if [ -n "${databases_file}" ]; then
		if [ -f "${databases_file}" ]; then
			# Read the first non-empty line
			local databases=`grep -m 1 . ${databases_file}`
			echo "${databases}" | xargs
		elif [ -d "${databases_file}" ]; then
			echo "${databases_file} is a directory. A file must be provided!"
			exit 1
		else
			echo "The ${databases_file} file does not exist!"
			exit 1
		fi
	fi
}

create_databases() {
	local databases=`get_databases ${1:-}`
	if [ -n "${databases}" ]; then
		for database in $(echo ${databases}| tr ',' ' '); do
			create_database ${database}
		done
	fi
}

create_databases "${POSTGRES_EXTRA_DBS_FILE:-}"