package  
{
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.net.LocalConnection;
	import jp.mztm.umhr.logging.Log;
	/**
	 * ...
	 * @author umhr
	 */
	public class DuplexLocalConnector extends EventDispatcher
	{
		private var _receiverLocalConnection:LocalConnection;
		private var _senderLocalConnection:LocalConnection;
		private var _senderName:String;
		private var _receiverName:String;
		public function DuplexLocalConnector(receiverName:String, senderName:String) 
		{
			_receiverName = receiverName;
			_senderName = senderName;
			receiver(receiverName);
		}
		
		private function receiver(receiverName:String):void 
		{
			_receiverLocalConnection = new LocalConnection();
			_receiverLocalConnection.client = this;
			_receiverLocalConnection.connect(receiverName);
			_receiverLocalConnection.addEventListener(AsyncErrorEvent.ASYNC_ERROR, receiverLocalConnection_asyncError);
			_receiverLocalConnection.addEventListener(StatusEvent.STATUS, receiverLocalConnection_status);
			
		}
		
		private function receiverLocalConnection_status(event:StatusEvent):void 
		{
			Log.trace("DuplexLocalConnector.receiverLocalConnection_status", event.code);
		}
		
		private function receiverLocalConnection_asyncError(event:AsyncErrorEvent):void 
		{
			Log.trace("DuplexLocalConnector.receiverLocalConnection_asyncError", event.errorID);
		}
		
		public function send(message:Object):void {
			if(_senderLocalConnection == null){
				_senderLocalConnection = new LocalConnection();
				_senderLocalConnection.addEventListener(StatusEvent.STATUS, senderLocalConnection_status);
			}
			_senderLocalConnection.send(_senderName, "receiverMethod", message );
		}
		
		private function senderLocalConnection_status(event:StatusEvent):void 
		{
			trace("DuplexLocalConnector.senderLocalConnection_status", event.code, event.type);
		}
		
		public var message:Object;
		public function receiverMethod(message:Object):void {
			this.message = message;
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function get senderName():String 
		{
			return _senderName;
		}
		
		public function get receiverName():String 
		{
			return _receiverName;
		}
		
		
	}

}