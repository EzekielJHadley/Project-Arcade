package 
{
	
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.display.Sprite;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	
	public class SnakeGame extends MovieClip 
	{
		private var Snake:snake = new snake(true);
		private var horz:int = 0;
		private var vert:int = 0;
		private var snakeContainer:Sprite = new Sprite();
		private var fruit:Sprite;
		private var fruitCount:int = 0;
		private var timeCount:Timer = new Timer(500);
		
		public function SnakeGame() 
		{
			var grass:Sprite = new Sprite;
			grass.graphics.lineStyle(1, 0x009900);
			grass.graphics.beginFill(0x009900);
			grass.graphics.drawRect(0,0,550,550);
			grass.buttonMode = true;
			grass.useHandCursor = false;
			addChild(grass);
			
			addChild(snakeContainer);
			snakeContainer.addChild(Snake);
			snakeContainer.addChild(Snake.addSegment());
			snakeContainer.addChild(Snake.addNextSegment());
			snakeContainer.addChild(Snake.addNextSegment());
			snakeContainer.addChild(Snake.addNextSegment());
			placeFruit();
			this.addEventListener(KeyboardEvent.KEY_DOWN, onKDown);
			timeCount.addEventListener(TimerEvent.TIMER, onTime);
		}
		
		private function onKDown(e:KeyboardEvent):void
		{
			switch(e.keyCode)
			{
				case 37: //left
					horz = -1;
					vert = 0;
					break;
				case 38: //up
					horz = 0;
					vert = -1;
					break;
				case 39: //right
					horz = 1;
					vert = 0;
					break;
				case 40: //down
					horz = 0;
					vert = 1;
					break;
			}
			if(!timeCount.running)
			{
				timeCount.start();
			}
		}
		
		private function onTime(e:TimerEvent):void
		{
			Snake.moveSnake(horz, vert);
			checkHit();
		}
		
		private function placeFruit():void
		{
			var fruitX:uint = 0;
			var fruitY:uint = 0;
			//draw the fruit
			fruit = new Sprite();
			fruit.graphics.lineStyle(1, 0xff0000);
			fruit.graphics.beginFill(0xff5555);
			fruit.graphics.drawCircle(12.5,12.5, 12);
			fruit.graphics.endFill();
			do
			{
				fruitX = Math.floor(Math.random()*22)*25;
				fruitY = Math.floor(Math.random()*22)*25;
			}
			while(Snake.collision(fruitX, fruitY, true));
			
			fruit.x = fruitX;
			fruit.y = fruitY;
			addChild(fruit);
		}
		
		private function eatFruit():void
		{
			removeChild(fruit);
			snakeContainer.addChild(Snake.addNextSegment());
			fruitCount ++;
			if(fruitCount%10 == 0)
			{
				trace("Yo i get here");
				timeCount.removeEventListener(TimerEvent.TIMER, onTime);
				timeCount = new Timer(100);
				timeCount.addEventListener(TimerEvent.TIMER, onTime);
				timeCount.start();
			}
			placeFruit();
		}
		
		
		private function checkHit():void
		{
			if(Snake.collision(Snake.x, Snake.y, false))
			{
				trace("Game Over");
			}
			
			if(Snake.collision(fruit.x, fruit.y, true))
			{
				trace("eaten fruit");
				eatFruit();
			}
		}
	}
	
}
