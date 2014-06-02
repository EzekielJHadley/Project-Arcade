package  
{
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import fl.motion.easing.Back;
	
	public class Nomino extends MovieClip
	{
		private var N:uint;
		private var currentRot:uint = 0;
		private var rightLimit:uint;
		private var bottomLimit:uint;
		private var shape:Array = new Array();
		private var image:Array = new Array();
		private var rightArray:Array = new Array();
		private var bottomArray:Array = new Array();

		public function Nomino(size:uint) 
		{
			N = size;
			x = 0;
			y = 0;
			
			initialize();
			
			addChild(image[0]);
			rightLimit = rightArray[0];
			bottomLimit = bottomArray[0];
			
			trace("final result");
			for( var k:uint=0; k<4; k++)
			{
				for(var i:uint=0; i<N; i++)
				{
					trace(shape[k][i]);
				}
				trace(rightArray[k]);
				trace(bottomArray[k]);
				trace("next rotation");
			}
			
		}
		
		private function initialize():void
		{
			//build the shape array
			for(var k:uint=0; k<4; k++)
			{
				shape[k] = new Array();
				for(var i:uint = 0; i<N; i++)
				{
					shape[k][i] = new Array();
					for(var j:uint = 0; j<N; j++)
					{
						shape[k][i][j] = 0;
					}
				}
			}
			
			//make the initial shape;
			while(sum(shape[0]) < N)
			{
				grow(Math.floor(N/2), Math.floor(N/2));
			}
			
			//create all possible rotations
			rotateInit();
			
			//now make all the possible shapes
			drawNomino();
			
			//determine how far right the shape goes
			findRightLimit();
			
			//determine how far down the shape goes
			findBottomLimit();
		}
		
		public function drawNomino():void
		{
			var i:uint = 0;
			var j:uint = 0;
			var shapeContainer:Sprite;
			
			for(var m:uint=0; m<4; m++)
			{
				shapeContainer = new Sprite();
				for(var k:uint=0; k<N; k++)
				{
					for(var l:uint=0; l<N; l++)
					{
						if(shape[m][k][l] == 1)
						{
							var item:Sprite = new Sprite();
							item.graphics.lineStyle(1, 0x990000);
							item.graphics.beginFill(0x008800);
							item.graphics.drawRect(0,0,25,25);//(l*25,k*25,25,25);
							item.x = l*25;
							item.y = k*25;
							trace("x, y= " + k*25 + ", " + l*25);
							item.graphics.endFill();
							shapeContainer.addChild(item);
						}
					}
				}
				trace(shapeContainer.getChildAt(0).x);
				trace(shapeContainer.getChildAt(1).x);
				trace(shapeContainer.getChildAt(2).x);
				trace(shapeContainer.getChildAt(3).x);
				image[m] = shapeContainer;
			}
		}
		
		public function rotateNomino():void
		{
			removeChild(image[currentRot]);
			currentRot = (currentRot + 1)%4;
			rightLimit = rightArray[currentRot];
			bottomLimit = bottomArray[currentRot];
			addChild(image[currentRot]);
			
		}
		
		private function grow(n:int, m:int):void
		{
			if(n>=0 && m>=0 && sum(shape[0])<N && n<N && m<N)
			{
				shape[0][n][m] = 1;
				for(var i=0; i<4; i++)
				{
					switch (Math.ceil(Math.random()*8))
					{
						case 1:
							grow(n+1, m);
							break;
						case 2:
							grow(n, m+1);
							break;
						case 3:
							grow(n-1, m);
							break;
						case 4:
							grow(n, m-1);
							break;
					}
				}
			}
		}
		
		private function sum(values:Array):uint
		{
			var tottal:uint = 0;
			for(var i=0; i<values.length; i++)
			{
				for(var j=0; j<values[i].length; j++)
				{
					tottal += values[i][j];
				}
			}
			
			return tottal;
		}
		
		public function moveNomino(dx:int, dy:int):void
		{
			x += dx*25;
			y += dy*25;
		}
		
		private function Align(initialShape:Array):Array
		{
			//first i will align the shape to the top of the array
			//then i will align it to the left side of the array
			var topAlign:Array = new Array();
			var leftAlign:Array = new Array();
			var refX,refY:int;
			//intialize the arrays
			for(var i:int = 0; i<N; i++)
			{
				topAlign[i] = new Array();
				leftAlign[i] = new Array();
				
				for(var j:int = 0; j<N; j++)
				{
					topAlign[i][j] = 0;
					leftAlign[i][j] = 0;
				}
			}
			
			/*trace("initialshape1");
			for( i=0; i<N; i++)
			{
				trace(initialShape[i]);
			}*/
			
			//now to actually align the shapes
			//align to the top first
			j=0;
			i=0;
			while(i<N && (initialShape[i][j] != 1))
			{
				while(j<N && initialShape[i][j] !=1)
				{
					//trace("("+j+", "+i+") = "+initialShape[i][j]);
					j++;
					//this is just searching through intialShape
					//looking for the reference to the first 1 from the top
				}
				if(j==N || initialShape[i][j] != 1)
				{
					i++;
					j=0;
				}
			}
			//trace("done");
			//trace("("+j+", "+(i)+") = "+initialShape[i][j]);
			//trace("Do i get here? 1");
			
			//save the verticle reference value
			refY = i;
			//trace(refY);
			
			//now cycle through and build the top aligned shape
			for(i=refY; i<N; i++)
			{
				for(j=0; j<N; j++)
				{
					topAlign[i-refY][j] = initialShape[i][j];
				}
			}
			//trace("final topAlign");
			/*for( i=0; i<N; i++)
			{
				trace(topAlign[i]);
			}*/
			//trace("Do i get here? 2");
			
			//now left align
			i=0;
			j=0;
			while(j<N && topAlign[i][j] != 1)
			{
				while(i<N && topAlign[i][j] != 1)
				{
					//trace("("+j+", "+i+") = "+topAlign[i][j]);
					i++;
					//now look for the first 1 from the left
				}
				if(i == N || topAlign[i][j] != 1)
				{
					j++;
					i=0;
				}
			}
			//trace("done");
			//trace("("+j+", "+i+") = "+topAlign[i][j]);
			//trace("Do i get here? 3");
			
			//save the left reference point
			refX = j;
			//and left align the shape
			for(j = refX; j<N; j++)
			{
				for(i = 0; i<N; i++)
				{
					leftAlign[i][j-refX] = topAlign[i][j];
				}
			}
			
			return leftAlign;
		}
		
		private function findRightLimit():void
		{
			var i,j:uint;
			//find the right limit for each rotation of the shape
			for(var k:uint=0; k<4; k++)
			{
				i=0;
				j=N-1;//start at the far right
				while(j>0 && shape[k][i][j] != 1)
				{
					while(i<N && shape[k][i][j] != 1)
					{
						//trace("("+j+", "+i+") = "+topAlign[i][j]);
						i++;
						//now look for the first 1 from the left
					}
					if(i == N || shape[k][i][j] != 1)
					{
						j--;
						i=0;
					}
				}
				rightArray[k] = j+1; //+1 to acount for the reference being top left corner
			}
		}
		
		private function findBottomLimit():void
		{
			var i,j:uint;
			//find the right limit for each rotation of the shape
			for(var k:uint=0; k<4; k++)
			{
				i=N-1;
				j=0;//start at the bottom
				while(i>0 && shape[k][i][j] != 1)
				{
					while(j<N && shape[k][i][j] != 1)
					{
						//trace("("+j+", "+i+") = "+topAlign[i][j]);
						j++;
						//now look for the first 1 from the left
					}
					if(i == N || shape[k][i][j] != 1)
					{
						i--;
						j=0;
					}
				}
				bottomArray[k] = i+1; //+1 to account for the reference being on the top left corner
			}
		}
		
		public function getRightLimit():uint
		{
			return rightLimit;
		}
		
		public function getNextRightLimit():uint
		{
			return rightArray[(currentRot+1)%4];
		}
		
		public function getBottomLimit():uint
		{
			return bottomLimit;
		}
		
		public function getNextBottomLimit():uint
		{
			return bottomArray[(currentRot+1)%4];
		}
		
		public function getRow():uint
		{
			return y/25;
		}
		
		public function getCol():uint
		{
			return x/25;
		}
		
		public function getImage():Sprite
		{
			return image[currentRot];
		}
		
		public function getShape():Array
		{
			return shape[currentRot];
		}
		
		public function getNextShape():Array
		{
			return shape[(currentRot+1)%4];
		}
		
		private function rotateInit():void
		{
			//first align the original
			shape[0] = Align(shape[0]);
			//start rotating the figure
			for(var k:uint=1; k<4; k++) //starting at 1 because 0 is the original
			{
				for(var i:uint=0; i<N; i++)
				{
					for(var j:uint=0; j<N; j++)
					{
						shape[k][i][(N-1)-j] = shape[k-1][j][i];
					}
				}
				//now alight the rotated figure
				shape[k] = Align(shape[k]);
			}
		}

	}
	
}
