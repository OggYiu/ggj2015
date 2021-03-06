package page ;
import flambe.script.CallFunction;
import format.tools.Image;
import hxcollision.CollisionData;
import urgame.Game;

import components.CollisionBox;
import components.GameEntity;
import flambe.Component;
import flambe.display.FillSprite;
import flambe.display.ImageSprite;
import flambe.display.Sprite;
import flambe.display.TextSprite;
import flambe.Entity;
import flambe.input.Key;
import flambe.input.KeyboardEvent;
import flambe.input.MouseEvent;
import flambe.input.PointerEvent;
import hxcollision.math.Vector;
import urgame.Global;
import urgame.Projectile;
import flambe.script.AnimateTo;
import flambe.script.Parallel;
import flambe.script.Repeat;
import flambe.script.Script;
import flambe.script.Sequence;
import flambe.animation.Ease;

class GamePage_Battle extends GamePage
{
	private static var SPEED : Float = 1000;
	private static var DRAW_COLLISION_BOX : Bool = false;
	
	private var player1( default, default ) : GameEntity = null;
	private var player2( default, default ) : GameEntity = null;
	private var horse1( default, default ) : GameEntity = null;
	private var horse2( default, default ) : GameEntity = null;
	private var horse1Ox_ : Float = 0;
	private var horse1Oy_ : Float = 0;
	private var horse2Ox_ : Float = 0;
	private var horse2Oy_ : Float = 0;
	private var moveKeyUp1_ : Bool = false;
	private var moveKeyDown1_ : Bool = false;
	private var moveKeyUp2_ : Bool = false;
	private var moveKeyDown2_ : Bool = false;
	private var player1Hp_ : Int = 20;
	private var player2Hp_ : Int = 20;
	
	public function new(l_parent:Entity) 
	{
		super(l_parent);
	}
		
	override public function onAdded() 
	{
		super.onAdded();
		
		var background = new ImageSprite(pack.getTexture("4/4_background"));
		background.scaleX._ = this.screenWidth / background.getNaturalWidth();
		background.scaleY._ = this.screenHeight / background.getNaturalHeight();
		background.x._ = 0;
		background.y._ = 0;
		this.entityLayer.addChild(new Entity().add(background));
		
		var egg1 = new ImageSprite(pack.getTexture("4/4_egg1"));
		egg1.setScaleXY(0.7, 0.7);
		egg1.centerAnchor();
		egg1.x._ = x1() + 730;
		egg1.y._ = y1() + 290;
		var egg1Entity = new Entity();
		egg1Entity.add(egg1);
		var script : Script = new Script();
			script.run(
				new Repeat(
				new Sequence(
				[
					new AnimateTo( egg1.y, egg1.y._ + 220, 2.5, Ease.circIn ),
					new AnimateTo( egg1.y, y1() + 290, 0, Ease.circIn )
				])
				));
		egg1Entity.add(script);
		this.entityLayer.addChild(egg1Entity);
		
		createCloud("4/4_cloud3", 710, 300);
		
		createCloud("4/4_cloud5", 350, 200);
		
		createCloud("4/4_cloud1", 150, 180);
		
		createCloud("4/4_cloud2", 990, 220);
		
		createCloud("4/4_cloud4", 920, 100);
		
		var basket = new ImageSprite(pack.getTexture("4/4_basket"));
		basket.centerAnchor();
		basket.x._ = x1() + 750;
		basket.y._ = y1() + 470;
		this.entityLayer.addChild(new Entity().add(basket));
		
		
		{
			var e : Entity = new Entity();
			e.add( this.horse1 = new GameEntity() );
			
			var image : ImageSprite = new ImageSprite( this.pack.getTexture( "4/4_lefthorse" ) );
			e.add( image );
			
			this.horse1.x = 150;
			this.horse1.y = y1() + this.pageHeight() / 2 + 100;
			
			this.entityLayer.addChild( e );
		}
		
		{
			var e : Entity = new Entity();
			e.add( this.horse2 = new GameEntity() );
			
			var image : ImageSprite = new ImageSprite( this.pack.getTexture( "4/4_righthorse" ) );
			e.add( image );
			
			this.horse2.x = 1150;
			this.horse2.y = y1() + this.pageHeight() / 2 + 100;
			
			this.entityLayer.addChild( e );
		}
		
		{
			this.player1 = new GameEntity();
			
			var e : Entity = new Entity();
			e.add( ( this.player1 = new GameEntity() ));
			
			var image : ImageSprite = new ImageSprite( this.pack.getTexture( "4/4_humpty_left_witharm&leg" ) );
			e.add( image );
			
			this.player1.x = x1() + image.getNaturalWidth() / 2;
			this.player1.y = y1() + this.pageHeight() / 2;
			this.entityLayer.addChild( e );
			
			var collisionBox : CollisionBox = new CollisionBox();
			//collisionBox.createRect( 0, 0, image.getNaturalWidth(), image.getNaturalHeight() );
			collisionBox.createCircle( ( image.getNaturalWidth() / 5 ) * 2 );
			//collisionBox.offsetX = -image.getNaturalWidth() / 2;
			//collisionBox.offsetY = -image.getNaturalHeight() / 2;
			e.add( collisionBox );
			
			if ( DRAW_COLLISION_BOX ) {
				var e1 : Entity = new Entity();
				e1.add( collisionBox.sprite );
				this.entityLayer.addChild( e1 );
			}
		}
		
		{
			this.player2 = new GameEntity();
			
			var e : Entity = new Entity();
			e.add( ( this.player2 = new GameEntity() ));
			
			var image : ImageSprite = new ImageSprite( this.pack.getTexture( "4/4_humpty_right_witharm&leg" ) );
			e.add( image );
			
			this.player2.x = x2() + this.pageWidth() - image.getNaturalWidth() / 2;
			//this.player2.x = x2();	
			this.player2.y = y2() + this.pageHeight() / 2;
			this.entityLayer.addChild( e );
			
			
			var collisionBox : CollisionBox = new CollisionBox();
			//collisionBox.createRect( 0, 0, image.getNaturalWidth(), image.getNaturalHeight() );
			collisionBox.createCircle( ( image.getNaturalWidth() / 5 ) * 2 );
			//collisionBox.offsetX = -image.getNaturalWidth() * 0.25;
			//collisionBox.offsetY = -image.getNaturalHeight() / 2;
			e.add( collisionBox );
			
			if ( DRAW_COLLISION_BOX ) {
				var e1 : Entity = new Entity();
				e1.add( collisionBox.sprite );
				this.entityLayer.addChild( e1 );
			}
		}
		
		this.horse1Ox_ = this.player1.x - this.horse1.x;
		this.horse1Oy_ = this.player1.y - this.horse1.y;
		this.horse2Ox_ = this.player2.x - this.horse2.x;
		this.horse2Oy_ = this.player2.y - this.horse2.y;
	}
	
