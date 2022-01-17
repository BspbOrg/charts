{{ include "smartbirds-server.cronjob.enqueue" (dict "name" "organizations" "taskName" "organizations:export" "values" .Values.cron.organizations "ctx" $) }}
