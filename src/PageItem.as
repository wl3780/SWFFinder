package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	public class PageItem extends Sprite
	{
		private var _btnPrev:Sprite;
		private var _btnNext:Sprite;
		private var _txtPage:TextField;
		
		private var _onePageNum:int;
		private var _totalNum:int;
		
		private var _totalPage:int;
		private var _currPage:int;
		
		public function PageItem()
		{
			super();
			_btnPrev = UIUtils.createButton("上一页");
			_btnPrev.addEventListener(MouseEvent.CLICK, clickButton);
			this.addChild(_btnPrev);
			
			_txtPage = UIUtils.createTextField("100/100");
			_txtPage.autoSize = TextFieldAutoSize.CENTER;
			_txtPage.selectable = false;
			_txtPage.x = _btnPrev.x + _btnPrev.width;
			this.addChild(_txtPage);
			
			_btnNext = UIUtils.createButton("下一页");
			_btnNext.x = _txtPage.x + _txtPage.width;
			_btnNext.addEventListener(MouseEvent.CLICK, clickButton);
			this.addChild(_btnNext);
		}
		
		public function initPage(onePageNum:int, totalNum:int):void
		{
			_onePageNum = onePageNum;
			_totalNum = totalNum;
			
			_totalPage = Math.ceil(totalNum / onePageNum);
			changePage(_currPage, true);
		}
		
		public function changePage(page:int, force:Boolean = false):void
		{
			if (page < 0) {
				page = 0;
			} else if (page > _totalPage - 1) {
				page = _totalPage - 1;
			}
			
			if (force || _currPage != page) {
				_currPage = page;
				_txtPage.text = (_currPage + 1) + "/" + _totalPage;
				this.dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		public function get firstItemIndex():int
		{
			return _currPage * _onePageNum;
		}
		
		private function clickButton(evt:MouseEvent):void
		{
			if (evt.target == _btnPrev) 
			{
				changePage(_currPage - 1);
			}
			else if (evt.target == _btnNext) 
			{
				changePage(_currPage + 1);
			}
		}
	}
}