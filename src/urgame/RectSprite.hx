package urgame ;

import flambe.display.ImageSprite;
import flambe.display.Texture;
import flambe.System;

/**
 * ...
 * @author ragbit
 */
class RectSprite extends ImageSprite
{

	public function new( l_width : Int, l_height : Int, l_color : Int ) 
	{
		var texture : Texture = System.renderer.createTexture( l_width, l_height );
		texture.graphics.fillRect( l_color, 0, 0, l_width, l_height );
		super(texture);	
	}
	
}