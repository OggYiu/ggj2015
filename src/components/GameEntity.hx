package components;

import flambe.Component;
import flambe.display.Sprite;
import hxcollision.math.Vector;

/**
 * ...
 * @author ragbit
 */
class GameEntity extends Component
{
	public var position( get_position, set_position ) : Vector;
	public var x( get_x, set_x ) : Float;
	public var y( get_y, set_y ) : Float;
	public var sprite( get_sprite, null ) : Sprite;
	public var collisionBox( get_collisionBox, null ) : CollisionBox;
	private var position_ : Vector = null;
	
	public function new() {
		position_ = new Vector();
	}
	
	override public function onAdded() 
	{
		super.onAdded();
	}
	
	override public function onUpdate(dt:Float) 
	{
		super.onUpdate(dt);
		
		var modX : Float = 0;
		var modY : Float = 0;
		if ( this.sprite != null ) {
			position_.x = this.sprite.x._;
			position_.y = this.sprite.y._;
			//Console.log( "pos: " + this.x + ", " + this.y );
		}
		
		if ( this.collisionBox != null ) {
			this.collisionBox.x = this.position_.x + this.collisionBox.offsetX;
			this.collisionBox.y = this.position_.y + this.collisionBox.offsetY;
		}
	}
	
	private function get_collisionBox() : CollisionBox {
		if ( this.owner == null ) {
			return null;
		}
		
		var box : CollisionBox = this.owner.get( CollisionBox );
		return box;
	}
	
	private function get_sprite() : Sprite {
		if ( this.owner == null ) {
			return null;
		}
		
		var s : Sprite = this.owner.get( Sprite );
		s.centerAnchor();
		return s;
	}
	
	private function get_position() : Vector {
		return position_;
	}
	
	private function set_position( v : Vector ) : Vector {
		this.x = v.x;
		this.y = v.y;
		return position_;
	}
	
	private function get_x() : Float {
		if ( this.sprite != null ) {
			return this.sprite.x._;
		}
		
		return position_.x;
	}
	
	private function set_x( v : Float ) : Float {
		if ( this.sprite != null ) {
			this.sprite.x._ = v;
		}
	
		position_.x = v;
		return position_.x;
	}
	
	private function get_y() : Float {
		if ( this.sprite != null ) {
			return this.sprite.y._;
		}
		
		return position_.y;
	}
	
	private function set_y( v : Float ) : Float {
		if ( this.sprite != null ) {
			this.sprite.y._ = v;
		}
	
		position_.y = v;
		return position_.y;
	}
	
	private function setSpritePos( l_x : Float, l_y : Float ) : Void {
		setSpriteX( l_x );
		setSpriteY( l_y );
	}
	
	private function setSpriteX( l_x : Float ) : Void {
		var s : Sprite = this.sprite;
		if ( s != null ) {
			s.x._ = l_x;
		}
	}
	
	private function setSpriteY( l_y : Float ) : Void {
		var s : Sprite = this.sprite;
		if ( s != null ) {
			s.y._ = l_y;
		}
	}

	private function getSprite() : Sprite {
		if ( this.owner == null ) {
			return null;
		}
		return this.owner.get( Sprite );
	}
}