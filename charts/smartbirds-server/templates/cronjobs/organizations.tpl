{{- if and .Values.cron.enabled .Values.cron.organizations.enabled -}}
apiVersion: batch/v1
kind: CronJob
metadata:
  name: {{ include "smartbirds-server.fullname" . }}-organizations-exporter
  labels:
    {{- include "smartbirds-server.labels" . | nindent 4 }}
spec:
  concurrencyPolicy: {{ .Values.cron.organizations.concurency }}
  schedule: {{ .Values.cron.organizations.schedule | quote }}
  successfulJobsHistoryLimit: {{ .Values.cron.organizations.historyLimit }}
  jobTemplate:
    spec:
      template:
        metadata:
          labels:
            {{- include "smartbirds-server.labels" . | nindent 12 }}
            app.kubernetes.io/component: organizations-exporter
        spec:
          {{- with .Values.imagePullSecrets }}
          imagePullSecrets:
            {{- toYaml . | nindent 12 }}
          {{- end }}
          restartPolicy: OnFailure
          serviceAccountName: {{ include "smartbirds-server.serviceAccountName" . }}
          securityContext:
            {{- toYaml .Values.podSecurityContext | nindent 12 }}
          containers:
            - name: {{ .Chart.Name }}-organizations-exporter
              securityContext:
                {{- toYaml .Values.securityContext | nindent 16 }}
              image: "{{ .Values.image.repository }}:{{ .Values.image.tag | default .Chart.AppVersion }}"
              imagePullPolicy: {{ .Values.image.pullPolicy }}
              command:
                - /usr/local/bin/npm
                - run
                - ah
                - --
                - task
                - enqueue
                - --name=organizations:export
              env:
                - name: NODE_ENV
                  value: production
                - name: DATABASE_URL
                  value: "postgres://{{ .Values.postgresql.postgresqlUsername }}:{{ .Values.postgresql.postgresqlPassword }}@{{ .Release.Name }}-postgresql:{{ .Values.postgresql.containerPorts.postgresql }}/{{ .Values.postgresql.postgresqlDatabase }}"
                - name: REDIS_HOST
                  value: "{{ .Release.Name }}-redis-master"
                - name: REDIS_PASS
                  valueFrom:
                    secretKeyRef:
                      name: "{{ .Release.Name }}-redis"
                      key: "redis-password"
                {{- if .Values.smartbirds.serverToken }}
                - name: SERVER_TOKEN
                  value: {{ .Values.smartbirds.serverToken | quote }}
                {{- end }}
                {{- if .Values.smartbirds.sentry.enabled }}
                - name: SENTRY_DSN
                  value: {{ .Values.smartbirds.sentry.dsn | quote }}
                {{- end }}

              {{- if .Values.cron.organizations.resources }}
              resources: {{- toYaml .Values.cron.organizations.resources | nindent 16 }}
              {{- end }}
{{- end }}
