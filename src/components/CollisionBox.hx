package components;

import flambe.Component;
import hxcollision.math.Vector;
import hxcollision.shapes.Circle;
import hxcollision.shapes.Polygon;
import hxcollision.shapes.Shape;
import urgame.Kernel;

/**
 * ...
 * @author ragbit
 */
class CollisionBox extends Component
{
	private var shape_ : Shape = null;
	
	public function new() {
		super();
	}
	
	public function createRect( l_x : Float, l_y : Float, l_width : Float, l_height : Float ) : Void {
		var startX : Int = 0;
		var startY : Int = 0;
		
		shape_ = new Polygon( l_x, l_y, [	new Vector( startX, startY ),
											new Vector( startX + l_width, startY ),
											new Vector( startX + l_width, startY + l_height ),
											new Vector( startX, startY + l_height ) ] );
		onShapeCreated();
	}
	
	public function createCircle( l_x : Float, l_y : Float, l_radius : Float ) : Void {
		shape_ = new Circle( l_x, l_y, l_radius );
		onShapeCreated();
	}
	
	public function createPolygon( l_x : Float, l_y : Float, l_vertices : Array<Vector> ) : Void {
		shape_ = new Polygon( l_x, l_y, l_vertices );
		onShapeCreated();
	}
	
	private function onShapeCreated() : Void {
		shape_.data = this;
		
		Kernel.instance().collisionMgr.add( shape_ );
	}
	
	public function onCollide( collisionBox : CollisionBox ) : Void {
		Console.log( this + " colliding with " + collisionBox );
	}
	
	override public function dispose() {
		super.dispose();
		
		Kernel.instance().collisionMgr.remove( shape_ );
	}
}