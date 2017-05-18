#!/bin/bash

kill -9 `ps auwwx | grep rabbitmq  | grep boot | awk '{print $2}'`
