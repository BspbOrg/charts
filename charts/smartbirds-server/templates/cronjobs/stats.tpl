{{ include "smartbirds-server.cronjob.enqueue" (dict "name" "stats" "taskName" "stats:generate" "values" .Values.cron.stats "ctx" $) }}
