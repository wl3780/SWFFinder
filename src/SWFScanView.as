package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.profiler.showRedrawRegions;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	
	public class SWFScanView extends Sprite
	{
		private const BORDER:int = 3;
		private const VW:int = 400;
		private const VH:int = 280;
		private const PAGE_NUM:int = 10;
		
		private var _datas:Array;
		private var _filter:String;
		private var _filtedDatas:Array;
		
		private var _container:Sprite;
		private var _btnFilter:Sprite;
		private var _btnAll:Sprite;
		private var _btnDrawrect:Sprite;
		private var _txtFilter:TextField;
		private var _pageItem:PageItem;
		
		private var _showRect:Boolean = false;
		
		public function SWFScanView()
		{
			super();
			_btnAll = UIUtils.createButton("全部");
			_btnAll.x = BORDER;
			_btnAll.y = BORDER;
			_btnAll.addEventListener(MouseEvent.CLICK, buttonClick);
			this.addChild(_btnAll);
			
			_btnFilter = UIUtils.createButton("过滤");
			_btnFilter.x = _btnAll.x + _btnAll.width + BORDER;
			_btnFilter.y = BORDER;
			_btnFilter.addEventListener(MouseEvent.CLICK, buttonClick);
			this.addChild(_btnFilter);
			
			_txtFilter = UIUtils.createTextField("*");
			_txtFilter.type = TextFieldType.INPUT;
			_txtFilter.border = true;
			_txtFilter.autoSize = TextFieldAutoSize.LEFT;
			_txtFilter.x = _btnFilter.x + _btnFilter.width + BORDER;
			_txtFilter.y = BORDER;
			this.addChild(_txtFilter);
			
			_btnDrawrect = UIUtils.createButton("重绘区域");
			_btnDrawrect.x = _txtFilter.x + _txtFilter.width + BORDER;
			_btnDrawrect.y = BORDER;
			_btnDrawrect.addEventListener(MouseEvent.CLICK, buttonClick);
			this.addChild(_btnDrawrect);
			
			_container = new Sprite();
			_container.x = BORDER;
			_container.y = 25;
			this.addChild(_container);
			
			_pageItem = new PageItem();
			_pageItem.x = (VW - _pageItem.width) >> 1;
			_pageItem.y = VH - _pageItem.height - BORDER;
			_pageItem.addEventListener(Event.CHANGE, pageChange);
			this.addChild(_pageItem);
			
			this.graphics.beginFill(0x666666, 0.6);
			this.graphics.drawRect(0, 0, VW, VH);
			this.graphics.endFill();
		}
		
		public function update(datas:Array):void
		{
			_datas = datas;
			filterLoadedItems(_filter);
		}
		
		private function filterLoadedItems(filter:String = null):void
		{
			_filter = filter;
			var datas:Array = [];
			if (!filter || filter == "*") {
				datas = _datas;
			} else {
				for each (var tmp:Object in _datas) {
					if (tmp.url && tmp.url.indexOf(filter) >= 0) {
						datas.push(tmp);
					}
				}
			}
			
			_filtedDatas = datas;
			_pageItem.initPage(PAGE_NUM, datas.length);
		}
		
		private function buttonClick(evt:MouseEvent):void
		{
			if (evt.target == _btnAll) {
				filterLoadedItems(null);
			} else if (evt.target == _btnFilter) {
				filterLoadedItems(_txtFilter.text);
			} else if (evt.target == _btnDrawrect) {
				_showRect = !_showRect;
				showRedrawRegions(_showRect);
			}
		}
		
		private function pageChange(evt:Event):void
		{
			_container.removeChildren();
			for (var i:int = 0; i < PAGE_NUM; i++) {
				var index:int = _pageItem.firstItemIndex + i;
				var info:Object = _filtedDatas[index];
				if (info == null) {
					break;
				}
				
				var cell:LoaderCell = new LoaderCell(info);
				cell.y = i * (BORDER + cell.height);
				_container.addChild(cell);
			}
		}
	}
}
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.net.FileReference;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;

class LoaderCell extends Sprite
{
	private var _info:Object;
	private var _button:Sprite;
	
	public function LoaderCell(info:Object)
	{
		_info = info;
		
		var txt:TextField = new TextField();
		txt.text = "保存";
		txt.textColor = 0x000000;
		txt.autoSize = TextFieldAutoSize.CENTER;
		
		_button = new Sprite();
		_button.graphics.beginFill(0x666600);
		_button.graphics.drawRect(0, 0, 40, 20);
		_button.graphics.endFill();
		this.addChild(_button);
		
		txt.x = (_button.width - txt.width) >> 1;
		txt.y = (_button.height - txt.height) >> 1;
		_button.addChild(txt);
		_button.mouseChildren = false;
		_button.buttonMode = true;
		_button.addEventListener(MouseEvent.CLICK, saveSWF);
		
		var url:TextField = new TextField();
		url.text = info.url ? info.url : "无法获取";
		url.autoSize = TextFieldAutoSize.LEFT;
		url.x = _button.width + 10;
		this.addChild(url);
	}
	
	private function saveSWF(evt:MouseEvent):void
	{
		var ref:FileReference = new FileReference();
		var arr:Array = _info.url.split("?");
		var fileName:String = String(arr[0]).split("/").pop();
		ref.save(_info.bytes, fileName);
	}
	
}