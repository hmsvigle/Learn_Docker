TYPE=$1
BLUEPRINT=$2
source ./.env

curl --user admin:admin -H 'X-Requested-By:admin' -X POST $AMBARI_HOST/api/v1/blueprints/$TYPE --data-binary "@$BLUEPRINT"
curl --user admin:admin -H 'X-Requested-By:admin' -X PUT $AMBARI_HOST/api/v1/stacks/HDP/versions/$HDP_VERSION/operating_system/$OS/repositories/HDP-${HDP_VERSION} -d '{"Repositories":{"repo_name":"HDP-3.0.1.0", "base_url":"'$BASE_URL'", "verify_base_url":true}}'
curl --user admin:admin -H 'X-Requested-By:admin' -X POST $AMBARI_HOST/api/v1/clusters/dev --data-binary "@examples/hostgroups/$TYPE.json"
