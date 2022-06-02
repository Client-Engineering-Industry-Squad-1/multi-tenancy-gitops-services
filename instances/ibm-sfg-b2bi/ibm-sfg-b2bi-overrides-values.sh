#!/usr/bin/env bash
# Set enviroment variables
# Declaring IBM SFG PROD

SFG_REPO=${SFG_REPO:-"cp.icr.io/cp/ibm-sfg/sfg"}
SFG_TAG=${SFG_TAG:-"6.1.0.0"}
SFG_PULLSECRECT=${SFG_PULLSECRECT:-"ibm-entitlement-key"}
APP_RESOURCES_PVC_ENABLED=${APP_RESOURCES_PVC_ENABLED:-"true"}
APP_DOCUMENTS_PVC_ENABLED=${APP_DOCUMENTS_PVC_ENABLED:-"true"}
DATASETUP_ENABLED=${DATASETUP_ENABLED:-"true"}
DBVENDOR=${DBVENDOR:-"mssql"} 
DBDRIVERS=${DBDRIVERS:-"mssql-jdbc-10.2.1.jre8.jar"} 
DBHOST=${DBHOST:-"pepsi-b2bi-poc-sql1.database.windows.net"}
DBPORT=${DBPORT:-"1433"}
DBDATA=${DBDATA:-"B2BIDB"}
DBCREATESCHEMA=${DBCREATESCHEMA:-"true"}
JMSHOST=$(oc get svc ibm-queuemanager-instance-ibm-mq -n tools -o jsonpath='{ .spec.clusterIP}')
JMSPORT=$(oc get svc ibm-queuemanager-instance-ibm-mq -n tools -o jsonpath='{ .spec.ports[1].port}')
JMSCONNECTIONNAMELIST="$JMSHOST($JMSPORT)"
JSMCHANNEL=${JSMCHANNEL:-"DEV.APP.SVRCONN"}
INGRESS_INTERNAL_HOST_ASI="asi."$(oc get ingress.config.openshift.io cluster -o jsonpath='{ .spec.domain }')
INGRESS_INTERNAL_HOST_AC="ac."$(oc get ingress.config.openshift.io cluster -o jsonpath='{ .spec.domain }')
INGRESS_INTERNAL_HOST_API="api."$(oc get ingress.config.openshift.io cluster -o jsonpath='{ .spec.domain }')
PURGE_IMG_REPO=${PURGE_IMG_REPO:-"cp.icr.io/cp/ibm-sfg/sfg-purge"}
PURGE_IMG_TAG=${PURGE_IMG_TAG:-"6.1.0.0"}
PURGE_PULLSECRET=${PURGE_PULLSECRET:-"ibm-entitlement-key"}

# Create Kubernetes yaml
( echo "cat <<EOF" ; cat ibm-sfg-b2bi-overrides-values.yaml_template ;) | \
SFG_REPO=${SFG_REPO} \
SFG_TAG=${SFG_TAG} \
SFG_PULLSECRECT=${SFG_PULLSECRECT} \
APP_RESOURCES_PVC_ENABLED=${APP_RESOURCES_PVC_ENABLED} \
APP_DOCUMENTS_PVC_ENABLED=${APP_DOCUMENTS_PVC_ENABLED} \
DATASETUP_ENABLED=${DATASETUP_ENABLED} \
DBHOST=${DBHOST} \
DBPORT=${DBPORT} \
DBDATA=${DBDATA} \
DBVENDOR=${DBVENDOR} \
DBDRIVERS=${DBDRIVERS} \
DBCREATESCHEMA=${DBCREATESCHEMA} \
JMSHOST=${JMSHOST} \
JMSPORT=${JMSPORT} \
JMSCONNECTIONNAMELIST=${JMSCONNECTIONNAMELIST} \
JSMCHANNEL=${JSMCHANNEL} \
INGRESS_INTERNAL_HOST_ASI=${INGRESS_INTERNAL_HOST_ASI} \
INGRESS_INTERNAL_HOST_AC=${INGRESS_INTERNAL_HOST_AC} \
INGRESS_INTERNAL_HOST_API=${INGRESS_INTERNAL_HOST_API} \
PURGE_IMG_REPO=${PURGE_IMG_REPO} \
PURGE_IMG_TAG=${PURGE_IMG_TAG} \
PURGE_PULLSECRET=${PURGE_PULLSECRET} \
sh > values.yaml
