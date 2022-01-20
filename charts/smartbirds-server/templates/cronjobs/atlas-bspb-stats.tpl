{{ include "smartbirds-server.cronjob.enqueue" (dict "name" "atlas-bspb-stats" "taskName" "AtlasBspbStats" "values" .Values.cron.atlasBspbStats "ctx" $) }}
