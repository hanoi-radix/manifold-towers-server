#!/bin/sh

DIR="$( cd "$( dirname "$0" )" && pwd )"
cd $DIR'/..'

protoc --go_out=. server.proto