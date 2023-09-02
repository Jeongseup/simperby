#!/usr/bin/env bash

test_dir="/Users/jeongseup/simperby-test"
rm -rf $test_dir/client0
rm -rf $test_dir/client1
rm -rf $test_dir/client2
rm -rf $test_dir/server

cargo test --package simperby --test integration_test -- normal_1 --exact --nocapture
