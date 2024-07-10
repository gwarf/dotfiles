#!/usr/bin/env bash

# Extract pk7 and Dump information about pk7
openssl smime -verify -in 1571297081.R5855126756991174876.Baptistes-MBP-2-f821:2,S -noverify -pk7out | openssl pkcs7 -print_certs -noout -text
