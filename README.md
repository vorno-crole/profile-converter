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
    uniq $file $file
done

profile-convert.sh 2xml --all
```
