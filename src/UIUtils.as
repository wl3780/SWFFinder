package
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	public class UIUtils
	{
		public function UIUtils()
		{
		}
		
		public static function createTextField(text:String=null):TextField
		{
			var txt:TextField = new TextField();
			if (text) {
				txt.text = text;
			}
			txt.textColor = 0x000000;
			return txt;
		}
		
		public static function createButton(label:String):Sprite
		{
			var button:Sprite = new Sprite();
			button.graphics.beginFill(0x666600);
			button.graphics.drawRect(0, 0, 40, 20);
			button.graphics.endFill();
			button.mouseChildren = false;
			button.buttonMode = true;
			
			var txt:TextField = createTextField(label);
			txt.autoSize = TextFieldAutoSize.CENTER;
			txt.x = (button.width - txt.width) >> 1;
			txt.y = (button.height - txt.height) >> 1;
			button.addChild(txt);
			return button;
		}
	}
}