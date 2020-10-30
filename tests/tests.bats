# For tests with pipes see: https://github.com/sstephenson/bats/issues/10

load 'bats/bats-support/load'
load 'bats/bats-assert/load'

# group alternation in regex because the xml properties switch around. sometimes 'type=...' comes after 'to=...' and sometimes before
@test "Should send 5 messages" {
  run bash -c "sudo docker-compose logs | grep -E \"Received\[c2s\]: <message (type='chat'|to='.*@localhost'|id=':.*') (type='chat'|to='.*@localhost'|id=':.*') (type='chat'|to='.*@localhost'|id=':.*')>\" | wc -l"
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

@test "Should activate s2s" {
  run bash -c "sudo docker-compose logs | grep -E \"Activated service 's2s' on (\[::\]:5269|\[\*\]:5269), (\[::\]:5269|\[\*\]:5269)\""
  assert_success
  assert_output
}

@test "Should activate c2s" {
  run bash -c "sudo docker-compose logs | grep -E \"Activated service 'c2s' on (\[::\]:5222|\[\*\]:5222), (\[::\]:5222|\[\*\]:5222)\""
  assert_success
  assert_output
}

@test "Should activate legacy_ssl" {
  run bash -c "sudo docker-compose logs | grep -E \"Activated service 'legacy_ssl' on (\[::\]:5223|\[\*\]:5223), (\[::\]:5223|\[\*\]:5223)\""
  assert_success
  assert_output
}

@test "Should activate proxy65" {
  run bash -c "sudo docker-compose logs | grep -E \"Activated service 'proxy65' on (\[::\]:5000|\[\*\]:5000), (\[::\]:5000|\[\*\]:5000)\""
  assert_success
  assert_output
}

@test "Should activate http" {
  run bash -c "sudo docker-compose logs | grep -E \"Activated service 'http' on (\[::\]:5280|\[\*\]:5280), (\[::\]:5280|\[\*\]:5280)\""
  assert_success
  assert_output
}

@test "Should activate https" {
  run bash -c "sudo docker-compose logs | grep -E \"Activated service 'https' on (\[::\]:5281|\[\*\]:5281), (\[::\]:5281|\[\*\]:5281)\""
  assert_success
  assert_output
}

@test "Should load module cloud_notify" {
  run bash -c "sudo docker-compose logs | grep \"localhost:cloud_notify.*info.*Module loaded\""
  assert_success
  assert_output
}

@test "Should show upload URL" {
  run bash -c "sudo docker-compose logs | grep \"URL: <https:\/\/upload.localhost:5281\/upload> - Ensure this can be reached by users\""
  assert_success
  assert_output
}
