---
driver:
  name: ec2
  aws_ssh_key_id: aws-chef-automate
  region: us-east-1
  security_group_ids: sg-2560a741
  associate_public_ip: true
  instance_type: m3.large
  tags:
    Name: "FourthCoffee Test Kitchen Instance"
    created-by: "test-kitchen"
    user: Administrator

provisioner:
  name: chef_zero
  retry_on_exit_code:
    - 35 # 35 is the exit code signaling that the node is rebooting
  max_retries: 1

verifier:
  name: inspec
  format: documentation

platforms:
  - name: windows-2012r2
    driver_config:
      retryable_tries: 80
    transport:
      ssh_key: ~\.ssh\aws-chef-automate.pem

suites:
  - name: default
    run_list:
      - recipe[my_iis::default]
      #- recipe[my_fourthcoffee::repair]
      #- recipe[my_fourthcoffee::revert]
    verifier:
      inspec_tests:
        - test/smoke/default
#          url: https://github.com/dev-sec/ssl-baseline/archive/v1.1.1.tar.gz
        # Some other fun stuff to show off
        #- path: test/smoke/default
        #- name: wannacry-exploit
        #  supermarket: adamleff/wannacry-exploit
        #- name: windows-baseline
        #  supermarket: dev-sec/windows-baseline
    attributes:
