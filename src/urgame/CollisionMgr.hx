package urgame;
import components.CollisionBox;
import flambe.Component;
import hxcollision.Collision;
import hxcollision.CollisionData;
import hxcollision.shapes.Shape;

/**
 * ...
 * @author ragbit
 */
class CollisionMgr extends Component
{
	private var shapes_ : Array<Shape> = null;
	
	public function new() {
		super();
		
		shapes_ = new Array<Shape>();
	}
	
	public function add( l_shape : Shape ) : Void {
		for ( shape in shapes_ ) {
			if ( l_shape == shape ) {
				Console.warn( "shape : " + shape + " already existed!" );
				return;
			}
		}
		
		shapes_.push( l_shape );
	}
	
	public function remove( l_shape : Shape ) : Void {
		for ( shape in shapes_ ) {
			if ( l_shape == shape ) {
				shapes_.remove( l_shape );
				return;
			}
		}

		Console.warn( "shape : " + l_shape + " not found!" );
	}
	
	override public function dispose() {
		super.dispose();
	}
	
	override public function onUpdate( dt : Float ) {
		super.onUpdate( dt );
		
		for ( shape1 in shapes_ ) {
			for ( shape2 in shapes_ ) {
				if ( shape1 == shape2 ) {
					continue;
				}
					
				var mouseCollideData : CollisionData = Collision.test( shape1, shape2 );
				if ( mouseCollideData != null ) {
					var collisionBox1 : CollisionBox = cast( shape1.data, CollisionBox );
					var collisionBox2 : CollisionBox = cast( shape2.data, CollisionBox );
					if ( collisionBox1 == null ) {
						Console.error( "collison box of shape : " + shape1 + " is invalid" );
						continue;
					}
					if ( collisionBox2 == null ) {
						Console.error( "collison box of shape : " + shape2 + " is invalid" );
						continue;
					}
					
					collisionBox1.onCollide( collisionBox2 );
					collisionBox2.onCollide( collisionBox1 );
				}
			}
		}
	}
}