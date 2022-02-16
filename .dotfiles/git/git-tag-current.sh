#!/usr/bin/env bash
git tag --sort=committerdate | grep -E '^[0-9]' | tail -1