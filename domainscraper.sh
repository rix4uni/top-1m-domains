# Download

mkdir -p temp
### Alexa (Deprecated)
# http://web.archive.org/web/20230731120013/https://s3.amazonaws.com/alexa-static/top-1m.csv.zip
# unzip -q top-1m.csv.zip -d temp && mv temp/*.csv* alexa.csv && gzip alexa.csv && rm -rf top-1m.csv.zip

### Cisco Umbrella (Deprecated)
# https://web.archive.org/web/20250615164450/https://s3-us-west-1.amazonaws.com/umbrella-static/top-1m.csv.zip
# unzip -q top-1m.csv.zip -d temp && mv temp/*.csv* cisco.csv && gzip cisco.csv && rm -rf top-1m.csv.zip

### Majestic
wget -O majestic.csv -q https://downloads.majestic.com/majestic_million.csv
gzip majestic.csv

### BuiltWith
wget -O builtwith.zip -q https://builtwith.com/dl/builtwith-top1m.zip
unzip -q builtwith.zip -d temp && mv temp/*.csv* builtwith.csv && gzip builtwith.csv && rm -rf builtwith.zip

### Statvoo (Deprecated)
# https://web.archive.org/web/20230530104108/https://statvoo.com/dl/top-1million-sites.csv.zip
# unzip -q top-1million-sites.csv.zip -d temp && mv temp/*.csv* statvoo.csv && gzip statvoo.csv && rm -rf top-1million-sites.csv.zip

### DomCop
wget -O domcop.zip -q https://www.domcop.com/files/top/top10milliondomains.csv.zip
unzip -q domcop.zip -d temp && mv temp/*.csv* domcop.csv && gzip domcop.csv && rm -rf domcop.zip

### Tranco
id=$(curl -s -I "https://tranco-list.eu/latest_list" | grep -oP '(?<=location: /list/)\w+(?=/)')
final_url="https://tranco-list.eu/download/$id/full"
wget -O tranco.csv -q "$final_url"
gzip tranco.csv

### Cloudflare
# https://radar.cloudflare.com/charts/TopDomainsTable/attachment?id=2022&value=1000000
# mv temp/*.csv* cloudflare.csv && gzip cloudflare.csv

rm -rf temp


# Merge
zcat alexa.csv.gz | cut -d"," -f2 | unew -q alldomains.txt
zcat cisco.csv.gz | cut -d"," -f2 | unew -q alldomains.txt
zcat majestic.csv | sed -n '/^1,/,$p' | cut -d"," -f3,7 | tr "," "\n" | unew -q alldomains.txt
zcat builtwith.csv.gz | cut -d"," -f2 | unew -q alldomains.txt
zcat statvoo.csv.gz | sed -n '/^1,/,$p' | cut -d"," -f2 | unew -q alldomains.txt
zcat domcop.csv.gz | sed -n '/^"1",/,$p' | cut -d"," -f2 | tr -d '"' | unew -q alldomains.txt
zcat tranco.csv.gz | cut -d"," -f2 | unew -q alldomains.txt
zcat cloudflare.csv.gz | sed '1d' | cut -d"," -f2 | unew -q alldomains.txt

gzip alldomains.txt

# bash domainscraper.sh