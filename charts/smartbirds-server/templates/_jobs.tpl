{{/*
Create a job definition to enqueue task
Usage:
{{ include "smartbirds-server.job.enqueue" ("values" (dict "name" "job-name" "taskName" "task-name" "taskArgs" (dict "opt1" "val1)) "ctx" $) }}
*/}}
{{- define "smartbirds-server.job.enqueue" -}}
metadata:
  labels:
    {{- include "smartbirds-server.labels" .ctx | nindent 4 }}
    app.kubernetes.io/component: enqueue-{{ .values.name }}
spec:
  {{- with .ctx.Values.imagePullSecrets }}
  imagePullSecrets: {{- toYaml . | nindent 4 }}
  {{- end }}
  restartPolicy: {{ .values.restartPolicy | default "OnFailure" }}
  serviceAccountName: {{ include "smartbirds-server.serviceAccountName" .ctx }}
  securityContext: {{- toYaml .ctx.Values.podSecurityContext | nindent 4 }}
  containers:
    - name: {{ .ctx.Chart.Name }}-enqueue-{{ .values.name }}
      securityContext: {{- toYaml (default .values.securityContext .ctx.Values.securityContext) | nindent 8 }}
      {{- include "smartbirds-server.container.image" (dict "ctx" .ctx) | nindent 6 }}
      command:
        - /usr/local/bin/npm
        - run
        - ah
        - --
        - task
        - enqueue
        - --name={{ .values.taskName }}
        {{- if .values.taskArgs }}
        - --args={{ toJson .values.taskArgs }}
        {{- end }}
      env: {{- include "smartbirds-server.container.common-env" .ctx | nindent 8 }}
      {{- if .values.resources }}
      resources: {{- toYaml .values.resources | nindent 8 }}
      {{- end }}
{{- end -}}
