# For tests with pipes see: https://github.com/sstephenson/bats/issues/10

load 'bats/bats-support/load'
load 'bats/bats-assert/load'

@test "Should send 5 messages" {
  run bash -c "sudo docker-compose logs $batsContainerName | grep -E \"Received\[c2s\]: <message\" | wc -l"
  assert_success
  assert_output "5"
}

@test "Should select certificate for example.com" {
  run bash -c "sudo docker-compose logs $batsContainerName | grep \"Certificates loaded\" | grep \" example.com:tls\" | wc -l"
  assert_success
  assert_output "1"
}

@test "Should select certificate for conference.example.com" {
  run bash -c "sudo docker-compose logs $batsContainerName | grep \"Certificates loaded\" | grep \"conference.example.com:tls\" | wc -l"
  assert_success
  assert_output "1"
}

@test "Should select certificate for proxy.example.com" {
  run bash -c "sudo docker-compose logs $batsContainerName | grep \"Certificates loaded\" | grep \"proxy.example.com:tls\" | wc -l"
  assert_success
  assert_output "1"
}

@test "Should select certificate for pubsub.example.com" {
  run bash -c "sudo docker-compose logs $batsContainerName | grep \"Certificates loaded\" | grep \"pubsub.example.com:tls\" | wc -l"
  assert_success
  assert_output "1"
}

@test "Should select certificate for upload.example.com" {
  run bash -c "sudo docker-compose logs $batsContainerName | grep \"Certificates loaded\" | grep \"upload.example.com:tls\" | wc -l"
  assert_success
  assert_output "1"
}

@test "Should log error for user with wrong password" {
  run bash -c "sudo docker-compose logs $batsContainerName | grep \"Session closed by remote with error: undefined-condition (user intervention: authentication failed: authentication aborted by user)\""
  assert_success
  assert_output
}

@test "Should activate s2s" {
  run bash -c "sudo docker-compose logs $batsContainerName | grep -E \"Activated service 's2s' on (\[::\]:5269|\[\*\]:5269), (\[::\]:5269|\[\*\]:5269)\""
  assert_success
  assert_output
}

@test "Should activate c2s" {
  run bash -c "sudo docker-compose logs $batsContainerName | grep -E \"Activated service 'c2s' on (\[::\]:5222|\[\*\]:5222), (\[::\]:5222|\[\*\]:5222)\""
  assert_success
  assert_output
}

@test "Should activate legacy_ssl" {
  run bash -c "sudo docker-compose logs $batsContainerName | grep -E \"Activated service 'legacy_ssl' on (\[::\]:5223|\[\*\]:5223), (\[::\]:5223|\[\*\]:5223)\""
  assert_success
  assert_output
}

@test "Should activate proxy65" {
  run bash -c "sudo docker-compose logs $batsContainerName | grep -E \"Activated service 'proxy65' on (\[::\]:5000|\[\*\]:5000), (\[::\]:5000|\[\*\]:5000)\""
  assert_success
  assert_output
}

@test "Should activate https" {
  run bash -c "sudo docker-compose logs $batsContainerName | grep -E \"Activated service 'https' on (\[::\]:5281|\[\*\]:5281), (\[::\]:5281|\[\*\]:5281)\""
  assert_success
  assert_output
}

@test "Should load module cloud_notify" {
  run bash -c "sudo docker-compose logs $batsContainerName | grep \"example.com:cloud_notify.*info.*Module loaded\""
  assert_success
  assert_output
}

@test "Should show upload URL" {
  run bash -c "sudo docker-compose logs $batsContainerName | grep \"URL: <https:\/\/upload.example.com:5281\/upload> - Ensure this can be reached by users\""
  assert_success
  assert_output
}
