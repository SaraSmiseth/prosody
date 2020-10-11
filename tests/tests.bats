# For tests with pipes see: https://github.com/sstephenson/bats/issues/10

load 'bats/bats-support/load'
load 'bats/bats-assert/load'

# group alternation in regex because the xml properties switch around. sometimes 'type=...' comes after 'to=...' and sometimes before
@test "Should send 5 messages" {
  run bash -c "sudo docker-compose logs | grep -E \"Received\[c2s\]: <message (type='chat' to='.*@localhost'|to='.*@localhost' type='chat') id=':.*'>\" | wc -l"
  assert_success
  assert_output "5"
}

@test "Should select certificate for localhost" {
  run bash -c "sudo docker-compose logs | grep \"Selecting certificate /usr/local/etc/prosody/certs/localhost/fullchain.pem with key /usr/local/etc/prosody/certs/localhost/privkey.pem for localhost\" | wc -l"
  assert_success
  assert_output "3"
}

@test "Should select certificate for conference.localhost" {
  run bash -c "sudo docker-compose logs | grep \"Selecting certificate /usr/local/etc/prosody/certs/conference.localhost/fullchain.pem with key /usr/local/etc/prosody/certs/conference.localhost/privkey.pem for conference.localhost\" | wc -l"
  assert_success
  assert_output "3"
}

@test "Should select certificate for proxy.localhost" {
  run bash -c "sudo docker-compose logs | grep \"Selecting certificate /usr/local/etc/prosody/certs/proxy.localhost/fullchain.pem with key /usr/local/etc/prosody/certs/proxy.localhost/privkey.pem for proxy.localhost\" | wc -l"
  assert_success
  assert_output "3"
}

@test "Should select certificate for pubsub.localhost" {
  run bash -c "sudo docker-compose logs | grep \"Selecting certificate /usr/local/etc/prosody/certs/pubsub.localhost/fullchain.pem with key /usr/local/etc/prosody/certs/pubsub.localhost/privkey.pem for pubsub.localhost\" | wc -l"
  assert_success
  assert_output "3"
}

@test "Should select certificate for upload.localhost" {
  run bash -c "sudo docker-compose logs | grep \"Selecting certificate /usr/local/etc/prosody/certs/upload.localhost/fullchain.pem with key /usr/local/etc/prosody/certs/upload.localhost/privkey.pem for upload.localhost\" | wc -l"
  assert_success
  assert_output "3"
}

@test "Should log error for user with wrong password" {
  run bash -c "sudo docker-compose logs | grep \"Session closed by remote with error: undefined-condition (user intervention: authentication failed: authentication aborted by user)\""
  assert_success
  assert_output
}
