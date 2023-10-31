#!/bin/bash

admin_portal=$1
account_id=$2
access_token=$3

display_usage(){
	echo -e "Usage:\n$0 <https://ADMIN_PORTAL_URL> <ACCOUNT_ID> <ACCESS_TOKEN>"
}

if [  $# -le 2 ]
then
	display_usage
	exit 1
fi

declare -a application_ids

# DELETE APPLICATIONS
function delete_applications {
	for id in ${application_ids[@]}; do
		curl -sk -X DELETE "$admin_portal/admin/api/accounts/$account_id/applications/$id.json?access_token=$access_token"
		sleep 1 
		echo -e "application $id belonging to account $account_id has been deleted"
	done
}

# GET APPLICATIONS AND FILTER BY ACCOUNT
url="$admin_portal/admin/api/applications.json"
echo "using url: $url"
for ((i=1;;i+=1)); do
	resp=$(curl -sk -X GET "$url?access_token=$access_token&page=$i&per_page=50" | jq --arg account_id ${account_id} -r '.applications[] | select(.application.account_id =='"$account_id"') | .application.id | @sh')
	echo "response: $resp"
	if [ ! -z "$resp" ] 
	then
		application_ids+=(${resp})
	else
		break;
	fi
done
echo "these are the application IDs: ${application_ids[@]} belonging to account $account_id"

# GET ACCOUNT AND PROMPT USER FOR CONFIRMATION
url="$admin_portal/admin/api/accounts/$account_id.json"
echo "using url: $url"
org_name=$(curl -X GET "$url?access_token=$access_token" | jq -r '.account.org_name | @sh')

echo "Do you wish to delete the applications retrieved for account $account_id with Org Name: ${org_name}? (select option 1 or 2)"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) delete_applications; break;;
        No ) exit;;
    esac
done
