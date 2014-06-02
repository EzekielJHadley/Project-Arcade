package  
{
	
	import flash.display.MovieClip;	
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	
	public class Main extends MovieClip 
	{
		private var menu:Sprite = new Sprite();
		private var counter:int = 0;
		private var gameContainer:Sprite = null;
		private var Snake:SnakeGame;
		private var Nomino:NominoGame;
		
		public function Main() 
		{
			stage.stageFocusRect = false;
			makeButton("Snake", 0, 0);
			makeButton("Nomino", 100, 0);
			addChild(menu);
			
			//set up a quite key
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKDown);
		}
		
		private function onKDown(e:KeyboardEvent):void
		{
			if(e.keyCode == 81)
			{
				if(gameContainer != null)
				{
					removeChild(gameContainer);
					gameContainer = null;
					addChild(menu);
				}
			}
		}
		
		public function makeButton(buttonName:String, xCoord:uint, yCoord:uint):void
		{
			var button:Sprite = new Sprite();
			var textBox:TextField = new TextField();
			
			//button parameters
			button.graphics.lineStyle(1, 0x000000);
			button.graphics.beginFill(0xff0000);
			button.graphics.drawRect(xCoord, yCoord, 50, 100);
			button.graphics.endFill();
			
			// now name the button
			textBox.text = buttonName;
			textBox.selectable = false;
			textBox.autoSize = TextFieldAutoSize.CENTER;
			textBox.x = 25 + xCoord - Math.floor(textBox.width/2);
			textBox.y = 25 + yCoord - Math.floor(textBox.height/2);
			//now add the text to the button
			button.addChild(textBox);
			
			button.buttonMode = true;
			button.addEventListener(MouseEvent.CLICK, onClick);
			button.name = buttonName;
			
			menu.addChild(button);
		}
		
		private function onClick(e:MouseEvent):void
		{
			gameContainer = new Sprite();
			removeChild(menu);
			if( e.currentTarget.name == "Snake")
			{
				Snake = new SnakeGame();
				addChild(gameContainer);
				gameContainer.addChild(Snake);
				stage.focus = Snake;
			}
			if(e.currentTarget.name == "Nomino")
			{
				Nomino = new NominoGame();
				addChild(gameContainer);
				gameContainer.addChild(Nomino);
				stage.focus = Nomino;
			}
		}
		
	}
	
}