	private function createCloud(imagePath : String, x : Float, y : Float)
	{
		var cloud3 = new ImageSprite(pack.getTexture(imagePath));
		cloud3.centerAnchor();
		cloud3.alpha._ = 0.9;
		cloud3.x._ = x1() + x;
		cloud3.y._ = y1() + y;
		var cloud3Entity = new Entity();
		cloud3Entity.add(cloud3);
		var script : Script = new Script();
			script.run(
				new Repeat(
				new Sequence(
				[
					new Parallel( [
					new AnimateTo( cloud3.scaleX, cloud3.scaleX._ * 1.01, 0.8, Ease.circIn ),
					new AnimateTo( cloud3.scaleY, cloud3.scaleY._ * 1.01, 0.8, Ease.circIn )]),
					
					new Parallel( [
					new AnimateTo( cloud3.scaleX, cloud3.scaleX._ / 1.01, 0.8, Ease.circIn ),
					new AnimateTo( cloud3.scaleY, cloud3.scaleY._ / 1.01, 0.8, Ease.circIn )])
				])
				));
		cloud3Entity.add(script);
		this.entityLayer.addChild(cloud3Entity);
	}
	
	override public function onUpdate(dt:Float) 
	{
		super.onUpdate(dt);
		
		if ( moveKeyUp1_ ) {
			player1.y -= dt * SPEED;
			horse1.y = player1.y - horse1Oy_;
		}
		if ( moveKeyDown1_ ) {
			player1.y += dt * SPEED;
			horse1.y = player1.y - horse1Oy_;
		}
		
		if ( moveKeyUp2_ ) {
			player2.y -= dt * SPEED;
			horse2.y = player2.y - horse2Oy_;
		}
		if ( moveKeyDown2_ ) {
			player2.y += dt * SPEED;
			horse2.y = player2.y - horse2Oy_;
		}
	}
	
	override public function dispose() 
	{
		super.dispose();
	}
	
	override private function onKeyUp( e : KeyboardEvent ) : Void {
		if ( e.key == Key.A ) {
			moveKeyUp1_ = false;
		}
		if ( e.key == Key.Z ) {
			moveKeyDown1_ = false;
		}
		if ( e.key == Key.J ) {
			moveKeyUp2_ = false;
		}
		if ( e.key == Key.M ) {
			moveKeyDown2_ = false;
		}
	}
	
