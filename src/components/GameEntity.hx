package components;

import flambe.Component;
import flambe.display.ImageSprite;
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
	public var sprite( get_sprite, set_sprite ) : ImageSprite;
	
	private var sprite_ : ImageSprite = null;
	private var position_ : Vector = null;
	
	public function new( l_x, l_y, s : ImageSprite ) {
		position_ = new Vector();
		this.x = l_x;
		this.y = l_y;
		this.sprite = s;
	}
	
	private function get_sprite() : ImageSprite {
		if ( this.owner == null ) {
			return null;
		}
		
		var s = this.owner.get( ImageSprite );
		if ( s == null ) {
			return null;
		}
		
		if ( sprite_ != s ) {
			sprite_ = s;
		}
		
		return sprite_;
	}
	
	private function set_sprite( v : ImageSprite ) : ImageSprite {
		if ( v == null ) {
			return null;
		}
		
		if ( sprite_ != v ) {
			sprite_ = v;
			sprite_.x._ = position_.x;
			sprite_.y._ = position_.y;	
			
			//Console.log( "animat" );
			//sprite_.x.animateTo( 200, 0 );
		}
		return sprite_;
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
		var s : ImageSprite = this.sprite;
		if ( s != null ) {
			s.x._ = l_x;
		}
	}
	
	private function setSpriteY( l_y : Float ) : Void {
		var s : ImageSprite = this.sprite;
		if ( s != null ) {
			s.y._ = l_y;
		}
	}

	private function getSprite() : ImageSprite {
		if ( this.owner == null ) {
			return null;
		}
		return this.owner.get( ImageSprite );
	}
	
	override public function onUpdate(dt:Float) 
	{
		super.onUpdate(dt);
		
		if ( this.sprite != null ) {
			position_.x = this.sprite.x._;
			position_.y = this.sprite.y._;
			
			//Console.log( "pos: " + this.x + ", " + this.y );
		}
	}
}