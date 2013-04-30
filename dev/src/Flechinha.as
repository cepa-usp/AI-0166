package  
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Mouse;
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
		private var newMouseForm:MovieClip;
		
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
			
			addOverEL();
		}
		
		private function addOverEL():void
		{
			head.addEventListener(MouseEvent.MOUSE_OVER, overHead);
			body.addEventListener(MouseEvent.MOUSE_OVER, overBody);
		}
		
		public function removeOverEL():void
		{
			head.removeEventListener(MouseEvent.MOUSE_OVER, overHead);
			body.removeEventListener(MouseEvent.MOUSE_OVER, overBody);
			
			head.removeEventListener(MouseEvent.MOUSE_OUT, outHeadBody);
			body.removeEventListener(MouseEvent.MOUSE_OUT, outHeadBody);
			
			if (newMouseForm != null) {
				newMouseForm.stopDrag();
				stage.removeChild(newMouseForm);
				newMouseForm = null;
				Mouse.show();
			}
		}
		
		private function overHead(e:MouseEvent):void 
		{
			Mouse.hide();
			newMouseForm = new RotateForm();
			newMouseForm.mouseEnabled = false;
			newMouseForm.x = stage.mouseX;
			newMouseForm.y = stage.mouseY;
			rotateCursor(null);
			newMouseForm.startDrag();
			stage.addChild(newMouseForm);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, rotateCursor);
			//removeOverEL();
			head.addEventListener(MouseEvent.MOUSE_OUT, outHeadBody);
			//dispatchEvent(new Event("overHead", true));
			
		}
		
		private function rotateCursor(e:MouseEvent):void 
		{
			newMouseForm.rotation = 90 + Math.atan2(this.mouseY, this.mouseX) * 180/Math.PI;
		}
		
		private function overBody(e:MouseEvent):void 
		{
			Mouse.hide();
			newMouseForm = new MoveForm();
			newMouseForm.mouseEnabled = false;
			newMouseForm.x = stage.mouseX;
			newMouseForm.y = stage.mouseY;
			newMouseForm.startDrag();
			stage.addChild(newMouseForm);
			//removeOverEL();
			body.addEventListener(MouseEvent.MOUSE_OUT, outHeadBody);
			//dispatchEvent(new Event("overBody", true));
		}
		
		private function outHeadBody(e:MouseEvent):void
		{
			head.removeEventListener(MouseEvent.MOUSE_OUT, outHeadBody);
			body.removeEventListener(MouseEvent.MOUSE_OUT, outHeadBody);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, rotateCursor);
			//dispatchEvent(new Event("outHB", true));
			//addOverEL();
			newMouseForm.stopDrag();
			stage.removeChild(newMouseForm);
			newMouseForm = null;
			Mouse.show();
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
		
		private var margin:Number = 10;
		private function dragging(e:MouseEvent):void 
		{
			if (drag == body) {
				this.x = Math.max(margin ,Math.min(600-margin ,this.parent.mouseX - localPosClick.x));
				this.y = Math.max(margin , Math.min(500-margin ,this.parent.mouseY - localPosClick.y));
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
			dispatchEvent(new Event("modificado", true));
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