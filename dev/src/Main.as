package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	
	/**
	 * ...
	 * @author Alexandre
	 */
	public class Main extends Sprite 
	{
		private var layer_moldura:Sprite = new Sprite();
		
		private var flechaGravidade:Flechinha = new Flechinha();
		private var flechaPressao:Flechinha = new Flechinha();
		
		private var campo1:Campo = new Campo("campo1");
		private var campo2:Campo = new Campo("campo2");
		
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
			
			flechaGravidade.x = 50;
			flechaGravidade.y = 400;
			
			flechaPressao.x = 200;
			flechaPressao.y = 400;
			
			addChild(flechaGravidade);
			addChild(flechaPressao);
			
			campo1.x = 350;
			campo1.y = 300;
			
			campo2.x = 350;
			campo2.y = 400;
			
			addChild(campo1);
			addChild(campo2);
			
			layer_moldura.graphics.lineStyle(4, 0xC0C0C0);
			layer_moldura.graphics.lineTo(600, 0);
			layer_moldura.graphics.lineTo(600, 500);
			layer_moldura.graphics.lineTo(0, 500);
			layer_moldura.graphics.lineTo(0, 0);
			addChild(layer_moldura);
			
			
			stage.addEventListener(KeyboardEvent.KEY_UP, keyboardHandler);
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
			
			state.f1 = new Object();
			state.f1.x = flechaGravidade.x;
			state.f1.y = flechaGravidade.y;
			state.f1.c = flechaGravidade.comp;
			state.f1.a = flechaGravidade.angle;
			
			state.f2 = new Object();
			state.f2.x = flechaPressao.x;
			state.f2.y = flechaPressao.y;
			state.f2.c = flechaPressao.comp;
			state.f2.a = flechaPressao.angle;
			
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
			flechaGravidade.x = state.f1.x;
			flechaGravidade.y = state.f1.y;
			flechaGravidade.comp = state.f1.c;
			flechaGravidade.angle = state.f1.a;
			
			flechaPressao.x = state.f2.x;
			flechaPressao.y = state.f2.y;
			flechaPressao.comp = state.f2.c;
			flechaPressao.angle = state.f2.a;
			
			campo1.x = state.c1.x;
			campo1.y = state.c1.y;
			
			campo2.x = state.c2.x;
			campo2.y = state.c2.y;
		}
		
	}
	
}