	override private function onKeyDown( e : KeyboardEvent ) : Void {
		if ( e.key == Key.A ) {
			moveKeyUp1_ = true;
		}
		if ( e.key == Key.Z ) {
			moveKeyDown1_ = true;
		}
		if ( e.key == Key.X ) {
			var e : Entity = new Entity();
			
			var projectile : Projectile = new Projectile();
			e.add( projectile );
			
			var image : ImageSprite = new ImageSprite( this.pack.getTexture( "4/4_weapon1" ) );
			e.add( image );
			image.x._ = player1.x + image.getNaturalWidth();
			image.y._ = player1.y;
			image.x.animateTo( this.screenWidth + image.getNaturalWidth(), 2 );
			
			var collisionBox : CollisionBox = new CollisionBox();
			collisionBox.createCircle( image.getNaturalHeight() / 2 );
			//collisionBox.createRect( 0, 0, image.getNaturalWidth(), image.getNaturalHeight() / 2 );
			//collisionBox.offsetX = image.getNaturalWidth() / 2;
			//collisionBox.offsetY = -image.getNaturalHeight() / 2;
			collisionBox.collide.connect( function( box : CollisionBox, data : CollisionData ) {
				if ( box.owner != null ) {
					if ( box.owner.get( GameEntity ) == this.player2 ) {
						--player2Hp_;
						collisionBox.owner.dispose();
						if ( player2Hp_ <= 0 ) {
							gameEnd( this.player1 );
						}
						
						{
							var e : Entity = new Entity();
							var image : ImageSprite = new ImageSprite( this.pack.getTexture( "4/4_explode1" ) );
							image.centerAnchor();
							image.x._ = collisionBox.x;
							image.y._ = collisionBox.y;
							image.setScaleXY( 0, 0 );
							var script : Script = new Script();
							script.run(
								new Sequence([
									new Parallel([
										new AnimateTo( image.scaleX, 2, 1, Ease.circIn ),
										new AnimateTo( image.scaleY, 2, 1, Ease.circIn ),
										new AnimateTo( image.alpha, 0, 1, Ease.circIn )]),
									new CallFunction( function() : Void {
										image.owner.dispose();
									})])
							);
							e.add( script );
							image.alpha.animateTo( 0, 1 );
							e.add( image );
							this.entityLayer.addChild( e );
						}
					}
				}
			} );
			e.add( collisionBox );
			
			this.pack.getSound( "audio/lazer_shot" ).play();
			this.entityLayer.addChild( e );
			
			if ( DRAW_COLLISION_BOX ) {
				var e1 : Entity = new Entity();
				e1.add( collisionBox.sprite );
				this.entityLayer.addChild( e1 );
			}
		}
		if ( e.key == Key.J ) {
			moveKeyUp2_ = true;
		}
		if ( e.key == Key.M ) {
			moveKeyDown2_ = true;
		}
		if ( e.key == Key.K ) {
			var e : Entity = new Entity();
			
			var projectile : Projectile = new Projectile();
			e.add( projectile );
			
			var image : ImageSprite = new ImageSprite( this.pack.getTexture( "4/4_weapon3" ) );
			e.add( image );
			image.x._ = player2.x - image.getNaturalWidth();
			image.y._ = player2.y;
			image.x.animateTo( -image.getNaturalWidth(), 2 );
			
			var collisionBox : CollisionBox = new CollisionBox();
			collisionBox.createCircle( image.getNaturalHeight() / 2 );
			//collisionBox.createRect( 0, 0, image.getNaturalWidth(), image.getNaturalHeight() / 2 );
			//collisionBox.offsetX = -image.getNaturalWidth() / 2;
			//collisionBox.offsetY = -image.getNaturalHeight() / 2;
			collisionBox.collide.connect( function( box : CollisionBox, data : CollisionData ) {
				if ( box.owner != null ) {
					if ( box.owner.get( GameEntity ) == this.player1 ) {
						--player1Hp_;
						collisionBox.owner.dispose();
						if ( player1Hp_ <= 0 ) {
							gameEnd( this.player2 );
						}
					}
				}
			} );
			e.add( collisionBox );
			
			this.pack.getSound( "audio/lazer_shot" ).play();
			this.entityLayer.addChild( e );
			
			if ( DRAW_COLLISION_BOX ) {
				var e1 : Entity = new Entity();
				e1.add( collisionBox.sprite );
				this.entityLayer.addChild( e1 );
			}
		}
	}
	
	private var won_ : Bool = false;
	private function gameEnd( l_player : GameEntity ) : Void {
		if ( !won_ ) {
			won_ = true;
			Game.instance().gotoNextPage();
		}
	}
}