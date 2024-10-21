#!/bin/bash

tmux attach -t what \; run-shell 'make && tmux detach'
