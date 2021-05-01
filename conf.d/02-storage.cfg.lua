default_storage = "sql"

-- TODO change if
--if DB_DRIVER then
  sql = {
    driver = os.getenv("DB_DRIVER"); -- May also be "PostgreSQL" or "MySQL" or "SQLite3" (case sensitive!)
    database = os.getenv("DB_DATABASE"); -- The database name to use. For SQLite3 this the database filename (relative to the data storage directory).
    host = os.getenv("DB_HOST"); -- The address of the database server (delete this line for Postgres)
    port = os.getenv("DB_PORT"); -- 3306 - For databases connecting over TCP
    username = os.getenv("DB_USERNAME"); -- The username to authenticate to the database
    password = os.getenv("DB_PASSWORD"); -- The password to authenticate to the database
  }
--else
  --sql = {
    --driver = "SQLite3";
    --database = "prosody.sqlite";
  --}
--end

-- make 0.10-distributed mod_mam use sql store
archive_store = "archive2" -- Use the same data store as prosody-modules mod_mam

storage = {
  -- this makes mod_mam use the sql storage backend
  archive2 = "sql";
}

-- https://modules.prosody.im/mod_mam.html
archive_expires_after = "1y"

