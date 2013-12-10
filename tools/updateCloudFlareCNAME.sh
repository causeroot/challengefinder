#!/bin/bash
if [ -z "$1" ]; then
  cmd=$(basename $0)
  echo "Usage: $cmd NEW_NAME"
  echo ""
  echo "e.g. $cmd challengefinder-master-bktsxfhppm.elasticbeanstalk.com"
  exit 1
fi

export tkn=ec24987bd0349e9e68c275a8c2e011d7ec86c
export email=admin@causeroot.org

rec_id=$(curl -s https://www.cloudflare.com/api_json.html \
  -d 'a=rec_load_all' \
  -d "tkn=$tkn" \
  -d "email=$email" \
  -d 'z=challengefinder.org' | jq '.response.recs.objs[] | select(.display_name=="www").rec_id' | sed s/\"//g)

curl https://www.cloudflare.com/api_json.html \
  -d 'a=rec_edit' \
  -d "id=$rec_id" \
  -d "tkn=$tkn" \
  -d "email=$email" \
  -d 'z=challengefinder.org' \
  -d 'type=CNAME' \
  -d 'name=www' \
  -d "content=www.challengefinder.org" \
  -d 'service_mode=0' \
  -d 'ttl=1' | python -mjson.tool
