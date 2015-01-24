package urgame ;
import flambe.System;
import format.abc.Data.IName;

/**
 * ...
 * @author ragbit
 */
class Global
{
	public static var MARGIN_SPLIT : Int = 50;
	public static var MARGIN_TOP : Int = 50;
	public static var MARGIN_BOTTOM : Int = 50;
	public static var MARGIN_SIDE : Int = 50;
	
	public function new() 
	{
	}
	
	public static function getPageWidth() : Int {
		return Std.int( ( System.stage.width - ( Global.MARGIN_SIDE * 2 ) - Global.MARGIN_SPLIT ) / 2 );
	}
	
	public static function getPageHeight() : Int {
		return ( System.stage.height - Global.MARGIN_TOP - Global.MARGIN_BOTTOM );
	}
	
	public static function getPage1X( v : Float = 0 ) : Float {
		return v + Global.MARGIN_SIDE;
	}
	
	public static function getPage2X( v : Float = 0 ) : Float {
		return v + getPageWidth() + Global.MARGIN_SIDE + Global.MARGIN_SPLIT;
	}
	
	public static function getPageY( v : Float = 0 ) : Float {
		return v + Global.MARGIN_TOP;
	}
	
	public static function getPage1Y( v : Float = 0 ) : Float {
		return getPageY( v );
	}
	
	public static function getPage2Y( v : Float = 0 ) : Float {
		return getPageY( v );
	}
		
	public inline static function radToDeg(rad:Float):Float
	{
		return 180 / Math.PI * rad;
	}
	
	public inline static function degToRad(deg:Float):Float
	{
		return Math.PI / 180 * deg;
	}
	
	public inline static function clamp(value:Float, min:Float, max:Float):Float
	{
		if (value < min)
			return min;
		else if (value > max)
			return max;
		else
			return value;
	}
		

	public static function floatToStringPrecision(n:Float, prec:Int){
	  n = Math.round(n * Math.pow(10, prec));
	  var str = ''+n;
	  var len = str.length;
	  if(len <= prec){
		while(len < prec){
		  str = '0'+str;
		  len++;
		}
		return '0.'+str;
	  }
	  else{
		return str.substr(0, str.length-prec) + '.'+str.substr(str.length-prec);
	  }
	}
}	