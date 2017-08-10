#!/bin/sh
sed -i'' s/0.0.0-development/${1}/g mix.exs
