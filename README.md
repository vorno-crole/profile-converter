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
    uniq "$file" > "${file}2" && mv "${file}2" "$file"
done

profile-convert.sh 2xml --all
```


```
SF_PROFILE="force-app/main/default/profiles/Admin.profile-meta.xml"

profile-converter 2csv -i "${SF_PROFILE}" -o "${SF_PROFILE}.csv"
sort -o "${SF_PROFILE}.csv" "${SF_PROFILE}.csv"
uniq "${SF_PROFILE}.csv" > "${SF_PROFILE}.csv2"
mv "${SF_PROFILE}.csv2" "${SF_PROFILE}.csv"

profile-converter 2xml -i "${SF_PROFILE}.csv" -o "${SF_PROFILE}"

rm "${SF_PROFILE}.csv"

```
