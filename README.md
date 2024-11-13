# SFDC Profile XML converter and validator
by vc@vaughancrole.com

### Try it out
 
All from your SFDC folder


#### Remove duplicates:

* Convert to CSV
* Run uniq on each file
* Convert back to XML

```
profile-convert.sh 2csv --all

for file in force-app/main/default/profileCSVs/*.csv; do
    echo $file; 
    sort -u -o "$file" "$file"
done

profile-convert.sh 2xml --all
```


```
SF_PROFILE="force-app/main/default/profiles/Admin.profile-meta.xml"

profile-converter 2csv -i "${SF_PROFILE}" -o "${SF_PROFILE}.csv"
sort -u -o "${SF_PROFILE}.csv" "${SF_PROFILE}.csv"

profile-converter 2xml -i "${SF_PROFILE}.csv" -o "${SF_PROFILE}"

rm "${SF_PROFILE}.csv"

```

```
SF_PROFILE="force-app/main/default/profiles/Admin.profile-meta.xml"
FILE="$(basename $SF_PROFILE)"
SRC_BR="uat"
DEST_BR="staging"

mkdir -p .vc-compare/${SRC_BR}
mkdir -p .vc-compare/${DEST_BR}

git show ${SRC_BR}:${SF_PROFILE} > ".vc-compare/${SRC_BR}/${FILE}"
git show ${DEST_BR}:${SF_PROFILE} > ".vc-compare/${DEST_BR}/${FILE}"

profile-convert 2csv -i ".vc-compare/${SRC_BR}/${FILE}" -o ".vc-compare/${SRC_BR}/${FILE}.csv"
profile-convert 2csv -i ".vc-compare/${DEST_BR}/${FILE}" -o ".vc-compare/${DEST_BR}/${FILE}.csv"

# sort files
sort -u -o ".vc-compare/${SRC_BR}/${FILE}.csv" ".vc-compare/${SRC_BR}/${FILE}.csv"
sort -u -o ".vc-compare/${DEST_BR}/${FILE}.csv" ".vc-compare/${DEST_BR}/${FILE}.csv"

code --diff ".vc-compare/${SRC_BR}/${FILE}.csv" ".vc-compare/${DEST_BR}/${FILE}.csv"

# and then...
# profile-convert 2xml -i ".vc-compare/${DEST_BR}/${FILE}.csv" -o "${SF_PROFILE}"
# rm -rf .vc-compare


```
