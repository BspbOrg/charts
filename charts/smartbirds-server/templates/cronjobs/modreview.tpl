{{ include "smartbirds-server.cronjob.enqueue" (dict "name" "modreview" "taskName" "birdsNewSpeciesModeratorReview" "values" .Values.cron.birdsNewSpeciesModeratorReview "ctx" $) }}
