#!/usr/bin/env python3

import os

def get_keychain(key):
  cmd = "security find-generic-password -s %s -w" % key
  return os.popen(cmd).readline()
