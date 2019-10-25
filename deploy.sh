#!/bin/bash
rm -rf dist/
npm run build

docker build -t back/stockmkt_usil . -f back.Dockerfile
