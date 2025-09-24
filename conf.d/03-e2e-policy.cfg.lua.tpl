e2e_policy_chat = {{ if .E2E_POLICY_CHAT }}"{{ .E2E_POLICY_CHAT }}"{{ else }}"required"{{ end }}
e2e_policy_muc = {{ if .E2E_POLICY_MUC }}"{{ .E2E_POLICY_MUC }}"{{ else }}"required"{{ end }}

{{- if .E2E_POLICY_WHITELIST }}
e2e_policy_whitelist = {
  {{- range $i, $v := (splitList "," .E2E_POLICY_WHITELIST) }}
  "{{ trim $v }}",
  {{- end }}
}
{{ else }}
e2e_policy_whitelist = { "" }
{{- end }}

e2e_policy_message_optional_chat = {{ if .E2E_POLICY_MESSAGE_OPTIONAL_CHAT }}"{{ .E2E_POLICY_MESSAGE_OPTIONAL_CHAT }}"{{ else }}"For security reasons, OMEMO, OTR or PGP encryption is STRONGLY recommended for conversations on this server."{{ end }}
e2e_policy_message_required_chat = {{ if .E2E_POLICY_MESSAGE_REQUIRED_CHAT }}"{{ .E2E_POLICY_MESSAGE_REQUIRED_CHAT }}"{{ else }}"For security reasons, OMEMO, OTR or PGP encryption is required for conversations on this server."{{ end }}
e2e_policy_message_optional_muc = {{ if .E2E_POLICY_MESSAGE_OPTIONAL_MUC }}"{{ .E2E_POLICY_MESSAGE_OPTIONAL_MUC }}"{{ else }}"For security reasons, OMEMO, OTR or PGP encryption is STRONGLY recommended for MUC on this server."{{ end }}
e2e_policy_message_required_muc = {{ if .E2E_POLICY_MESSAGE_REQUIRED_MUC }}"{{ .E2E_POLICY_MESSAGE_REQUIRED_MUC }}"{{ else }}"For security reasons, OMEMO, OTR or PGP encryption is required for MUC on this server."{{ end }}
