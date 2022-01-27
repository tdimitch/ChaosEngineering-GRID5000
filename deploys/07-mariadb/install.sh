#!/bin/bash

( cd yamls && kubectl apply -f . ) 2>&1 > registro.log

