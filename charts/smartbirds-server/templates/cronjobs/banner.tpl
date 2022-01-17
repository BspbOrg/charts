{{ include "smartbirds-server.cronjob.enqueue" (dict "name" "banners" "taskName" "banner:generate" "values" .Values.cron.banners "ctx" $) }}
