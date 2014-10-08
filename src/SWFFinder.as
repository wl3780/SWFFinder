package
{
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	public class SWFFinder extends Sprite
	{
		private var _button:Sprite;
		private var _view:SWFScanView;
		
		private var _loaders:Array = [];
		
		public function SWFFinder()
		{
			super();
			if (this.stage) {
				init();
			} else {
				this.addEventListener(Event.ADDED_TO_STAGE, init);
			}
		}
		
		private function init(evt:Event = null):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			
			addEventListener("allComplete", allComplete);
			if (_button == null) {
				var txt:TextField = new TextField();
				txt.text = "点击取样";
				txt.textColor = 0x000000;
				txt.autoSize = TextFieldAutoSize.CENTER;
				
				_button = new Sprite();
				_button.graphics.beginFill(0x666600);
				_button.graphics.drawRect(0, 0, 60, 30);
				_button.graphics.endFill();
				
				txt.x = (_button.width - txt.width) >> 1;
				txt.y = (_button.height - txt.height) >> 1;
				_button.addChild(txt);
				_button.mouseChildren = false;
				_button.buttonMode = true;
				
				this.stage.addChild(_button);
				_button.addEventListener(MouseEvent.CLICK, scanSWF);
			}
		}
		
		private function allComplete(evt:Event):void
		{
			if (_view == null) {
				_view = new SWFScanView();
				_view.y = 50;
			}
			
			var info:LoaderInfo = evt.target as LoaderInfo;
			trace("load some:" + info.url);
			_loaders.push({url:info.url, bytes:info.bytes});
			_view.update(_loaders);
		}
		
		private function scanSWF(evt:MouseEvent):void
		{
			if (_view.parent) {
				_button.parent.removeChild(_view);
			} else {
				_button.parent.addChild(_view);
			}
		}
	}
}