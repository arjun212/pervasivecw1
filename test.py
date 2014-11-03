from TOSSIM import *
import sys


args = sys.argv;
t = Tossim([])
r = t.radio()
f = open(args[1], "r")

lines = f.readlines()
for line in lines:
  s = line.split()
  if ((len(s) > 0)  and (s[0] == "gain")):
    print " ", s[1], " ", s[2], " ", s[3];
    r.add(int(s[1]), int(s[2]), float(s[3]))

t.addChannel("WSNC", sys.stdout)
t.addChannel("Boot", sys.stdout)

noise = open(args[1], "r")
lines = noise.readlines()
x = 1
for line in lines:
  s = line.split()
  if ((len(s) > 0) and (s[0] == "noise")):
    val = int(round(float(s[2])))
    t.getNode(x).addNoiseTraceReading(val)
    x += 1

for i in range(1, x):
  print "test.py : Creating noise model for ",i;
  t.getNode(i).createNoiseModel()
  t.getNode(i).bootAtTime(i * 10000);

for i in range(0, 10000):
  t.runNextEvent()
        
