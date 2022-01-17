{{/*
Create a complete cronjob definition to enqueue task
Usage:
{{ include "smartbirds-server.cronjob.enqueue" (dict "name" "job-name" "taskName" "task-name" "args" (dict "opt1" "val1) "values" .Values.cronjob.task-name "ctx" $) }}
*/}}
{{- define "smartbirds-server.cronjob.enqueue" -}}
{{- if and .ctx.Values.cron.enabled .values.enabled -}}
apiVersion: batch/v1
kind: CronJob
metadata:
  name: {{ include "smartbirds-server.fullname" .ctx }}-{{ .name }}
  labels:
    {{- include "smartbirds-server.labels" .ctx | nindent 4 }}
spec:
  concurrencyPolicy: {{ .values.concurency }}
  schedule: {{ .values.schedule | quote }}
  successfulJobsHistoryLimit: {{ .values.historyLimit | default 1 }}
  jobTemplate:
    spec:
      template:
        metadata:
          labels:
            {{- include "smartbirds-server.labels" .ctx | nindent 12 }}
            app.kubernetes.io/component: enqueue-{{ .name }}
        spec:
          {{- with .ctx.Values.imagePullSecrets }}
          imagePullSecrets:
            {{- toYaml . | nindent 12 }}
          {{- end }}
          restartPolicy: {{ .values.restartPolicy | default "OnFailure" }}
          serviceAccountName: {{ include "smartbirds-server.serviceAccountName" .ctx }}
          securityContext:
            {{- toYaml .ctx.Values.podSecurityContext | nindent 12 }}
          containers:
            - name: {{ .ctx.Chart.Name }}-enqueue-{{ .name }}
              securityContext: {{- toYaml (default .values.securityContext .ctx.Values.securityContext) | nindent 16 }}
              {{- include "smartbirds-server.container.image" (dict "ctx" .ctx) | nindent 14 }}
              command:
                - /usr/local/bin/npm
                - run
                - ah
                - --
                - task
                - enqueue
                - --name={{ .taskName }}
                {{- if .args }}
                - --args={{ toJson .args }}
                {{- end }}
              env:
                {{- include "smartbirds-server.container.common-env" .ctx | nindent 16 }}
              {{- if .values.resources }}
              resources: {{- toYaml .values.resources | nindent 16 }}
              {{- end }}
{{- end }}
{{- end -}}
