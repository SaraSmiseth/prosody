local domain = "{{ .DOMAIN }}"
local domain_http_upload = {{ if .DOMAIN_HTTP_UPLOAD }}"{{ .DOMAIN_HTTP_UPLOAD }}"{{ else }}"upload." .. domain{{ end }}
local domain_muc = {{ if .DOMAIN_MUC }}"{{ .DOMAIN_MUC }}"{{ else }}"conference." .. domain{{ end }}
local domain_proxy = {{ if .DOMAIN_PROXY }}"{{ .DOMAIN_PROXY }}"{{ else }}"proxy." .. domain{{ end }}
local domain_pubsub = {{ if .DOMAIN_PUBSUB }}"{{ .DOMAIN_PUBSUB }}"{{ else }}"pubsub." .. domain{{ end }}

-- XEP-0368: SRV records for XMPP over TLS
-- https://compliance.conversations.im/test/xep0368/
c2s_direct_tls_ssl = {
	certificate = "certs/" .. domain .. "/fullchain.pem";
	key = "certs/" .. domain .. "/privkey.pem";
}
c2s_direct_tls_ports = { 5223 }

-- https://prosody.im/doc/certificates#service_certificates
-- https://prosody.im/doc/ports#ssl_configuration
https_ssl = {
	certificate = "certs/" .. domain_http_upload .. "/fullchain.pem";
	key = "certs/" .. domain_http_upload .. "/privkey.pem";
}

VirtualHost (domain)
disco_items = {
    { domain_http_upload },
}

-- Set up a http file upload because proxy65 is not working in muc
Component (domain_http_upload) "http_file_share"
  http_file_share_expires_after = {{ if .HTTP_FILE_SHARE_EXPIRES_AFTER }}{{ .HTTP_FILE_SHARE_EXPIRES_AFTER }}{{ else }}60 * 60 * 24 * 7{{ end }}
  local size_limit = {{ if .HTTP_FILE_SHARE_SIZE_LIMIT }}{{ .HTTP_FILE_SHARE_SIZE_LIMIT }}{{ else }}10 * 1024 * 1024{{ end }}
  http_file_share_size_limit = size_limit
  http_file_share_daily_quota = {{ if .HTTP_FILE_SHARE_DAILY_QUOTA }}{{ .HTTP_FILE_SHARE_DAILY_QUOTA }}{{ else }}10 * size_limit{{ end }}

Component (domain_muc) "muc"
	name = "Prosody Chatrooms"
	restrict_room_creation = false
	max_history_messages = 20
	modules_enabled = {
		"muc_mam",
		"vcard_muc"
	}

-- Set up a SOCKS5 bytestream proxy for server-proxied file transfers
Component (domain_proxy) "proxy65"
	proxy65_address = domain_proxy
	proxy65_acl = { domain }

-- Implements a XEP-0060 pubsub service.
Component (domain_pubsub) "pubsub"
