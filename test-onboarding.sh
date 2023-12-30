#!/bin/bash

if [ "$#" -ne 3 ]; then
	echo "Please provide the first and last name..."
	echo "Don't forget to quote the position."
	exit 0
fi

FIRST_NAME=$1
LAST_NAME=$2
JOB=$3

wait_for_enter() {
	read -r -p "Press Enter to continue."
	echo ""
}

setup_laptop() {
	echo "Setting up laptop..."
	echo "Ansible running (one day...)"
	echo ""
	wait_for_enter
}

create_gsuite_account() {
	GURL="https://admin.google.com/"
	xdg-open $GURL 1>/dev/null
	echo "Full name is $FIRST_NAME $LAST_NAME"
	echo "Go to $GURL and create the account ${FIRST_NAME,,}@exads.com"
	echo "Add the job title $JOB"
	echo "Add it to the correct groups (If from Porto add Porto Office / If from Dublin add Dublin Office / other's example: EXADS Developers)"
	echo "Get the password for the WS."
	echo ""
	wait_for_enter
}

invite_to_slack() {
	SURL="https://exogroup.slack.com/admin"
	xdg-open $SURL 1>/dev/null
	echo "Go to $SURL and invite as member with the email created example@exads.com to the organization."
	echo "After it edit the profile and add on the Full Name option on Slack the first and last name, so people can see their name and not their user."
	echo ""
	wait_for_enter
}

invite_to_jira() {
	JURL="https://admin.atlassian.com/s/7984352c-e60f-43da-b43c-9aef34d9c06b/users"
	xdg-open $JURL 1>/dev/null
	echo "Go to $JURL and invite ${FIRST_NAME,,}@exads.com to the organization."
	echo "Invite to the EXADS and EXADS-PT if from Porto and EXADS-IE if from Dublin group."
	echo "Add the email adress and leave the role Basic"
	echo "On the Product access leave only marked Jira Software, Jira Service Management - Customer and Confluence, ask the manager if the user need's other product's access besides the 2 mentioned."
	echo "On Group membership add the respective group's that you have the information provide."
	wait_for_enter
}

invite_to_monday() {
	MURL="https://exogroup.monday.com/"
	xdg-open $MURL 1>/dev/null
	echo "Go to $MURL and invite ${FIRST_NAME,,}@exads.com to the organization as VIEWER."
	echo "Add to EXADS team."
	
	wait_for_enter
}

setup_vpn() {
	echo "TODO: Script to setup VPN"
	echo "Send exads-setup-vpn.sh to the user."
	wait_for_enter
}

setup_ssh() {
	echo "TODO: Setup SSH"
	wait_for_enter
}

setup_github() {
	echo "Ask the user for their GitHub username and email."
	wait_for_enter
}

generate_ws() {
	WSURL="https://docs.google.com/document/d/1wGBl8nLeCYHsbS-by2SFQ7HUvU7970ajXUp_MrwAA80/edit"
	xdg-open $WSURL 1>/dev/null
	echo "Go to $WSURL and edit the file and send to HR and CTO"
	wait_for_enter
}

setup_laptop
create_gsuite_account
invite_to_slack
invite_to_jira
invite_to_monday
setup_vpn
setup_ssh
setup_github
generate_ws
