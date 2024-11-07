#!/bin/bash

SF_PROFILE="force-app/main/default/profiles/Admin.profile-meta.xml"

$(dirname "$BASH_SOURCE")/profile-convert.sh 2csv -i "${SF_PROFILE}" -o "${SF_PROFILE}.csv"
sort -o "${SF_PROFILE}.csv" "${SF_PROFILE}.csv"
uniq "${SF_PROFILE}.csv" > "${SF_PROFILE}.csv2"
mv "${SF_PROFILE}.csv2" "${SF_PROFILE}.csv"

$(dirname "$BASH_SOURCE")/profile-convert.sh 2xml -i "${SF_PROFILE}.csv" -o "${SF_PROFILE}"
rm "${SF_PROFILE}.csv"
