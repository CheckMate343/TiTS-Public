package classes.UIComponents.SideBarComponents 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.AntiAliasType;
	import classes.UIComponents.UIStyleSettings;
	
	/**
	 * ...
	 * @author Gedan
	 */
	public class StatBar extends Sprite
	{
		public static const MODE_BIG:String = "BIG";
		public static const MODE_SMALL:String = "SMALL";
		public static const MODE_NOBAR:String = "NOBAR";
		
		private var _desiredMode:String;
		
		public var highBad:Boolean = false;
		
		private var _values:TextField;
		private var _capBack:TextField;
		private var _capFront:TextField;
		
		private var _progressBar:Sprite;
		private var _maskingBar:Sprite;
		
		private var _tMin:Number = 0;
		private var _tMax:Number = 100;
		private var _tCurrent:Number = 0;
		private var _tGoal:Number = 0;
		
		private var _barFrames:Number = 1.0 / (1.5 * 24);
		private var _glowFrames:Number = 1.0 / (3.0 * 24);
		private var _valueGlow:GlowFilter;
		
		private var _tickGlow:Boolean = false;
		
		public function set caption(v:String):void
		{
			_capBack.text = v;
			_capFront.text = v;
		}
		
		public function set value(v:*):void
		{
			if (!(v is String)) _values.text = String(v);
			else _values.text = v;
		}
		
		public function disableBar():void
		{
			if (_progressBar) _progressBar.visible = false;
			if (_maskingBar) _maskingBar.visible = false;
			if (_capFront) _capFront.visible = false;
		}
		
		public function StatBar(mode:String) 
		{
			_desiredMode = mode;
			
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			Build();
			addEventListener(Event.ENTER_FRAME, update);
		}
		
		private function update(e:Event):void
		{
			if (visible == false) return;
			
			if (_valueGlow.alpha > 0 && _tickGlow) 
			{
				_valueGlow.alpha -= _glowFrames;
				_values.filters = [_valueGlow]
			}
			
			var cScale:Number = _progressBar.scaleX;
			var tScale:Number;
			if (_tGoal == 0)
			{
				tScale = 0;
			}
			else
			{
				tScale = 1.0 / _tMax;
				tScale *= _tGoal;
			}
			
			if (cScale > tScale)
			{
				cScale -= _barFrames;
				
				if (cScale < tScale) cScale = tScale;
			}
			else if (cScale < tScale)
			{
				cScale += _barFrames;
				
				if (cScale > tScale) cScale = tScale;
			}
			
			//trace("Goal:", _tGoal, "Max:", _tMax, "Scale:", cScale);
			
			_progressBar.scaleX = cScale;
			_maskingBar.scaleX = cScale;
			
			value = String(Math.round(_tGoal * cScale));
		}
		
		private function Build():void
		{
			_valueGlow = new GlowFilter();
			_valueGlow.blurX = 10;
			_valueGlow.blurY = 10;
			_valueGlow.strength = 2;
			_valueGlow.alpha = 0;
			_valueGlow.color = 0xFF0000;
			
			if (_desiredMode == "BIG")
			{
				BuildBig();
			}
			else
			{
				BuildSmall();
				
				if (_desiredMode == "NOBAR")
				{
					disableBar();
				}
			}
			
			_progressBar.scaleX = 0;
			_maskingBar.scaleX = 0;
		}
		
		private function BuildBig():void
		{
			_capBack = new TextField();
			_capBack.y = -11;
			_capBack.width = 137;
			_capBack.height = 44;
			_capBack.defaultTextFormat = UIStyleSettings.gBigStatBarBackTextFormat;
			_capBack.embedFonts = true;
			_capBack.antiAliasType = AntiAliasType.ADVANCED;
			_capBack.text = "HP";
			this.addChild(_capBack);
			
			_progressBar = new Sprite();
			_progressBar.graphics.beginFill(UIStyleSettings.gHighlightColour);
			_progressBar.graphics.drawRect(0, 0, 179, 35);
			_progressBar.graphics.endFill();
			this.addChild(_progressBar);
			
			_maskingBar = new Sprite();
			_maskingBar.graphics.beginFill(0xFF0000);
			_maskingBar.graphics.drawRect(0, 0, 179, 35);
			_maskingBar.graphics.endFill();
			this.addChild(_maskingBar);
			
			_capFront = new TextField();
			_capFront.y = -11;
			_capFront.width = 137;
			_capFront.height = 44;
			_capFront.defaultTextFormat = UIStyleSettings.gBigStatBarFrontTextFormat;
			_capFront.embedFonts = true;
			_capFront.antiAliasType = AntiAliasType.ADVANCED;
			_capFront.text = "HP";
			this.addChild(_capFront);
			
			_capFront.mask = _maskingBar;
			
			_values = new TextField();
			_values.width = 164;
			_values.height = 40;
			_values.x = 15;
			_values.y = -3;
			_values.defaultTextFormat = UIStyleSettings.gBigStatBarValueFormat;
			_values.embedFonts = true;
			_values.antiAliasType = AntiAliasType.ADVANCED;
			_values.text = "2047";
			_values.filters = [_valueGlow];
			this.addChild(_values);
		}
		
		private function BuildSmall():void
		{
			_capBack = new TextField();
			_capBack.y = -8;
			_capBack.width = 137;
			_capBack.height = 41;
			_capBack.defaultTextFormat = UIStyleSettings.gSmallStatBarBackTextFormat;
			_capBack.embedFonts = true;
			_capBack.antiAliasType = AntiAliasType.ADVANCED;
			_capBack.text = "HP";
			_capBack.mouseEnabled = false;
			_capBack.mouseWheelEnabled = false;
			this.addChild(_capBack);
			
			_progressBar = new Sprite();
			_progressBar.graphics.beginFill(UIStyleSettings.gHighlightColour);
			_progressBar.graphics.drawRect(0, 0, 179, 24);
			_progressBar.graphics.endFill();
			this.addChild(_progressBar);
			
			_maskingBar = new Sprite();
			_maskingBar.graphics.beginFill(0xFF0000);
			_maskingBar.graphics.drawRect(0, 0, 179, 24);
			_maskingBar.graphics.endFill();
			this.addChild(_maskingBar);
			
			_capFront = new TextField();
			_capFront.y = -8;
			_capFront.width = 137;
			_capFront.height = 41;
			_capFront.defaultTextFormat = UIStyleSettings.gSmallStatBarFrontTextFormat;
			_capFront.embedFonts = true;
			_capFront.antiAliasType = AntiAliasType.ADVANCED;
			_capFront.text = "HP";
			_capFront.mouseEnabled = false;
			_capFront.mouseWheelEnabled = false;
			this.addChild(_capFront);
			
			_capFront.mask = _maskingBar;
			
			_values = new TextField();
			_values.width = 164;
			_values.height = 30;
			_values.x = 15;
			_values.y = -3;
			_values.defaultTextFormat = UIStyleSettings.gSmallStatBarValueFormat;
			_values.embedFonts = true;
			_values.antiAliasType = AntiAliasType.ADVANCED;
			_values.text = "2047";
			_values.filters = [_valueGlow];
			_values.mouseEnabled = false;
			_values.mouseWheelEnabled = false;
			this.addChild(_values);
		}
		
		public function clearGlow():void
		{
			if (_tickGlow == false) 
			{
				_tickGlow = true;
			}
		}
		
		public function removeGlow():void
		{
			_valueGlow.alpha = 0;
			_values.filters = [_valueGlow];
		}
		
		public function resetBar():void
		{
			_progressBar.scaleX = 0;
			_maskingBar.scaleX = 0;
			
			_tGoal = 0;
			_tMax = 100;
			_valueGlow.alpha = 0;
			_values.filters = [_valueGlow];
		}
		
		public function setMax(arg:Number):void
		{
			_tMax = arg;
			
			if (isNaN(_tMax))
			{
				disableBar();
			}
		}
		
		public function setGoal(arg:Number):void
		{
			if (arg != _tGoal)
			{
				if (arg < _tGoal)
				{
					if (!highBad) _valueGlow.color = 0xCC3300;
					else _valueGlow.color = 0x0099FF;
				}
				else
				{
					if (!highBad) _valueGlow.color = 0x0099FF;
					else _valueGlow.color = 0xCC3300;
				}
				
				_tGoal = arg;
				_valueGlow.alpha = 1.0;
				_values.filters = [_valueGlow];
			}
		}
		
		public function getGoal():Number
		{
			return _tGoal;
		}
		
		public function updateBar(newValue:*, max:Number = Number.NaN):void
		{
			setMax(max);
			
			trace("Goal:", _tGoal, "Value:", newValue);
			
			if (_tGoal != newValue)
			{
				setGoal(newValue);
				_tickGlow = false;
			}
		}
	}

}