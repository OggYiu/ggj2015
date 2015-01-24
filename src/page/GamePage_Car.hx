package page ;

import components.CollisionBox;
import components.GameEntity;
import flambe.Component;
import flambe.display.FillSprite;
import flambe.display.ImageSprite;
import flambe.display.TextSprite;
import flambe.Disposer;
import flambe.Entity;
import flambe.input.Key;
import flambe.input.KeyboardEvent;
import flambe.input.MouseEvent;
import flambe.input.PointerEvent;
import hxcollision.CollisionData;
import hxcollision.math.Matrix;
import hxcollision.math.Vector;
import urgame.Global;

class GamePage_Car extends GamePage
{
	private static var DRAW_DEBUG_BOX : Bool = true;
	private static var ROT_SPEED : Float = 100;
	private static var MOVE_SPEED : Float = 100;
	
	private var car_ : GameEntity = null;
	private var turnRight_ : Bool = false;
	private var turnLeft_ : Bool = false;
	private var moveForward_ : Bool = false;
	private var moveBackward_ : Bool = false;
	private var disposer_ : Disposer = null;
	
	public function new(l_parent:Entity) 
	{
		super(l_parent);
	}
		
	override public function onAdded() 
	{
		super.onAdded();
		
		
		this.disposer_ = new Disposer();
		this.owner.add( this.disposer_ );
		
		{
			var e : Entity = new Entity();
			
			this.car_ = new GameEntity();
			e.add( this.car_ );
			
			var image : ImageSprite = new ImageSprite( this.pack.getTexture( "car" ) );
			e.add( image );
			image.x._ = x1() + this.pageWidth() / 2;
			image.y._ = y1() + this.pageHeight() / 2;
			
			var collisionBox : CollisionBox = new CollisionBox();
			//collisionBox.createRect( image.getNaturalWidth(), image.getNaturalHeight() );
			collisionBox.createCircle( image.getNaturalWidth() / 2 );
			e.add( collisionBox );
			
			if ( DRAW_DEBUG_BOX ) {
				var e1 : Entity = new Entity();
				e1.add( collisionBox.sprite );
				this.overlay.addChild( e1 );
			}
			
			this.entityLayer.addChild( e );
		}
		
		addObstacle( 10 );
	}
	
	private function addObstacle( l_number : Int ) : Void {
		for ( i in 0 ... l_number ) {
			var e : Entity = new Entity();
			
			var ge : GameEntity = new GameEntity();
			e.add( ge );
			
			var image : ImageSprite = new ImageSprite( this.pack.getTexture( "tree1" ) );
			e.add( image );
			
			image.x._ = Math.random() * ( x1() + this.pageWidth() );
			image.y._ = Math.random() * ( y1() + this.pageHeight() );
			
			var collisionBox : CollisionBox = new CollisionBox();
			collisionBox.createRect( image.getNaturalWidth(), image.getNaturalHeight() );
			collisionBox.createCircle( image.getNaturalWidth() / 2 );
			collisionBox.isStatic = true;
			this.disposer_.add( collisionBox.collide.connect( function( other : CollisionBox, collisionData : CollisionData ) {
				if ( other.isStatic ) {
					return;
				}
				
				if ( other.owner != null ) {
					var ge : GameEntity = other.owner.get( GameEntity );
					if ( ge != null ) {
						ge.x -= collisionData.separation.x;
						ge.y -= collisionData.separation.y;
					}
				}
			} ));
			e.add( collisionBox );
			
			if ( DRAW_DEBUG_BOX ) {
				var e1 : Entity = new Entity();
				e1.add( collisionBox.sprite );
				this.overlay.addChild( e1 );
			}
			
			this.entityLayer.addChild( e );
		}
	}
	
	override public function onUpdate(dt:Float) 
	{
		super.onUpdate(dt);
		
		if ( turnLeft_ ) {
			this.car_.rotate -= dt * ROT_SPEED;
			//this.car_.sprite.rotation._ -= dt * ROT_SPEED;
		}
		
		if ( turnRight_ ) {
			this.car_.rotate += dt * ROT_SPEED;
			//this.car_.sprite.rotation._ += dt * ROT_SPEED;
		}
		
		if ( moveForward_ || moveBackward_ ) {
			var pivot : Vector = new Vector();
			var rad : Float = Global.degToRad( this.car_.sprite.rotation._ - 90 );
			var direction : Vector = new Vector(Math.cos(rad), Math.sin(rad));
			this.car_.sprite.x._ += direction.x * dt * MOVE_SPEED * ( moveBackward_? -1 : 1 );
			this.car_.sprite.y._ += direction.y * dt * MOVE_SPEED * ( moveBackward_? -1 : 1 );
		}
	}
	public function rotateVector( vector : Vector, radians : Float) : Vector {
		var ca : Float = Math.cos(radians);
		var sa : Float = Math.sin(radians);
		var rx : Float = vector.x * ca - vector.y * sa;
		var ry : Float = vector.x * sa + vector.y * ca;
		vector.x = rx;
		vector.y = ry;
		
		return vector;
	}
	
	override public function dispose() : Void
	{
		super.dispose();
	}
	
	override private function onKeyUp( e : KeyboardEvent ) : Void {
		if ( e.key == Key.A ) {
			turnLeft_ = false;
		}
		if ( e.key == Key.D ) {
			turnRight_ = false;
		}
		if ( e.key == Key.S ) {
			moveForward_ = false;
		}
		if ( e.key == Key.X ) {
			moveBackward_ = false;
		}
	}
	
	override private function onKeyDown( e : KeyboardEvent ) : Void {
		if ( e.key == Key.A ) {
			turnLeft_ = true;
		}
		if ( e.key == Key.D ) {
			turnRight_ = true;
		}
		if ( e.key == Key.S ) {
			moveForward_ = true;
		}
		if ( e.key == Key.X ) {
			moveBackward_ = true;
		}
	}
	
	override private function onMouseDown( e : PointerEvent ) : Void {
	}
	
	override private function onMouseUp( e : PointerEvent ) : Void {
	}
	
	override private function onMouseMove( e : PointerEvent ) : Void {
	}
}