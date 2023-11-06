#!/bin/sh

sbcl \
    --noinform \
    --eval "(pushnew (uiop:getcwd) ql:*local-project-directories*)" \
    --eval "(ql:quickload :akari)" \
    --eval "(asdf:make :akari)" \
    --quit
