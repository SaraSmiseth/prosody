# For tests with pipes see: https://github.com/sstephenson/bats/issues/10

load 'bats/bats-support/load'
load 'bats/bats-assert/load'

@test "Should use postgres" {
  run bash -c "sudo docker-compose logs $batsContainerName | grep -E \"Connecting to \[PostgreSQL\] prosody\.\.\.\""
  assert_success
  assert_output
}
