#!/bin/bash
python -m http.server 8000 -d ~/.cache/mutt/ &
browsh --startup-url "localhost:8000/mail.html"
