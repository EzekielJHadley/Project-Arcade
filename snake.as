package  
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	public class snake extends MovieClip
	{
		private var body:snake;

		public function snake(head:Boolean) 
		{
			if(head)
			{
				//start the head off in the middle of the stage
				x = 300;
				y = 250;
			}
			drawSegment();
		}
		
		//this actually draws the part, be it head or body
		private function drawSegment():void
		{
			var segment:Sprite = new Sprite();
			segment.graphics.lineStyle(1, 0x000000);
			segment.graphics.beginFill(0x999999);
			segment.graphics.drawRect(0,0,25,25);
			addChild(segment);
		}
		
		public function moveSnake(dx:int, dy:int):void
		{
			//i want to move the segments toward the head first
			moveSegment();
			//then update the heads possition
			//also loops it around the 
			x = (x + dx*25)%550;//loop from x=650 to zero
			y = (y + dy*25)%550;//loop from y=500 to zero
			if(x < 0)
			{
				x = 525;
			}
			if(y < 0)
			{
				y = 525;
			}
		}
		
		private function moveSegment():void
		{
			//first find where the body is relative to the part ahead of it
			var difX:int = x - body.x;
			var difY:int = y - body.y;
			
			//next check for parts behind the current one
			if(body.body != null)
			{
				body.moveSegment();
			}
			
			//recursivly, starting from the last body part to the first body part
			//update the possition and loop if need be
			body.x = (body.x + difX)%550;
			body.y = (body.y + difY)%550;
			if(body.x < 0)
			{
				body.x = 525;
			}
			if(body.y < 0)
			{
				body.y = 525;
			}
		}
		
		//this function adds a segment to the current body part
		public function addSegment():Sprite
		{
			body = new snake(false);
			trace("this object is at ("+x+", "+y+")");
			body.x = x;
			body.y = y;
			return body;
		}
		
		//this function searches through the snake looking for the last body part
		//then adds a segment to the end
		public function addNextSegment():Sprite
		{
			var temp:snake;
			temp = body;
			while(temp.body != null)
			{
				//while there is a part attached to the body go to the next part
				temp = temp.body;
			}
			return temp.addSegment();
		}
		
		public function collision(xIn:uint, yIn:uint, includeHead:Boolean):Boolean
		{
			var temp:snake = body;
			
			//check if there is a collision with the head
			if(xIn == x && yIn == y)
			{
				if(includeHead)
				{
					return true;
				}
			}
			
			//check the first body segment alone
			if(xIn == body.x && yIn == body.y)
			{
				return true;
			}
			
			//now go through each body segment and check for collision
			while(temp.body != null)
			{
				if(xIn == temp.body.x && yIn == temp.body.y)
				{
					return true;
				}
				temp = temp.body;
			}
			
			//if it gets here there is no collision
			return false;
		}

	}
	
}
