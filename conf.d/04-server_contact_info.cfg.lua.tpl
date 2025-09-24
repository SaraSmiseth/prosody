
contact_info = {
{{- if .SERVER_CONTACT_INFO_ABUSE }}
abuse = {
  {{- range $i, $v := (splitList "," .SERVER_CONTACT_INFO_ABUSE) }}
  "{{ trim $v }}",
  {{- end }}
},
{{ else }}
abuse = { "xmpp:abuse@{{ .DOMAIN }}" },
{{- end }}

{{- if .SERVER_CONTACT_INFO_ADMIN }}
admin = {
  {{- range $i, $v := (splitList "," .SERVER_CONTACT_INFO_ADMIN) }}
  "{{ trim $v }}",
  {{- end }}
},
{{ else }}
admin = { "xmpp:admin@{{ .DOMAIN }}" },
{{- end }}

{{- if .SERVER_CONTACT_INFO_FEEDBACK }}
feedback = {
  {{- range $i, $v := (splitList "," .SERVER_CONTACT_INFO_FEEDBACK) }}
  "{{ trim $v }}",
  {{- end }}
},
{{ else }}
feedback = { "xmpp:feedback@{{ .DOMAIN }}" },
{{- end }}

{{- if .SERVER_CONTACT_INFO_SALES }}
sales = {
  {{- range $i, $v := (splitList "," .SERVER_CONTACT_INFO_SALES) }}
  "{{ trim $v }}",
  {{- end }}
},
{{ else }}
sales = { "xmpp:sales@{{ .DOMAIN }}" },
{{- end }}

{{- if .SERVER_CONTACT_INFO_SECURITY }}
security = {
  {{- range $i, $v := (splitList "," .SERVER_CONTACT_INFO_SECURITY) }}
  "{{ trim $v }}",
  {{- end }}
},
{{ else }}
security = { "xmpp:security@{{ .DOMAIN }}" },
{{- end }}

{{- if .SERVER_CONTACT_INFO_SUPPORT }}
support = {
  {{- range $i, $v := (splitList "," .SERVER_CONTACT_INFO_SUPPORT) }}
  "{{ trim $v }}",
  {{- end }}
},
{{ else }}
support = { "xmpp:support@{{ .DOMAIN }}" },
{{- end }}
}
