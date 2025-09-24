{{- if .PROSODY_ADMINS }}
admins = {
  {{- range $i, $v := (splitList "," .PROSODY_ADMINS) }}
  "{{ trim $v }}",
  {{- end }}
}
{{ else }}
admins = {}
{{- end }}

pidfile = "/var/run/prosody/prosody.pid"

allow_registration = {{ if .ALLOW_REGISTRATION }}"{{ .ALLOW_REGISTRATION }}"{{ else }}"true"{{ end }};

c2s_require_encryption = {{ if .C2S_REQUIRE_ENCRYPTION }}"{{ .C2S_REQUIRE_ENCRYPTION }}"{{ else }}"true"{{ end }};
s2s_require_encryption = {{ if .S2S_REQUIRE_ENCRYPTION }}"{{ .S2S_REQUIRE_ENCRYPTION }}"{{ else }}"true"{{ end }};
s2s_secure_auth = {{ if .S2S_SECURE_AUTH }}"{{ .S2S_SECURE_AUTH }}"{{ else }}"true"{{ end }};

authentication = {{ if .AUTHENTICATION }}"{{ .AUTHENTICATION }}"{{ else }}"internal_hashed"{{ end }};

ldap_base = {{ if .LDAP_BASE }}"{{ .LDAP_BASE }}"{{ else }}nil{{ end }};
ldap_server = {{ if .LDAP_SERVER }}"{{ .LDAP_SERVER }}"{{ else }}"localhost"{{ end }};
ldap_rootdn = {{ if .LDAP_ROOTDN }}"{{ .LDAP_ROOTDN }}"{{ else }}""{{ end }};
ldap_password = {{ if .LDAP_PASSWORD }}"{{ .LDAP_PASSWORD }}"{{ else }}""{{ end }};
ldap_filter = {{ if .LDAP_FILTER }}"{{ .LDAP_FILTER }}"{{ else }}"(uid=$user)"{{ end }};
ldap_scope = {{ if .LDAP_SCOPE }}"{{ .LDAP_SCOPE }}"{{ else }}"subtree"{{ end }};
ldap_tls = {{ if .LDAP_TLS }}"{{ .LDAP_TLS }}"{{ else }}"false"{{ end }};
ldap_mode = {{ if .LDAP_MODE }}"{{ .LDAP_MODE }}"{{ else }}"bind"{{ end }};
ldap_admin_filter = {{ if .LDAP_ADMIN_FILTER }}"{{ .LDAP_ADMIN_FILTER }}"{{ else }}""{{ end }};

log = { {levels = {min = {{ if .LOG_LEVEL }}"{{ .LOG_LEVEL }}"{{ else }}"info"{{ end }}}, to = "console"}; };

Include "conf.d/*.cfg.lua";
