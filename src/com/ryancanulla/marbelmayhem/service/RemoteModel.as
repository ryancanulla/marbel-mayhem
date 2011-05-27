package com.litl.marbelmayhem.service
{
	import com.adobe.rtc.events.CollectionNodeEvent;
	import com.adobe.rtc.messaging.MessageItem;
	import com.adobe.rtc.session.ConnectSession;
	import com.adobe.rtc.sharedModel.CollectionNode;

	public class RemoteModel
	{
		protected var data:CollectionNode;
		protected var message:MessageItem;
		
		public function RemoteModel() {}
		
		private function createCollection(e:ConnectSession):void {
			data = new CollectionNode();
			data.connectSession = e;
			data.sharedID = "accelerometer-data";
			data.addEventListener(CollectionNodeEvent.ITEM_RECEIVE, onItemReceived);
			data.subscribe();
		}
		
		private function onItemReceived(e:CollectionNodeEvent):void {
			// handle message
			trace("item received");
		}
		
		private function publish(e:MessageItem):void {
			if(data.isSynchronized)
				data.publishItem(e);
		}
		
		public function setData(x:Number, y:Number, z:Number):void {
			var msg:MessageItem = new MessageItem(data.sharedID);
			msg.body = {x:100, y:200, z:300};
			publish(msg);
		}
		
		public function set session(e:ConnectSession):void {
			createCollection(e);
		}
		
	}
}