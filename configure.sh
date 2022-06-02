RUBRIK_IP=''
RUBRIK_USER='admin'
RUBRIK_PASS=''
FILESET_NAME='epic'
FOLDER_PATH='/mnt/epic-iscsi-vol'
SLA_DOMAIN='Bronze'
WORKLOAD_IP=''

# get auth token
TOKEN="Bearer $(curl -k -s -u "$RUBRIK_USER:$RUBRIK_PASS" -X POST https://$RUBRIK_IP/api/v1/session | jq -r '.token')"


ADD_HOST=$(curl -k -s \
    --header "Authorization: $TOKEN" \
    --header 'Content-Type':'application/json' \
    --header 'Accept':'application/json' \
    -X POST https://$RUBRIK_IP/api/v1/host \
    -d "{\"hostname\":\"$WORKLOAD_IP\",\"hasAgent\":true}")
MY_HOST_ID=$(echo $ADD_HOST | jq -r '.id')
if [ $MY_HOST_ID == 'null' ]; then
    echo $(echo $ADD_HOST | jq -r '.message')
    echo "Something went wrong adding the host to the Rubrik system, exiting"
    exit 1
fi

# check that host exists
HOST_QUERY=$(curl -k -s --header "Authorization: $TOKEN" -X GET https://$RUBRIK_IP/api/v1/host?hostname=$WORKLOAD_IP)
if [ $(echo $HOST_QUERY | jq -r '.total') != '1' ]; then
    echo "Host $WORKLOAD_IP not found on Rubrik system, exiting"
    exit 1
fi

# check that fileset template exists
FILESET_TEMPLATES=$(curl -k -s --header "Authorization: $TOKEN" -X GET https://$RUBRIK_IP/api/v1/fileset_template)
MY_FILESET_TEMPLATE=$(echo $FILESET_TEMPLATES | jq -c ".data[] | select(.includes[]==\"$FOLDER_PATH\")" | jq -r '.id')
# create fileset template if it does not exist
if [ -z $MY_FILESET_TEMPLATE ]; then
    echo "Fileset Template not found, creating..."
    NEW_FILESET_TEMPLATE=$(curl -k -s \
        --header "Authorization: $TOKEN" \
        --header 'Content-Type':'application/json' \
        --header 'Accept':'application/json' \
        -X POST https://$RUBRIK_IP/api/v1/fileset_template \
        -d "{\"name\":\"$WORKLOAD_IP : $FOLDER_PATH\",\"includes\":[\"$FOLDER_PATH\"],\"operatingSystemType\":\"Linux\"}"
        )
    MY_FILESET_TEMPLATE=$(echo $NEW_FILESET_TEMPLATE | jq -r '.id')
else
    echo "Fileset Template found"
fi
# check that fileset exists
MY_FILESET=$(curl -k -s --header "Authorization: $TOKEN" -X GET \
    "https://$RUBRIK_IP/api/v1/fileset?host_id=$MY_HOST_ID&template_id=$MY_FILESET_TEMPLATE" | jq -r '.data[0].id')
if [ $MY_FILESET == 'null' ]; then
    echo "Fileset not found, creating..."
    NEW_FILESET=$(curl -k -s \
        --header "Authorization: $TOKEN" \
        --header 'Content-Type':'application/json' \
        --header 'Accept':'application/json' \
        -X POST https://$RUBRIK_IP/api/v1/fileset \
        -d "{\"hostId\": \"$MY_HOST_ID\",\"templateId\": \"$MY_FILESET_TEMPLATE\"}"
        )
    MY_FILESET=$(echo $NEW_FILESET | jq -r '.id')
else
    echo "Fileset found"
fi

SLA_DOMAINS=$(curl -k -s --header "Authorization: $TOKEN" -X GET https://$RUBRIK_IP/api/v1/sla_domain)
MY_SLA_DOMAIN=$(echo $SLA_DOMAINS | jq -c ".data[] | select(.name==\"$SLA_DOMAIN\")" | jq -r '.id')
if [ -z $MY_SLA_DOMAIN ]; then
    echo "SLA Domain $SLA_DOMAIN not found on Rubrik system, exiting"
    exit 1
fi

SNAPSHOT_REQ=$(curl -k -s \
    --header "Authorization: $TOKEN" -X POST \
    --header 'Content-Type: application/json' \
    --header 'Accept: application/json' \
    "https://$RUBRIK_IP/api/v1/fileset/$MY_FILESET/snapshot" \
    -d "{\"slaId\":\"$MY_SLA_DOMAIN\"}")
SNAPSHOT_URL=$(echo $SNAPSHOT_REQ | jq -r '.links[0].href')
SNAPSHOT_STATUS=$(echo $SNAPSHOT_REQ | jq -r '.status')
while [ $SNAPSHOT_STATUS != 'SUCCEEDED' ] && [ $SNAPSHOT_STATUS != 'FAILED' ]
do
    echo "Snapshot status is $SNAPSHOT_STATUS, sleeping..."
    sleep 5
    SNAPSHOT_STATUS=$(curl -k -s \
        --header "Authorization: $TOKEN" -X GET \
        $SNAPSHOT_URL | jq -r '.status')
done
echo "Snapshot done"
exit 0
