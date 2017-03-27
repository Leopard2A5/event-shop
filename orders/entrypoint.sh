#!/usr/bin/env bash

rake db:migrate
padrino s -h 0.0.0.0
