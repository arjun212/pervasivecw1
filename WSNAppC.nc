configuration WSNAppC {

}

implementation {
	
	components MainC, WSNC as App;
	components new AMSenderC(AM_RADIO);
	components new AMReceiverC(AM_RADIO);
	components ActiveMessageC;
  	components new TimerMilliC();

	App.Boot -> MainC;
	
	App.Receive -> AMReceiverC;
	App.AMSend -> AMSenderC;
	App.AMControl -> ActiveMessageC;
	App.Packet -> AMSenderC;
  	App.MilliTimer -> TimerMilliC;
	
}