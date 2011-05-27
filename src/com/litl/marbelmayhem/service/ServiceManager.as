package com.litl.marbelmayhem.service
{
	
	import com.litl.marbelmayhem.controller.GameController;
	import com.litl.marbelmayhem.model.GameManager;
	import com.litl.marbelmayhem.vo.Player;
	
	import flash.events.Event;
	
	import realtimelib.P2PGame;
	import realtimelib.events.PeerStatusEvent;

	public class ServiceManager
	{
		private var game:P2PGame;
		private var _model:GameManager;
		
		private static const SERVER:String = "rtmfp://p2p.rtmfp.net/";
		private static const DEVKEY:String = "5b7f7a6afc5fc705067d091d-96962ddabf88";
		
		public function ServiceManager() {
			createGame();
		}

		private function createGame():void {
			game = new P2PGame(SERVER+DEVKEY,"myGroupName");
			game.addEventListener(Event.CONNECT, onGameConnect);
			game.addEventListener(Event.CHANGE, onUsersChange);
			game.connect("ryan" + Math.round(Math.random() * 25));
		}
		
		private function onGameConnect(event:Event):void {
			trace("game connected");
			game.session.mainChat.addEventListener(PeerStatusEvent.USER_ADDED, onUserAdded);
			game.session.mainChat.addEventListener(PeerStatusEvent.USER_REMOVED, onUserRemoved);
			game.setReceivePositionCallback(receivePosition);
		}
		
		private function onUserAdded(e:PeerStatusEvent):void {
			var player:Player = new Player();
			player.id = e.info.id;
			player.name = e.info.name;
			
			if(player.id == game.myUser.id)
				player.isMe = true;
			
			_model.addPlayer(player);
		}
		
		private function onUserRemoved(e:PeerStatusEvent):void {
			_model.removePlayer(e.info.id);
			trace("remove player");
		}
		
		private function onUsersChange(event:Event):void {
			// write user names
			// you have userNames (Array of Strings), userNamesString (String), userList (String)
			trace("on users change");
//			txtUsers.text = "Users: \n"+game.session.mainChat.userNamesString;
			
//			for each(var user:Object in game.userList){
//				
//				//createPlayer(user)
//			}				
		}
		
		public function sendPosition(e:Object):void {
			game.sendPosition(e);
		}
		
		protected function receivePosition(peerID:String, position:Object):void {

		}

		public function set model(value:GameManager):void
		{
			_model = value;
		}


	}
}