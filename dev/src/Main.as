package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	
	/**
	 * ...
	 * @author Alexandre
	 */
	public class Main extends Sprite 
	{
		private const corGravidade:uint = 0xDD0000;
		private const corPressao:uint = 0x0000FF;
		
		private var layer_moldura:Sprite = new Sprite();
		private var layer_flechas:Sprite = new Sprite();
		
		private var flechaGravidade:Flechinha = new Flechinha(corGravidade, false);
		private var flechaPressao:Flechinha = new Flechinha(corPressao, false);
		
		private var campo1:Campo = new CampoG();
		private var campo2:Campo = new CampoP();
		
		private var flechasG:Vector.<Flechinha> = new Vector.<Flechinha>();
		private var flechasP:Vector.<Flechinha> = new Vector.<Flechinha>();
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			this.scrollRect = new Rectangle(0, 0, 600, 500);
			
			flechaGravidade.x = 60;
			flechaGravidade.y = 465;
			
			flechaPressao.x = 180;
			flechaPressao.y = 465;
			
			addChild(flechaGravidade);
			addChild(flechaPressao);
			
			flechaGravidade.addEventListener(MouseEvent.MOUSE_DOWN, flechaDown);
			flechaPressao.addEventListener(MouseEvent.MOUSE_DOWN, flechaDown);
			
			campo1.x = 360;
			campo1.y = 465;
			
			campo2.x = 510;
			campo2.y = 465;
			
			addChild(campo1);
			addChild(campo2);
			addChild(layer_flechas);
			
			layer_moldura.graphics.lineStyle(4, 0xC0C0C0);
			layer_moldura.graphics.lineTo(600, 0);
			layer_moldura.graphics.lineTo(600, 500);
			layer_moldura.graphics.lineTo(0, 500);
			layer_moldura.graphics.lineTo(0, 0);
			addChild(layer_moldura);
			
			
			stage.addEventListener(KeyboardEvent.KEY_UP, keyboardHandler);
		}
		
		private var flechaDrag:Flechinha;
		private function flechaDown(e:MouseEvent):void 
		{
			var newFlecha:Flechinha;
			if (Sprite(e.target) == flechaGravidade) {
				newFlecha = new Flechinha(corGravidade);
				flechasG.push(newFlecha);
			}else {
				newFlecha = new Flechinha(corPressao);
				flechasP.push(newFlecha);
			}
			flechaDrag = newFlecha;
			flechaDrag.x = stage.mouseX;
			flechaDrag.y = stage.mouseY;
			layer_flechas.addChild(flechaDrag);
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, moveNewFlecha);
			stage.addEventListener(MouseEvent.MOUSE_UP, stopMoveFlecha);
		}
		
		private function moveNewFlecha(e:MouseEvent):void 
		{
			flechaDrag.x = stage.mouseX;
			flechaDrag.y = stage.mouseY;
		}
		
		private function stopMoveFlecha(e:MouseEvent):void 
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, moveNewFlecha);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stopMoveFlecha);
			flechaDrag = null;
		}
		
		private var state:Object;
		private function keyboardHandler(e:KeyboardEvent):void 
		{
			switch(e.keyCode) {
				case Keyboard.S:
					state = getstate();
					break;
				case Keyboard.R:
					recoverState(state);
			}
		}
		
		private function getstate():Object
		{
			var state:Object = new Object();
			
			state.fg = new Object();
			state.fg.l = flechasG.length;
			for (var i:int = 0; i < flechasG.length; i++) 
			{
				state.fg[i] = new Object();
				state.fg[i].x = flechasG[i].x;
				state.fg[i].y = flechasG[i].y;
				//state.fg[i].c = flechasG[i].comp;
				state.fg[i].a = flechasG[i].angle;
			}
			
			state.fp = new Object();
			state.fp.l = flechasP.length;
			for (i = 0; i < flechasP.length; i++) 
			{
				state.fp[i] = new Object();
				state.fp[i].x = flechasP[i].x;
				state.fp[i].y = flechasP[i].y;
				//state.fp[i].c = flechasP[i].comp;
				state.fp[i].a = flechasP[i].angle;
			}
			
			state.c1 = new Object();
			state.c1.x = campo1.x;
			state.c1.y = campo1.y;
			
			state.c2 = new Object();
			state.c2.x = campo2.x;
			state.c2.y = campo2.y;
			
			return state;
		}
		
		private function recoverState(state:Object):void
		{
			reset();
			
			for (var i:int = 0; i < state.fg.l; i++) 
			{
				var newFg:Flechinha = new Flechinha(corGravidade);
				newFg.x = state.fg[i].x;
				newFg.y = state.fg[i].y;
				//newFg.comp = state.fg[i].c;
				newFg.angle = state.fg[i].a;
				flechasG.push(newFg);
				layer_flechas.addChild(newFg);
			}
			
			for (i = 0; i < state.fp.l; i++) 
			{
				var newFp:Flechinha = new Flechinha(corPressao);
				newFp.x = state.fp[i].x;
				newFp.y = state.fp[i].y;
				//newFp.comp = state.fp[i].c;
				newFp.angle = state.fp[i].a;
				flechasP.push(newFp);
				layer_flechas.addChild(newFp);
			}
			
			campo1.x = state.c1.x;
			campo1.y = state.c1.y;
			
			campo2.x = state.c2.x;
			campo2.y = state.c2.y;
		}
		
		private function reset():void
		{
			if (flechasG.length > 0) {
				for each (var itemG:Flechinha in flechasG) 
				{
					layer_flechas.removeChild(itemG);
				}
			}
			
			if (flechasP.length > 0) {
				for each (var itemP:Flechinha in flechasP) 
				{
					layer_flechas.removeChild(itemP);
				}
			}
			
			flechasG.splice(0, flechasG.length);
			flechasP.splice(0, flechasP.length);
			
			campo1.x = 350;
			campo1.y = 300;
			
			campo2.x = 350;
			campo2.y = 400;
		}
		
	}
	
}