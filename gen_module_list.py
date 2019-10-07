#!/usr/bin/python

import subprocess
import re
import sys

if len(sys.argv) != 2:
  print "Usage: "+sys.argv[0]+" appName"
  sys.exit()

appName = sys.argv[1]

lmodCmd = '/usr/share/lmod/lmod/libexec/lmod'
proc = subprocess.Popen([lmodCmd, 'spider', appName], stderr=subprocess.PIPE, stdout=subprocess.PIPE)

while True:
  line = proc.stderr.readline()
  if not line:
    break
  
  # match 'appName: '. If there is a module name after appName, then it is the only version for the module 
  m = re.match("\W*"+appName+":(.*)", line, re.IGNORECASE) 
  if m:
    singleModule = m.group(1).strip() 
    if singleModule != '':
    # there is only one such module. Print and quit
      print singleModule
      break
    
  # find the keyword 'Versions' and print the versions followed
  m = re.match("\W*"+appName+"/(.*)", line, re.IGNORECASE)
  if m:
    print m.group(0).strip()  

