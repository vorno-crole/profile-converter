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
