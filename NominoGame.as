package  
{
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	
	public class NominoGame extends MovieClip 
	{
		private const N:uint = 4;
		private var test:Nomino = new Nomino(N);
		private var playField:Sprite = new Sprite();
		private var timeCount:Timer = new Timer(500);
		private var playArray:Array = new Array();
		private var fullRow:Array = new Array();
		
		public function NominoGame() 
		{
			playField.graphics.lineStyle(0, 0x000000);
			playField.graphics.drawRect(0, 0, 10*25, 20*25);
			
			for(var i:uint = 0; i<20; i++)
			{
				playArray[i] = new Array();
				fullRow[i] = new Sprite(); //initialize the rows to be removed as Sprites
				addChild(fullRow[i]);
				for(var j:uint = 0; j<10; j++)
				{
					playArray[i][j] = 0;
				}
			}
			
			addChild(playField);
			addChild(test)
			this.addEventListener(KeyboardEvent.KEY_DOWN, onKDown);
			
		}
	
		private function onKDown(e:KeyboardEvent):void
		{
			switch(e.keyCode)
			{
				case 37: //left
					trace("left");
					if(collision(-1,0, false)) //check that where it will be is with in bounds
					{
						test.moveNomino(-1,0);
					}
					break;
				case 38: //up
					trace("up");
					if(collision(0,0, true))      //(test.getCol() <= (10 - test.getNextRightLimit())) && (test.getRow() <= (20 - test.getNextBottomLimit())))
					{
						test.rotateNomino();
					}
					break;
				case 39: //right
					trace("right");
					if(collision(1,0, false)) //check that where it will be is with in bounds
					{
						test.moveNomino(1,0);
					}
					break;
				case 40: //down
					trace("down");
					if(collision(0,1,false))
					{
						test.moveNomino(0,1);
					}
					else
					{
						placeNomino();
					}
					break;
				case 87:
					test.moveNomino(0,-1);
					break;
			}
		}
		
		private function placeNomino():void
		{
			var placedNomino:Sprite = new Sprite();
			var NominoShape:Array;
			var row:uint;
			placedNomino = test.getImage();
			NominoShape = test.getShape();
			//now add each square indavidualy to the stage
			for(var k:uint=0; k<N; k++)
			{
				//i need to reference only the 0th index because
				//each time i addChild it removes it from placedNomino
				placedNomino.getChildAt(0).x += test.getCol()*25;
				placedNomino.getChildAt(0).y += test.getRow()*25;
				row = placedNomino.getChildAt(0).y/25;
				fullRow[row].addChild(placedNomino.getChildAt(0));
			}
			//now add the Nomino to the Array of tiles in play
			for(var i:uint = 0; i<test.getBottomLimit(); i++)
			{
				for(var j:uint = 0; j<test.getRightLimit(); j++)
				{
					playArray[i+test.getRow()][j+test.getCol()] = NominoShape[i][j];
				}
			}
			test = new Nomino(N);
			addChild(test);
			
			//now check if there is a full row and remove it
			for(i=0; i<20; i++)
			{
				if(fullRow[i].numChildren == 10)
				{
					removeRow(i);
					moveRowsAbove(i);
				}
			}
		}
		
		private function removeRow(row:uint):void
		{
			for(var j:uint=0; j<10; j++)
			{
				fullRow[row].removeChildAt(0); 	//removes all the sprites in that row
				playArray[row][j] = 0;			//removes that row of values
			}
		}
		
		private function moveRowsAbove(row:uint):void
		{
			//create a variable to hold the number of items in the previous row
			var numPrevRow:uint;
			
			//now i need to step through the rows going up to the zeroth row
			for(var i:uint=row-1; i>0; i--)
			{
				numPrevRow = fullRow[i].numChildren;
				for(var j:uint = 0; j<numPrevRow; j++)
				{
					trace("j = " + j);
					fullRow[i].getChildAt(0).y += 25; //first move each element down
					fullRow[i+1].addChild(fullRow[i].getChildAt(0)); //then move it to the next row holder
				}
				//now change the play array for that row
				for(j = 0; j<10; j++)
				{
					playArray[i+1][j] = playArray[i][j];
					playArray[i][j] = 0;
				}
			}
		}
		
		private function collision(dx:int, dy:int, isRot:Boolean):Boolean
		{
			var NominoShape:Array;
			var row:int = dy+test.getRow();
			var col:int = dx+test.getCol();
			var bottomLimit, rightLimit:uint;
			
			if(isRot)
			{
				NominoShape = test.getNextShape();
				bottomLimit = test.getNextBottomLimit();
				rightLimit = test.getNextRightLimit();
			}
			else
			{
				NominoShape = test.getShape();
				bottomLimit = test.getBottomLimit();
				rightLimit = test.getRightLimit();
				
			}
			
			//check the left boundary
			if(col < 0)
			{
				return false;
			}
			//check the right boundary
			if(col > (10 - rightLimit))
			{
				return false;
			}
			//check for the floor
			if(row > 20-bottomLimit)
			{
				return false;
			}
			
			for(var i:uint=0; i<bottomLimit; i++)
			{
				for(var j:uint=0; j<rightLimit; j++)
				{
					if(NominoShape[i][j]==1 && playArray[i+row][j+col]==1)
					{
						return false;
					}
				}
			}
			return true;
		}
	}
	
}
