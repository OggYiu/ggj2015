package components;

import flambe.Component;
import flambe.display.Sprite;
import flambe.util.Signal1;
import flambe.util.Signal2;
import hxcollision.CollisionData;
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
	//public var offsetX( default, default ) : Float = 0;
	//public var offsetY( default, default ) : Float = 0;
	public var ox( default, default ) : Float = 0;
	public var oy( default, default ) : Float = 0;
    public var collide(default, null) : Signal2<CollisionBox, CollisionData>;
	public var type( default, null ) : CollisionBoxType;
	//private var rectWidth( default, null ) : Float;
	//private var rectHeight( default, null ) : Float;
	//private var radius( default, null ) : Float;
	public var sprite( default, null ) : Sprite;
	public var rotate( get_rotate, set_rotate ) : Float;
	public var isStatic( default, default ) : Bool = false;
	
	private var shape_ : Shape = null;
	private var radius_ : Float = 0;
	private var width_ : Float = 0;
	private var height_ : Float = 0;
	
	public function new() {
		super();
		
		this.collide = new Signal2<CollisionBox, CollisionData>();
	}
	
	public function createRect( l_width : Float, l_height : Float ) : Void {
		var startX : Int = 0;
		var startY : Int = 0;
		
		this.type = CollisionBoxType.rect;
		
		shape_ = new Polygon( 0, 0, [	new Vector( startX, startY ),
										new Vector( startX + l_width, startY ),
										new Vector( startX + l_width, startY + l_height ),
										new Vector( startX, startY + l_height ) ] );
										
		this.sprite = new RectSprite( Std.int( l_width ), Std.int( l_height ), 0xFF0000 );
		//this.sprite.setAlpha( 0.5 );
		
		width_ = l_width;
		height_ = l_height;
		
		onShapeCreated();
	}
	
	public function createCircle( l_radius : Float ) : Void {
		shape_ = new Circle( 0, 0, l_radius );
		
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
		//this.sprite.setAlpha( 0.5 );
		
		onShapeCreated();
	}
	
	private function onShapeCreated() : Void {
		shape_.data = this;
		
		this.sprite.setAlpha( 0.5 );
		this.sprite.centerAnchor();
		Kernel.instance().collisionMgr.add( shape_ );
	}
	
	//public function onCollide( collisionBox : CollisionBox ) : Void {
		//Console.log( this + " colliding with " + collisionBox );
	//}
	
	override public function dispose() {
		super.dispose();
		
		if ( this.sprite != null && this.sprite.owner != null ) {
			this.sprite.owner.dispose();
		}
		Kernel.instance().collisionMgr.remove( shape_ );
		
		//trace( "destroy collision box" );
	}
	
	private function get_x() : Float {
		return this.shape_.x;
	}
	
	private function set_x( v : Float ) : Float {
		var shapeOx : Float = 0;
		if ( this.type == CollisionBoxType.rect ) {
			shapeOx = -width_ / 2;
		}
		if ( this.sprite != null ) {
			this.sprite.x._ = v;
		}
		this.shape_.x = v + shapeOx;
		return v;
	}
	
	private function get_y() : Float {
		return this.shape_.y;
	}
	
	private function set_y( v : Float ) : Float {
		var shapeOy : Float = 0;
		if ( this.type == CollisionBoxType.rect ) {
			shapeOy = -height_ / 2;
		}
		if ( this.sprite != null ) {
			this.sprite.y._ = v;
		}
		this.shape_.y = v + shapeOy;
		return v;
	}
	
	private function get_rotate() : Float {
		return this.shape_.rotation;
	}
	
	private function set_rotate( v : Float ) : Float {
		this.shape_.rotation = v;
		if ( this.sprite != null ) {
			this.sprite.rotation._ = v;
		}
		
		return v;
	}
}