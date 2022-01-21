{{/*
Define container image and pull policy
Usage:
{{ include "smartbirds-server.container.image" (dict "values" .Values.image "ctx" $) }}
*/}}
{{- define "smartbirds-server.container.image" -}}
{{- $values := default .values .ctx.Values.image -}}
image: "{{ $values.repository }}:{{ $values.tag | default .ctx.Chart.AppVersion }}"
imagePullPolicy: {{ $values.pullPolicy }}
{{- end -}}

{{/*
Define common container environment
Usage:
{{ include "smartbirds-server.container.common-env" $ }}
*/}}
{{- define "smartbirds-server.container.common-env" -}}
- name: NODE_ENV
  value: production
- name: DATABASE_URL
  value: "postgres://{{ $.Values.postgresql.postgresqlUsername }}:{{ $.Values.postgresql.postgresqlPassword }}@{{ $.Release.Name }}-postgresql:{{ $.Values.postgresql.containerPorts.postgresql }}/{{ $.Values.postgresql.postgresqlDatabase }}"
- name: REDIS_HOST
  value: "{{ $.Release.Name }}-redis-master"
- name: REDIS_PASS
  valueFrom:
    secretKeyRef:
      name: "{{ $.Release.Name }}-redis"
      key: "redis-password"
{{- if $.Values.smartbirds.serverToken }}
- name: SERVER_TOKEN
  value: {{ $.Values.smartbirds.serverToken | quote }}
{{- end }}
{{- if $.Values.smartbirds.sentry.enabled }}
- name: SENTRY_DSN
  value: {{ $.Values.smartbirds.sentry.dsn | quote }}
{{- end }}
{{- end -}}
