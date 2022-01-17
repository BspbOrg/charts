{{ include "smartbirds-server.cronjob.enqueue" (dict "name" "mailchimp" "taskName" "stats:mailchimp" "values" .Values.cron.mailchimp "ctx" $) }}
