package  
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	/**
	 * ...
	 * @author umhr
	 */
	public class LocalConnectionManager extends EventDispatcher
	{
		private static var _instance:LocalConnectionManager;
		public function LocalConnectionManager(blocker:Blocker) { init(); };
		public static function getInstance():LocalConnectionManager{
			if ( _instance == null ) {_instance = new LocalConnectionManager(new Blocker());};
			return _instance;
		}
		
		private var _id:int;
		private var _duplexLocalConnectorList:Vector.<DuplexLocalConnector> = new Vector.<DuplexLocalConnector>();
		private var _message:Object;
		private function init():void
		{
			
		}
		
		/**
		 * 接続を作るときに呼び出します。
		 * @param	allNum 接続数
		 * @param	id 自分のID
		 */
		public function connection(allNum:int, id:int):void {
			
			_id = id;
			
			var n:int = allNum;
			for (var i:int = 0; i < n; i++) 
			{
				if (i == id) {
					continue;
				}
				var receiverName:String = "connect" + String(i) + "to" + String(id);
				var senderName:String = "connect" + String(id) + "to" + String(i);
				var duplexLocalConnector:DuplexLocalConnector = new DuplexLocalConnector(receiverName, senderName);
				duplexLocalConnector.addEventListener(Event.CHANGE, duplexLocalConnector_change);
				_duplexLocalConnectorList.push(duplexLocalConnector);
			}
		}
		
		private function duplexLocalConnector_change(event:Event):void 
		{
			var duplexLocalConnector:DuplexLocalConnector = event.target as DuplexLocalConnector;
			_message = duplexLocalConnector.message;
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		/**
		 * 特定の相手に送信
		 * @param	message 送信内容
		 * @param	id 送信相手のID
		 */
		public function sendTo(message:Object, id:int):void {
			var sendToName:String = "connect" + _id + "to" + id;
			
			var n:int = _duplexLocalConnectorList.length;
			for (var i:int = 0; i < n; i++) 
			{
				if (_duplexLocalConnectorList[i].senderName == sendToName) {
					_duplexLocalConnectorList[i].send( message );
				}
			}
		}
		
		/**
		 * 接続しているすべてに送信
		 * @param	message
		 */
		public function sendAll(message:Object):void {
			var n:int = _duplexLocalConnectorList.length;
			for (var i:int = 0; i < n; i++) 
			{
				_duplexLocalConnectorList[i].send( message );
			}
		}
		
		/**
		 * 自己のID
		 */
		public function get id():int 
		{
			return _id;
		}
		
		/**
		 * 受信内容
		 */
		public function get message():Object 
		{
			return _message;
		}
		
	}
	
}
class Blocker { };