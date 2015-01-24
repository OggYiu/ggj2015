package urgame;

import flambe.display.ImageSprite;
import flambe.display.Texture;
import flambe.System;
import urgame.ColorConverter.RGB;

/**
 * ...
 * @author ragbit
 */
class GradientSprite extends ImageSprite
{
	public function new( l_width : Int, l_height : Int, l_startColor : Int, l_endColor : Int ) 
	{
		var startRGB : RGB = ColorConverter.toRGB( l_startColor );
		//var endRGB : RGB = ColorConverter.toRGB( l_endColor );
		var texture : Texture = System.renderer.createTexture( l_width, l_height );
		//var i : Int = 0;
		//var step : Int = Std.int( ( l_endColor - l_startColor ) / l_height );
		//Console.log( "step: " + step );
		//var color : Int = l_startColor;
		//while ( i < l_height ) {
			//texture.graphics.fillRect( color, 0, i, l_width, 1 );
			//color += step;
			//++i;
		//}
		super( texture );
	}
	
}