{{/*
Expand the name of the chart.
*/}}
{{- define "smartbirds.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "smartbirds.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "smartbirds.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "smartbirds.labels" -}}
helm.sh/chart: {{ include "smartbirds.chart" . }}
{{ include "smartbirds.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "smartbirds.selectorLabels" -}}
app.kubernetes.io/name: {{ include "smartbirds.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create ingress paths
*/}}
{{- define "smartbirds.ingressPaths" -}}
paths:
  - path: /
    pathType: Prefix
    backend:
      {{- include "smartbirds.ingressBackendWeb" . | nindent 6 }}
  - path: /api
    pathType: Prefix
    backend:
      {{- include "smartbirds.ingressBackendServer" . | nindent 6 }}
{{- end }}

{{/*
Create ingress backend definition to smartbirds-server service
*/}}
{{- define "smartbirds.ingressBackendServer" -}}
service:
  name: {{ $.Release.Name }}-smartbirds-server
  port:
    name: http
{{- end }}

{{/*
Create ingress backend definition to smartbirds-web service
*/}}
{{- define "smartbirds.ingressBackendWeb" -}}
service:
  name: {{ $.Release.Name }}-smartbirds-web
  port:
    name: http
{{- end }}
