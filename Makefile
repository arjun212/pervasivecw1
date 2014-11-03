COMPONENT=WSNAppC
BUILD_EXTRA_DEPS = RadioCountMsg.py RadioCountMsg.class
CLEAN_EXTRA = RadioCountMsg.py RadioCountMsg.class RadioCountMsg.java

RadioCountMsg.py: WSN.h
	mig python -target=$(PLATFORM) $(CFLAGS) -python-classname=RadioCountMsg WSN.h radio_count_msg -o $@

RadioCountMsg.class: RadioCountMsg.java
	javac RadioCountMsg.java

RadioCountMsg.java: WSN.h
	mig java -target=$(PLATFORM) $(CFLAGS) -java-classname=RadioCountMsg WSN.h radio_count_msg -o $@


include $(MAKERULES)
