{{- define "s3-bucket.name" -}}
{{- printf "%s-%s" .Values.env .Values.bucketPrefix -}}
{{- end }}

{{- define "s3-bucket.externalName" -}}
{{- printf "%s-%s-%s-%s" .Values.env .Values.bucketPrefix .Values.region .Values.accountId -}}
{{- end }}

{{- define "s3-bucket.arn" -}}
{{- printf "arn:aws:s3:::%s" (include "s3-bucket.externalName" .) -}}
{{- end }}
