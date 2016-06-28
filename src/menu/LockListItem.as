package menu 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	
	/**
	 * List item specialized for the needs of a menu that uses graphics instead of text and can "toggle" the items, such as locking them.
	 * @author 
	 */
	public class LockListItem extends IconListItem 
	{
		protected var _lockedColor:uint = 0xeeeeee;
		protected var _unlocked:Boolean = true;
		public function LockListItem(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, data:Object=null) 
		{
			super(parent, xpos, ypos, data);
		}
		
		/**
		 * Draws the visual ui of the component.
		 */
		public override function draw() : void
		{
			super.draw();
			//graphics.clear();
			if (_data)
			{
				var icon:DisplayObject = _data["icon"] as DisplayObject;
				if (icon is DisplayObject)
				{
					//var dataDispObj:DisplayObject = _data as DisplayObject;
					//var unlocked:Boolean = _data.unlocked;
					if (_data.unlocked)
					{
						icon.alpha = 1;
					}
					else
					{
						icon.alpha = 0.5;
					}
				}
			}
			
			/*graphics.clear();
			
			if(_selected)
			{
				graphics.beginFill(_selectedColor);
			}
			else if(_mouseOver)
			{
				graphics.beginFill(_rolloverColor);
			}
			else
			{
				graphics.beginFill(_defaultColor);
			}
			graphics.drawRect(0, 0, width, height);
			graphics.endFill();*/
		}
		
		public override function set data(value:Object):void
		{
			super.data = value;
			if (_data != null && "unlocked" in value)
			{
				_data.unlocked = value.unlocked;
			}
		}
		
		/*public function SetUnlocked(value:Boolean):void
		{
			data.unlocked = value;
		}*/
		
		/**
		 * Sets/gets whether or not this item is locked.
		 */
		public function set unlocked(value:Boolean):void
		{
			_data.unlocked = _unlocked = value;
			invalidate();
		}
		public function get unlocked():Boolean
		{
			return _unlocked;
		}
		
		/**
		 * Sets/gets the locked background color of list items.
		 */
		public function set lockedColor(value:uint):void
		{
			_lockedColor = value;
			invalidate();
		}
		public function get lockedColor():uint
		{
			return _lockedColor;
		}
	}

}