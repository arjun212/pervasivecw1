#!/usr/bin/python

'''
This Script make the network topologies for the 4
config files given in the top level directory

Passing 1 Arguement will clean the directory

All Topologies can be found in "Topologies" folder
'''

import os;
import shutil;
import sys;


args = sys.argv

if (len(args) == 1):

  configs = ["small", "large_random", "large_uniform", "large_grid"]


  top = "topologies"
  if os.path.exists(top):
    shutil.rmtree(top)
  os.makedirs(top)

  for s in configs:
    if os.path.exists(s):
      shutil.rmtree(s)
      print "Removing " + s + '/'
    print "Creating " + s + '/'
    os.makedirs(s)
    print "Copying Config file to " + s
    shutil.copy(s + "config", s + "/config") 
    os.chdir(s)
    os.system("java net.tinyos.sim.LinkLayerModel config")
    os.rename("linkgain.out", s + ".out")
    shutil.copy(s + ".out" ,"../" + top + '/')
    os.chdir("..")

else:
  print "Cleaning Folder"
  top = "topologies"
  files = ["small", "large_random", "large_uniform", "large_grid", top]

  for s in files:
    if os.path.exists(s): 
      shutil.rmtree(s) 
  





 
