package  
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Alexandre
	 */
	public class Flechinha extends Sprite
	{
		private var head:Sprite = new Sprite();
		private var body:Sprite = new Sprite();
		private var _comp:Number = 50;
		private var _angle:Number = 0;
		private var cor:uint;
		
		public function Flechinha(cor:uint, movable:Boolean = true) 
		{
			this.cor = cor;
			head.x = comp;
			
			this.addChild(body);
			this.addChild(head);
			
			startHead();
			draw();
			
			if (movable) addListeners();
			else this.mouseChildren = false;
		}
		
		private function startHead():void
		{
			head.graphics.beginFill(0xFF8080, 0);
			head.graphics.drawCircle(15 / 3, 0, 15);
			head.graphics.endFill();
			
			head.graphics.beginFill(cor, 1);
			head.graphics.lineStyle(1, cor);
			head.graphics.moveTo(0, 0);
			head.graphics.lineTo(0, 5);
			head.graphics.lineTo(15, 0);
			head.graphics.lineTo(0, -5);
			head.graphics.lineTo(0, 0);
			head.graphics.endFill();
		}
		
		private function addListeners():void 
		{
			head.buttonMode = true;
			body.buttonMode = true;
			
			head.addEventListener(MouseEvent.MOUSE_DOWN, initDrag);
			body.addEventListener(MouseEvent.MOUSE_DOWN, initDrag);
		}
		
		private var drag:Sprite;
		private var localPosClick:Point = new Point();
		private function initDrag(e:MouseEvent):void 
		{
			drag = Sprite(e.target);
			localPosClick.x = this.mouseX;
			localPosClick.y = this.mouseY;
			stage.addEventListener(MouseEvent.MOUSE_MOVE, dragging);
			stage.addEventListener(MouseEvent.MOUSE_UP, stopDragg);
		}
		
		private function dragging(e:MouseEvent):void 
		{
			if (drag == body) {
				this.x = this.parent.mouseX - localPosClick.x;
				this.y = this.parent.mouseY - localPosClick.y;
			}else {
				//head.x = this.mouseX;
				//head.y = this.mouseY;
				_angle = Math.atan2(this.mouseY - body.y, this.mouseX - body.x);
				updateHeadPos();
				draw();
			}
		}
		
		private function stopDragg(e:MouseEvent):void 
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, dragging);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stopDragg);
			draw();
			drag = null;
		}
		
		private function draw():void 
		{
			//_angle = Math.atan2(head.y - body.y, head.x - body.x);
			//_comp = Point.distance(new Point(0,0), new Point(head.x, head.y));
			
			body.graphics.clear();
			
			body.graphics.lineStyle(30, 0xFF8080, 0);
			body.graphics.moveTo(0, 0);
			body.graphics.lineTo(head.x, head.y);
			
			body.graphics.lineStyle(2, cor);
			body.graphics.moveTo(0, 0);
			body.graphics.lineTo(head.x, head.y);
			
			head.rotation = angle * 180/Math.PI;
		}
		
		public function get comp():Number 
		{
			return _comp;
		}
		
		public function set comp(value:Number):void 
		{
			_comp = value;
			updateHeadPos();
			draw();
		}
		
		public function get angle():Number 
		{
			return _angle;
		}
		
		public function set angle(value:Number):void 
		{
			_angle = value;
			updateHeadPos();
			draw();
		}
		
		private function updateHeadPos():void
		{
			head.x = Math.cos(_angle) * _comp;
			head.y = Math.sin(_angle) * _comp;
		}
		
	}

}