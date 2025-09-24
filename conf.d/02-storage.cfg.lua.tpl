default_storage = "sql"

sql = {
  driver = {{ if .DB_DRIVER }}"{{ .DB_DRIVER }}"{{ else }}"SQLite3"{{ end }};
  database = {{ if .DB_DATABASE }}"{{ .DB_DATABASE }}"{{ else }}"prosody.sqlite"{{ end }};
  host = {{ if .DB_HOST }}"{{ .DB_HOST }}"{{ else }}nil{{ end }};
  port = {{ if .DB_PORT }}{{ .DB_PORT }}{{ else }}nil{{ end }};
  username = {{ if .DB_USERNAME }}"{{ .DB_USERNAME }}"{{ else }}nil{{ end }};
  password = {{ if .DB_PASSWORD }}"{{ .DB_PASSWORD }}"{{ else }}nil{{ end }};
}

-- make 0.10-distributed mod_mam use sql store
archive_store = "archive2" -- Use the same data store as prosody-modules mod_mam

storage = {
  -- this makes mod_mam use the sql storage backend
  archive2 = "sql";
}

-- https://modules.prosody.im/mod_mam.html
archive_expires_after = "1y"

http_max_content_size = {{ if .HTTP_MAX_CONTENT_SIZE }}{{ .HTTP_MAX_CONTENT_SIZE }}{{ else }}1024 * 1024 * 10{{ end }} -- Default is 10MB
