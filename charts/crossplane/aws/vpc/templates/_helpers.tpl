{{- define "vpc.name" -}}
{{- printf "%s-%s" .Values.env .Values.vpcPrefix -}}
{{- end }}

{{/* called with (dict "root" $ "subnet" .) inside a range */}}
{{- define "vpc.subnetName" -}}
{{- printf "%s-%s" (include "vpc.name" .root) .subnet.name -}}
{{- end }}
