package  
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author Alexandre
	 */
	public class Campo extends Sprite
	{
		//private var txt:TextField = new TextField();
		//private var tFormat:TextFormat = new TextFormat("arial", 14);
		
		public function Campo(/*texto:String*/) 
		{
			//txt.defaultTextFormat = tFormat;
			//txt.width = 100;
			//txt.multiline = true;
			//txt.height = 50;
			//txt.autoSize = TextFieldAutoSize.LEFT;
			//
			//this.graphics.beginFill(0xFFFF00, 0.2);
			//this.graphics.drawRect( -50, -20, 100, 40);
			//this.graphics.endFill();
			//
			//addChild(txt);
			//txt.text = texto;
			//
			this.mouseChildren = false;
			this.buttonMode = true;
			
			this.addEventListener(MouseEvent.MOUSE_DOWN, initDrag);
		}
		
		private var localPosClick:Point = new Point();
		private function initDrag(e:MouseEvent):void 
		{
			localPosClick.x = this.mouseX;
			localPosClick.y = this.mouseY;
			stage.addEventListener(MouseEvent.MOUSE_MOVE, dragging);
			stage.addEventListener(MouseEvent.MOUSE_UP, stopDragg);
		}
		
		private var margin:Number = 10;
		private function dragging(e:MouseEvent):void 
		{
			this.x = Math.max(margin ,Math.min(600-margin ,this.parent.mouseX - localPosClick.x));
			this.y = Math.max(margin , Math.min(500-margin ,this.parent.mouseY - localPosClick.y));
		}
		
		private function stopDragg(e:MouseEvent):void 
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, dragging);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stopDragg);
			dispatchEvent(new Event("modificado", true));
		}
		
	}

}