{{ include "smartbirds-server.cronjob.enqueue" (dict "name" "visits" "taskName" "autoVisit" "values" .Values.cron.visits "ctx" $) }}
