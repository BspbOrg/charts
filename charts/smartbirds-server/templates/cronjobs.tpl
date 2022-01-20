{{- if .Values.cron.enabled }}
{{- range .Values.cron.jobs }}
{{- if .enabled }}
---
apiVersion: batch/v1
kind: CronJob
metadata:
  name: {{ include "smartbirds-server.fullname" $ }}-{{ .name }}
  labels:
    {{- include "smartbirds-server.labels" $ | nindent 4 }}
spec:
  concurrencyPolicy: {{ .concurency }}
  schedule: {{ .schedule | quote }}
  successfulJobsHistoryLimit: {{ .historyLimit | default 1 }}
  jobTemplate:
    spec:
      template: {{- include "smartbirds-server.job.enqueue" (dict "values" . "ctx" $) | nindent 8 }}
{{- end }}
{{- end }}
{{- end }}
