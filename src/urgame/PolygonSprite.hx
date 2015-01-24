package urgame;
import flambe.display.ImageSprite;
import flambe.display.Texture;
import flambe.System;
import hxcollision.math.Vector;

/**
 * ...
 * @author ragbit
 */
class PolygonSprite extends ImageSprite
{
	public function new( l_vertices : Array<Vector>, l_color : Int, l_thickness : Int = 1 ) 
	{
		var i : Int = 0;
		var maxX : Float = 0;
		var maxY : Float = 0;
		while ( i < l_vertices.length ) {
			if ( l_vertices[i].x > maxX ) {
				maxX = l_vertices[i].x;
			}
			if ( l_vertices[i].y > maxY ) {
				maxY = l_vertices[i].y;
			}
			++i;
		}
		
		var texture : Texture = System.renderer.createTexture( Std.int( maxX + l_thickness ), Std.int( maxY + l_thickness ) );
		
		i = 0;
		while ( i < ( l_vertices.length - 1 ) ) {
			LineSprite.drawLine( texture, l_vertices[i], l_vertices[i + 1], l_color, l_thickness );
			++i;
		}
		LineSprite.drawLine( texture, l_vertices[0], l_vertices[l_vertices.length - 1], l_color, l_thickness );
		
		super( texture );
	}
}