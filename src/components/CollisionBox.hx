package components;

import flambe.Component;
import flambe.display.Sprite;
import flambe.util.Signal1;
import hxcollision.math.Vector;
import hxcollision.shapes.Circle;
import hxcollision.shapes.Polygon;
import hxcollision.shapes.Shape;
import urgame.CircleSprite;
import urgame.Kernel;
import urgame.PolygonSprite;
import urgame.RectSprite;

/**
 * ...
 * @author ragbit
 */
class CollisionBox extends Component
{
	public var x( get_x, set_x ) : Float;
	public var y( get_y, set_y ) : Float;
	public var offsetX( default, default ) : Float = 0;
	public var offsetY( default, default ) : Float = 0;
    public var collide(default, null) : Signal1<CollisionBox>;
	public var type( default, null ) : CollisionBoxType;
	//private var rectWidth( default, null ) : Float;
	//private var rectHeight( default, null ) : Float;
	//private var radius( default, null ) : Float;
	public var sprite( default, null ) : Sprite;
	
	private var shape_ : Shape = null;
	private var radius_ : Float = 0;
	
	public function new() {
		super();
		
		this.collide = new Signal1<CollisionBox>();
	}
	
	public function createRect( l_x : Float, l_y : Float, l_width : Float, l_height : Float ) : Void {
		var startX : Int = 0;
		var startY : Int = 0;
		
		this.type = CollisionBoxType.rect;
		
		shape_ = new Polygon( l_x, l_y, [	new Vector( startX, startY ),
											new Vector( startX + l_width, startY ),
											new Vector( startX + l_width, startY + l_height ),
											new Vector( startX, startY + l_height ) ] );
											
		this.sprite = new RectSprite( Std.int( l_width ), Std.int( l_height ), 0xFF0000 );
		this.sprite.setAlpha( 0.5 );
		
		onShapeCreated();
	}
	
	public function createCircle( l_x : Float, l_y : Float, l_radius : Float ) : Void {
		shape_ = new Circle( l_x, l_y, l_radius );
		
		this.type = CollisionBoxType.circle;
		
		this.sprite = new CircleSprite( Std.int( l_radius ), 0xFF0000 );
		//this.sprite.setAlpha( 0.5 );
		
		radius_ = l_radius;
		
		onShapeCreated();
	}
	
	public function createPolygon( l_x : Float, l_y : Float, l_vertices : Array<Vector> ) : Void {
		shape_ = new Polygon( l_x, l_y, l_vertices );
		
		this.type = CollisionBoxType.polygon;
		
		this.sprite = new PolygonSprite( l_vertices, 0xFF0000 );
		this.sprite.setAlpha( 0.5 );
		
		onShapeCreated();
	}
	
	private function onShapeCreated() : Void {
		shape_.data = this;
		
		Kernel.instance().collisionMgr.add( shape_ );
	}
	
	//public function onCollide( collisionBox : CollisionBox ) : Void {
		//Console.log( this + " colliding with " + collisionBox );
	//}
	
	override public function dispose() {
		super.dispose();
		
		if ( this.sprite != null ) {
			this.sprite.owner.dispose();
		}
		Kernel.instance().collisionMgr.remove( shape_ );
		
		//trace( "destroy collision box" );
	}
	
	private function get_x() : Float {
		return this.shape_.x;
	}
	
	private function set_x( v : Float ) : Float {
		var mod : Float = this.type == CollisionBoxType.circle? radius_ : 0;
		//var mod : Float = 0;
		if ( this.sprite != null ) {
			this.sprite.x._ = v;
		}
		this.shape_.x = v + mod;
		return v;
	}
	
	private function get_y() : Float {
		return this.shape_.y;
	}
	
	private function set_y( v : Float ) : Float {
		var mod : Float = this.type == CollisionBoxType.circle? radius_ : 0;
		//var mod : Float = 0;
		if ( this.sprite != null ) {
			this.sprite.y._ = v;
		}
		return ( this.shape_.y = v + mod );
	}
}