# For tests with pipes see: https://github.com/sstephenson/bats/issues/10

load 'bats/bats-support/load'
load 'bats/bats-assert/load'

# TODO
#@test "Should use internal storage" {
#  run bash -c "sudo docker-compose logs $batsContainerName | grep -E \"Connecting to \[SQLite3\] \/usr\/local\/var\/lib\/prosody\/prosody\.sqlite\.\.\.\""
#  assert_failure
#  assert_output
#}

@test "Should not use sqlite" {
  run bash -c "sudo docker-compose logs $batsContainerName | grep -E \"Connecting to \[SQLite3\] \/usr\/local\/var\/lib\/prosody\/prosody\.sqlite\.\.\.\""
  assert_failure
}

@test "Should not use postgres" {
  run bash -c "sudo docker-compose logs $batsContainerName | grep -E \"Connecting to \[PostgreSQL\] prosody\.\.\.\""
  assert_failure
}
