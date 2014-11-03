#include "WSN.h"

module WSNC {

	uses {	//General Interfaces
		interface Boot;
		interface Timer<TMilli> as MilliTimer;
	}

	uses {	//Radio Interfaces
		interface Receive;
		interface AMSend;
		interface SplitControl as AMControl;
		interface Packet;
	}
}

implementation {

	message_t packet;

	bool radioBusy;

	event void Boot.booted() {
		call AMControl.start();
	}

	event void AMControl.startDone(error_t error) {
		if(error == 0) {
			dbg("WSNC", "AMControl Started Successfully.\n");
			call MilliTimer.startPeriodic(250);
		}
		else {
			dbg("WSNC", "AMControl DID NOT START, attempting to start again.\n");
			call AMControl.start();
		}
	}

	event void AMControl.stopDone(error_t error) {
	}

	event void MilliTimer.fired() {

		dbg("WSNC", "WSNC: timer fired.\n");

		if(radioBusy) {
			return;
		}
		else {
			radio_count_msg_t * npm = (radio_count_msg_t * ) call Packet.getPayload(&packet,
					sizeof(radio_count_msg_t));
			if(npm == NULL) {
				return;
			}
			npm->node_id = TOS_NODE_ID;
			if(call AMSend.send(AM_RADIO, &packet, sizeof(radio_count_msg_t)) == SUCCESS) {
				dbg("WSNC", "WSNC: packet sent by %i.\n", TOS_NODE_ID);
				radioBusy = TRUE;
			}
		}
	}
	event message_t * Receive.receive(message_t * msg, void * payload,
			uint8_t len) {
		dbg("WSNC", "RECIEVEING\n");
		if(len != sizeof(radio_count_msg_t)) {
			return msg;
		}
		else {
			radio_count_msg_t * npm = (radio_count_msg_t * ) payload;
			dbg("WSNC", "Received packet from %i.\n", npm->node_id);
			return msg;
		}
	}

	event void AMSend.sendDone(message_t * msg, error_t error) {
		if(msg == &packet) {
			radioBusy = FALSE;
		}
	}
}