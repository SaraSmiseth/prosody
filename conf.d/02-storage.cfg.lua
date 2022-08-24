default_storage = os.getenv("DEFAULT_STORAGE")

sql = {
  driver = os.getenv("DB_DRIVER");
  database = os.getenv("DB_DATABASE");
  host = os.getenv("DB_HOST");
  port = os.getenv("DB_PORT");
  username = os.getenv("DB_USERNAME");
  password = os.getenv("DB_PASSWORD");
}

archive_store = os.getenv("ARCHIVE_STORE")

storage = {
  -- this makes mod_mam use the sql storage backend
  archive2 = os.getenv("STORAGE_ARCHIVE2");
}

-- https://modules.prosody.im/mod_mam.html
archive_expires_after = "1y"

