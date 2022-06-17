if [ $# == 0 ]; then
  echo "Expected 1 argument: the company name"
  exit
fi
COMPANY_NAME=$1
. $COMPANY_NAME/tmp/config-context.sh

helm show values pharmaledger-imi/quorum-node > $qnValuesPath
echo "deployment:" >>  $COMPANY_NAME/tmp/deployment.yaml
echo "company: \"$COMPANY_NAME\"" >>  $COMPANY_NAME/tmp/deployment.yaml
sed -i 's/\(company\)/\  \1/' $COMPANY_NAME/tmp/deployment.yaml
echo "network_name: \"$NETWORK_NAME\"" >>  $COMPANY_NAME/tmp/deployment.yaml
sed -i 's/\(network_name\)/\  \1/' $COMPANY_NAME/tmp/deployment.yaml

helm pl-plugin --updatePartnersInfo -i $qnValuesPath $ghInfoPath $newNetworkService $qnInfoPath $updatePartnersInfo $COMPANY_NAME/tmp/deployment.yaml -o $COMPANY_NAME/tmp

#if test -f $COMPANY_NAME/tmp/join; then
#  echo "Join network ---------------------"
#  helm pl-plugin --updatePartnersInfo -i $qnValuesPath $joinNetworkInfo $ghInfoPath $qnInfoPath $COMPANY_NAME/tmp/deployment.yaml $updatePartnersInfo -o $COMPANY_NAME/tmp
#  helm upgrade --install qn-0 pharmaledger-imi/quorum-node -f $qnValuesPath -f $ghInfoPath -f $qnInfoPath -f $joinNetworkInfo -f $COMPANY_NAME/tmp/deployment.yaml -f $updatePartnersInfo --set-file use_case.joinNetwork.plugin_data_common=$COMPANY_NAME/tmp/join-network.plugin.json,use_case.joinNetwork.plugin_data_secrets=$COMPANY_NAME/tmp/join-network.plugin.secrets.json,use_case.updatePartnersInfo.plugin_data_common=$COMPANY_NAME/tmp/update-partners-info.plugin.json
#  rm -f join
#  rm -rf $COMPANY_NAME/tmp
#else
#  echo "new network ------------------"
#  helm pl-plugin --updatePartnersInfo -i $qnValuesPath $ghInfoPath $newNetworkService $qnInfoPath $updatePartnersInfo $COMPANY_NAME/tmp/deployment.yaml -o $COMPANY_NAME/tmp
#  helm upgrade --install qn-0 pharmaledger-imi/quorum-node -f $qnValuesPath -f $ghInfoPath -f $qnInfoPath -f $newNetworkService -f $COMPANY_NAME/tmp/deployment.yaml -f $updatePartnersInfo --set-file use_case.newNetwork.plugin_data_common=$COMPANY_NAME/tmp/new-network.plugin.json,use_case.newNetwork.plugin_data_secrets=$COMPANY_NAME/tmp/new-network.plugin.secrets.json,use_case.updatePartnersInfo.plugin_data_common=$COMPANY_NAME/tmp/update-partners-info.plugin.json
#  rm -rf $COMPANY_NAME/tmp
#fi