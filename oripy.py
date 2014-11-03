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

noise = open("meyer-heavy.txt", "r")
lines = noise.readlines()
for line in lines:
  str = line.strip()
  if (str != ""):
    val = int(str)
    for i in range(1, 4):
      t.getNode(i).addNoiseTraceReading(val)

for i in range(1, 4):
  print "Creating noise model for ",i;
  t.getNode(i).createNoiseModel()

t.getNode(1).bootAtTime(100001);
t.getNode(2).bootAtTime(800008);
t.getNode(3).bootAtTime(1800009);

for i in range(0, 100):
  t.runNextEvent()
        
