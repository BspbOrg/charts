{{ include "smartbirds-server.cronjob.enqueue" (dict "name" "locations" "taskName" "autoLocation" "values" .Values.cron.locations "ctx" $) }}
