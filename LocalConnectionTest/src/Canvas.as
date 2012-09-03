package  
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import jp.mztm.umhr.logging.Log;
	/**
	 * ...
	 * @author umhr
	 */
	public class Canvas extends Sprite 
	{
		private var mc:Sprite;
		public function Canvas() 
		{
			init();
		}
		private function init():void 
		{
			if (stage) onInit();
			else addEventListener(Event.ADDED_TO_STAGE, onInit);
		}
		
		private function onInit(event:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onInit);
			// entry point
			
			var localConnectionManager:LocalConnectionManager = LocalConnectionManager.getInstance();
			
			// 自分を含めて三つで連携。自分のIDは0番
			localConnectionManager.connection(3, 0);
			
			// 自分を含めて三つで連携。自分のIDは1番
			//localConnectionManager.connection(3, 1);
			
			// 自分を含めて三つで連携。自分のIDは2番
			//localConnectionManager.connection(3, 2);
			
			localConnectionManager.addEventListener(Event.CHANGE, localConnectionManager_change);
			
			stage.addEventListener(MouseEvent.CLICK, onClick);
			
			mc = new Sprite();
			addChild(mc);
			
			addChild(new Log());
		}
		
		private function onClick(event:MouseEvent):void {
			
			var mouseX:Number = mouseX;
			var mouseY:Number = mouseY;
			var rgb:int = Math.random() * 0xffffff;
			mc.graphics.lineStyle();
			mc.graphics.beginFill(rgb);
			mc.graphics.drawCircle(mouseX, mouseY, 10);
			mc.graphics.endFill();
			
			// 全体に送りたいときには、sendAll
			LocalConnectionManager.getInstance().sendAll( { x:mouseX, y:mouseY, "rgb":rgb } );
			
			// 特定の相手だけに送りたいときには、ID付で指定
			//LocalConnectionManager.getInstance().sendTo( { x:mouseX, y:mouseY, "rgb":rgb }, 2 );
		}
		
		private function localConnectionManager_change(event:Event):void 
		{
			makeCircle(LocalConnectionManager.getInstance().message);
		}
		
		private function makeCircle(object:Object):void {
			
			var mouseX:Number = object.x;
			var mouseY:Number = object.y;
			var rgb:int = object.rgb;
			
			mc.graphics.lineStyle(5, rgb);
			mc.graphics.drawCircle(mouseX, mouseY, 12);
		}
	}
	
}