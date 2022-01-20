{{ include "smartbirds-server.cronjob.enqueue" (dict "name" "bgatlas2008" "taskName" "bgatlas2008_refresh" "values" .Values.cron.refreshBgatlas2008 "ctx" $) }}
