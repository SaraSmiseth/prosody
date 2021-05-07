# For tests with pipes see: https://github.com/sstephenson/bats/issues/10

load 'bats/bats-support/load'
load 'bats/bats-assert/load'

@test "Should use sqlite" {
  run bash -c "sudo docker-compose logs $batsContainerName | grep -E \"Connecting to \[SQLite3\] \/usr\/local\/var\/lib\/prosody\/prosody\.sqlite\.\.\.\""
  assert_success
  assert_output
}
