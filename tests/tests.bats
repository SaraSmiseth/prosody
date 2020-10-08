# For tests with pipes see: https://github.com/sstephenson/bats/issues/10

load 'bats/bats-support/load'
load 'bats/bats-assert/load'

@test "Should send 5 messages" {
  run bash -c "sudo docker-compose logs | grep \"Received\[c2s\]: <message type='chat' to='.*@localhost' id=':.*'>\" | wc -l"
  assert_success
  assert_output "5"
}

@test "Should log error for user with wrong password" {
  run bash -c "sudo docker-compose logs | grep \"Session closed by remote with error: undefined-condition (user intervention: authentication failed: authentication aborted by user)\""
  assert_success
  assert_output
}
