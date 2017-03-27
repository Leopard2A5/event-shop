#!/usr/bin/env bash

rake db:migrate
./config.ru
