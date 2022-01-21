{{- range .Values.cron.jobs }}
{{- if .enabled }}
---
apiVersion: batch/v1
kind: Job
metadata:
  name: {{ include "smartbirds-server.fullname" $ }}-{{ .name }}
  labels:
    {{- include "smartbirds-server.labels" $ | nindent 4 }}
  annotations:
    "helm.sh/hook": post-install,post-upgrade
    "helm.sh/hook-weight": "0"
    "helm.sh/hook-delete-policy": before-hook-creation,hook-succeeded
spec:
  template: {{- include "smartbirds-server.job.enqueue" (dict "values" . "ctx" $) | nindent 4 }}
{{- end }}
{{- end }}
