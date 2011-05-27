package com.litl.marbelmayhem.service
{
	import com.litl.marbelmayhem.events.MarbleEvent;
	import com.litl.marbelmayhem.vo.RemoteData;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.net.GroupSpecifier;
	import flash.net.NetConnection;
	import flash.net.NetGroup;

	public class RemoteManager extends EventDispatcher
	{
		private var localNc:NetConnection
		private var group:NetGroup;
		
		private var connected:Boolean = false;
		
		private var groupPin:String;
		
		private var accX:Array = [];
		private var accY:Array = [];
		private var accZ:Array = [];
		
		public function RemoteManager() {
			groupPin = "0123";
		}
		
		public function connect():void{
			localNc = new NetConnection();
			localNc.addEventListener(NetStatusEvent.NET_STATUS, netStatus);
			localNc.connect("rtmfp:");
			
		}
		
		protected function setupGroup():void{
			var groupspec:GroupSpecifier = new GroupSpecifier("LocalDeviceControllers/PIN"+groupPin);
			groupspec.ipMulticastMemberUpdatesEnabled = true;
			groupspec.routingEnabled = true;
			groupspec.postingEnabled = true;
			groupspec.addIPMulticastAddress("225.225.0.1:30303");
			
			group = new NetGroup(localNc, groupspec.groupspecWithAuthorizations());
			group.addEventListener(NetStatusEvent.NET_STATUS,netStatus);
		}
		
		protected function netStatus(event:NetStatusEvent):void{
//			trace(event.info.code);
			switch(event.info.code){
				case "NetConnection.Connect.Success":
					trace("setup group");
					setupGroup();
					break;
				
				case "NetGroup.Connect.Success":
					connected = true;
					trace("connected");
					dispatchEvent(new Event(Event.CONNECT));
					break;
				
				case "NetConnection.Connect.Closed":
					connected = false;
					break;
				
				case "NetGroup.SendTo.Notify":
					
					
					var accel:RemoteData = smoothData(event.info.message.accelerationX, event.info.message.accelerationY, event.info.message.accelerationZ);
					
					
					
					var remoteEvent:MarbleEvent = new MarbleEvent(MarbleEvent.REMOTE_UPDATE);
					remoteEvent.accelerometerRemote = accel;
					dispatchEvent(remoteEvent);	
					
//					trace("accX: " + event.info.message.accelerationX);
//					trace("accY: " + event.info.message.accelerationY);
//					trace("accZ: " + event.info.message.accelerationZ);
//					trace();
//					if(event.info.fromLocal == true){
//						// We have reached final destination
//						trace("Received Message: "+event.info.message.value);
//					}else{
//						// Forwarding
////							netGroup.sendToNearest(e.info.message, e.info.message.destination);
//						trace("Forward Message: "+event.info.message.value);
//						group.sendToNearest(event.info.message, event.info.message.destination);
//					}
					break;
			}
			
		}
		
		protected function smoothData(eX:Number, eY:Number, eZ:Number):RemoteData {
			
			var remote:RemoteData = new RemoteData();
			
			if(accX.length > 5)
				accX.shift();
			
			accX.push(eX);
			
			var xTotal:Number = 0;
			for(var i:uint=0; i<accX.length;i++){
				xTotal += accX[i];
			}
			
			remote.accX = xTotal / accX.length;
			
			if(accY.length > 5)
				accY.shift();
			
			accY.push(eY);
			
			var yTotal:Number = 0;
			for(var j:uint=0; j<accY.length;j++){
				yTotal += accY[j];
			}
			
			remote.accY = yTotal / accY.length;
			
			if(accZ.length > 5)
				accZ.shift();
			
			accZ.push(eZ);
			
			var zTotal:Number = 0;
			for(var k:uint=0; j<accZ.length;k++){
				zTotal += accZ[k];
			}
			
			remote.accZ = zTotal / accZ.length;
			
			return remote;
		}
	}
}