package urgame;

import flambe.display.ImageSprite;
import flambe.display.Texture;
import flambe.math.Point;
import flambe.System;

/**
 * ...
 * @author ragbit
 */
class LineSprite extends ImageSprite
{

	public function new( l_point1 : Point, l_point2 : Point, l_color : Int, l_thickness : Int ) 
	{
		var point1 : Point = l_point1.x < l_point2.x? l_point1 : l_point2;
		var point2 : Point = l_point1.x < l_point2.x? l_point2 : l_point1;
		
		var maxX : Float = point1.x > point2.x? point1.x : point2.x;
		var maxY : Float = point1.y > point2.y? point1.y : point2.y;
		
		var texture : Texture = System.renderer.createTexture( Std.int( maxX ), Std.int( maxY ) );
		drawLine( texture, point1, point2, l_color, l_thickness );
		
		super(texture);
	}
	
	public static function drawLine( l_texture : Texture, l_point1 : Point, l_point2 : Point, l_color : Int, l_thickness : Int ) : Void {
		var targetPoint1 : Point = l_point1.x < l_point2.x? l_point1 : l_point2;
		var targetPoint2 : Point = l_point1.x < l_point2.x? l_point2 : l_point1;
		var point1 : Point = new Point( targetPoint1.x, targetPoint1.y );
		var point2 : Point = new Point( targetPoint2.x, targetPoint2.y );
		point2.x -= point1.x;
		point2.y -= point1.y;
		point1.x = 0;
		point1.y = 0;
		var distance = getDistance( point1, point2 );
		var rot = getAngle( point1, point2 );
		l_texture.graphics.save();
		l_texture.graphics.translate( targetPoint1.x, targetPoint1.y );
		l_texture.graphics.rotate( rot );
		l_texture.graphics.fillRect( l_color, 0, 0, distance, l_thickness );
		l_texture.graphics.restore();
	}
	
	public static function getDistance(startingPoint:Point, endingPoint:Point):Float
	{
		var d:Float = Math.pow((endingPoint.x - startingPoint.x), 2) + Math.pow((endingPoint.y - startingPoint.y), 2);
		d = Math.pow(d, 0.5);
		return d;
	}
	
	public static function getAngle(startingPoint:Point, endingPoint:Point):Float
	{
		var x:Float = endingPoint.x - startingPoint.x;
		var y:Float = endingPoint.y - startingPoint.y;
		var angle:Float = Math.atan2(y, x);
		angle = angle*(180 / Math.PI); //Convert to degrees
		return angle;
	}
}