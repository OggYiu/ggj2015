package urgame;

import flambe.display.ImageSprite;
import flambe.display.Texture;
import flambe.System;

/**
 * ...
 * @author ragbit
 */
class CircleSprite extends ImageSprite
{

	public function new( l_radius : Int, l_color : Int ) 
	{
		var x0 : Int = l_radius;
		var y0 : Int = l_radius;
		var x : Int = l_radius;
		var y : Int = 0;
		var radiusError : Int = 1 - x;

		var texture : Texture = System.renderer.createTexture( l_radius * 2 + 1, l_radius * 2 + 1 );
		while( x >= y ) {
			texture.graphics.fillRect( l_color, x + x0, y + y0, 1, 1 );
			texture.graphics.fillRect( l_color, y + x0, x + y0, 1, 1 );
			texture.graphics.fillRect( l_color, -x + x0, y + y0, 1, 1 );
			texture.graphics.fillRect( l_color, -y + x0, x + y0, 1, 1 );
			texture.graphics.fillRect( l_color, -x + x0, -y + y0, 1, 1 );
			texture.graphics.fillRect( l_color, -y + x0, -x + y0, 1, 1 );
			texture.graphics.fillRect( l_color, x + x0, -y + y0, 1, 1 );
			texture.graphics.fillRect( l_color, y + x0, -x + y0, 1, 1 );
			y++;
			
			if ( radiusError < 0 ) {
				radiusError += 2 * y + 1;
			}
			else {
				x--;
				radiusError += 2 * ( y - x + 1 );
			}
		}
		
		super(texture);
	}
	
}