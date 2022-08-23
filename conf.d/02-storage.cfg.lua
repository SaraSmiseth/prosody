default_storage = os.getenv("STORAGE")

sql = {
  driver = os.getenv("DB_DRIVER");
  database = os.getenv("DB_DATABASE");
  host = os.getenv("DB_HOST");
  port = os.getenv("DB_PORT");
  username = os.getenv("DB_USERNAME");
  password = os.getenv("DB_PASSWORD");
}

-- make 0.10-distributed mod_mam use sql store
archive_store = "archive2" -- Use the same data store as prosody-modules mod_mam

storage = {
  -- this makes mod_mam use the sql storage backend
  archive = os.getenv("STORAGE");
}

-- https://modules.prosody.im/mod_mam.html
archive_expires_after = "1y"

