package urgame;
import components.CollisionBox;
import components.GameEntity;
import flambe.animation.Ease;
import flambe.asset.AssetPack;
import flambe.display.FillSprite;
import flambe.display.Font;
import flambe.display.ImageSprite;
import flambe.display.Sprite;
import flambe.display.TextSprite;
import flambe.display.Texture;
import flambe.Entity;
import flambe.input.Key;
import flambe.input.KeyboardEvent;
import flambe.input.PointerEvent;
import flambe.math.Point;
import flambe.scene.Scene;
import flambe.script.AnimateTo;
import flambe.script.CallFunction;
import flambe.script.Delay;
import flambe.script.Parallel;
import flambe.script.Script;
import flambe.script.Sequence;
import flambe.script.Shake;
import flambe.swf.Library;
import flambe.swf.MoviePlayer;
import flambe.System;
import gui.GUI_Button;
import hxcollision.Collision;
import hxcollision.CollisionData;
import hxcollision.math.Vector;
import hxcollision.shapes.Circle;
import hxcollision.shapes.Polygon;

/**
 * ...
 * @author ragbit
 */
class Demo
{
	private var pack_ : AssetPack = null;
	private var demoIndex_ : Int = -1;
	private var demos_ : Array < (Void -> Entity) > = null;
	private var transitToLeft_ : Bool = false;
	
	private var circleShape : Circle = new Circle( 300, 300, 60 );
	private var circleSprite : CircleSprite = new CircleSprite( 60, 0x00FF00 );
	
	private var polygonShape : Polygon = new Polygon( 300, 300, [new Vector( 150, 0 ), new Vector( 300, 300 ), new Vector( 0, 300 )] );
	private var polygonSprite : PolygonSprite = new PolygonSprite( [ new Point(150, 0), new Point( 300, 300 ), new Point( 0, 300 ) ], 0xFF0000, 1 );

	private var mouseShape : Circle = new Circle( 0, 0, 20 );
	private var mouseSprite : CircleSprite = new CircleSprite( 20, 0xFF0000 );

	public function new() {
	}
	
	public function create() : Void {
		pack_ = Kernel.instance().pack;
		
		demos_ = [demo_gameEntity, demo_gui, demo_primitive, demo_scriptAnim, demo_sprite, demo_test, demo_tween];
		gotoNextDemo();
		System.keyboard.up.connect( onKeyUp );
		System.pointer.move.connect( onMouseMove );
	}
	
	private function gotoPreviousDemo() : Void {
		--demoIndex_;
		if ( demoIndex_ < 0 ) {
			demoIndex_ = demos_.length -1;
		} else if ( demoIndex_ >= demos_.length ) {
			demoIndex_ = 0;
		}
		transitToLeft_ = true;
		gotoDemo( demoIndex_ );
	}
	
	private function gotoNextDemo() : Void {
		++demoIndex_;
		if ( demoIndex_ < 0 ) {
			demoIndex_ = demos_.length -1;
		} else if ( demoIndex_ >= demos_.length ) {
			demoIndex_ = 0;
		}
		transitToLeft_ = false;
		gotoDemo( demoIndex_ );
	}
	
	private function gotoDemo( demoIndex : Int ) : Void {
		Kernel.instance().goto( demos_[demoIndex](), transitToLeft_ );
	}
	
	public function demo_scriptAnim() : Entity {
		var font = new Font( pack_, "font" );
		
		var scene : Entity = new Entity().add( new Scene() );
		scene.addChild( new Entity().add( new FillSprite( Std.int( Math.random() * 0xFFFFFF ), System.stage.width, System.stage.height ) ) );
		scene.addChild( new Entity().add( new TextSprite( font, "demo script animation" ) ) );
		
		var startX : Float = System.stage.width / 2;
		var startY : Float = System.stage.height / 2;
		
		{	
			var actorEntity : Entity = new Entity();
			var lib : Library = new Library( pack_, "alex" );
			
			var moviePlayer : MoviePlayer = new MoviePlayer( lib );
			actorEntity.add( moviePlayer );
			
			var nextX : Float = startX;
			var nextY : Float = startY;
			var script : Script = new Script();
			//var parentMovieSprite : MovieSprite = null;
			
			script.run( new Sequence( [
				new CallFunction( function() {
					moviePlayer.loop( "idle" );
					//parentMovieSprite = moviePlayer.movie._;
					moviePlayer.movie._.centerAnchor().x._ = nextX;
					moviePlayer.movie._.centerAnchor().y._ = nextY;
				} ),
				new Delay( 0.5 ),
				new CallFunction( function() {
					moviePlayer.loop( "run" );
					moviePlayer.movie._.centerAnchor().x._ = nextX;
					moviePlayer.movie._.centerAnchor().y._ = nextY;
					
					moviePlayer.movie._.centerAnchor().x.animateBy( -100, 1, Ease.linear );
					nextX -= 100;
					
					//parentMovieSprite.centerAnchor().x._ = nextX;
				} ),
				new Delay( 1 ),
				new CallFunction( function() {
					moviePlayer.play( "punch" );
					moviePlayer.movie._.centerAnchor().x._ = nextX;
					moviePlayer.movie._.centerAnchor().y._ = nextY;
				} ),
				new Delay( 0.3 ),
				new CallFunction( function() {
					moviePlayer.play( "kick" );
					moviePlayer.movie._.centerAnchor().x._ = nextX;
					moviePlayer.movie._.centerAnchor().y._ = nextY;
				} ),
				new Delay( 0.3 ),
				new CallFunction( function() {
					moviePlayer.play( "upper_cut" );
					moviePlayer.movie._.centerAnchor().x._ = nextX;
					moviePlayer.movie._.centerAnchor().y._ = nextY;
				} ),
				new Delay( 0.3 ),
				new CallFunction( function() {
					moviePlayer.loop( "jump_in_air" );
					moviePlayer.movie._.centerAnchor().x._ = nextX;
					moviePlayer.movie._.centerAnchor().y._ = nextY;
					
					moviePlayer.movie._.centerAnchor().x.animateBy( -50, 0.5, Ease.linear );
					moviePlayer.movie._.centerAnchor().y.animateBy( -50, 0.5, Ease.cubeOut );
					
					nextX -= 50;
				} ),
				new Delay( 0.5 ),
				new CallFunction( function() {
					
					moviePlayer.movie._.centerAnchor().x.animateBy( -50, 0.5, Ease.linear );
					moviePlayer.movie._.centerAnchor().y.animateBy( 50, 0.5, Ease.cubeIn );
					
					nextX -= 50;
				} ),
				new Delay( 0.5 ),
				new CallFunction( function() {
					moviePlayer.loop( "idle" );
					//parentMovieSprite = moviePlayer.movie._;
					moviePlayer.movie._.centerAnchor().x._ = nextX;
					moviePlayer.movie._.centerAnchor().y._ = nextY;
				} ),
			] ) );
			actorEntity.add( script );
			
			scene.addChild( actorEntity );
		}
		
		return scene;
	}
	
	public function demo_sprite() : Entity {
		var font = new Font( pack_, "font" );
		
		var scene : Entity = new Entity().add( new Scene() );
		scene.addChild( new Entity().add( new FillSprite( Std.int( Math.random() * 0xFFFFFF ), System.stage.width, System.stage.height ) ) );
		scene.addChild( new Entity().add( new TextSprite( font, "demo sprite" ) ) );
		
		var planIndex : Int = 0;
		var startX : Float = 80;
		var startY : Float = 400;
		var textStartY : Float = 100;
		var offsetX : Float = 250;
		
		// * ease cheatsheet : http://easings.net/
		{
			var text : TextSprite = new TextSprite( font, "tween\npos\nand\nrot" );
			text.x._ = startX + offsetX * planIndex;
			text.y._ = textStartY;
			text.align = TextAlign.Center;
			scene.addChild( new Entity().add( text ) );
			
			var plane : ImageSprite = new ImageSprite( pack_.getTexture( "plane" ) );
			plane.centerAnchor().x._ = startX + planIndex * offsetX;
			plane.centerAnchor().y._ = startY;
			plane.centerAnchor().y.animateTo( plane.centerAnchor().y._ + 500, 6, Ease.expoIn );
			plane.centerAnchor().rotation.animateTo( 720, 6, Ease.expoIn );
			scene.addChild( new Entity().add( plane ) );
			++planIndex;
		}
		
		{
			var text : TextSprite = new TextSprite( font, "tween\nseqz" );
			text.x._ = startX + offsetX * planIndex;
			text.y._ = textStartY;
			text.align = TextAlign.Center;
			scene.addChild( new Entity().add( text ) );
			
			var planeEntity : Entity = new Entity();
			
			var plane : ImageSprite = new ImageSprite( pack_.getTexture( "plane" ) );
			plane.centerAnchor().x._ = startX + planIndex * offsetX;
			plane.centerAnchor().y._ = startY;
			
			// * script reference : https://aduros.com/flambe/api/flambe/script/
			var script : Script = new Script();
			script.run( new Sequence( [
				new AnimateTo( plane.x, plane.x._ + 200, 2, Ease.backIn ),
				new AnimateTo( plane.y, plane.y._ + 200, 2, Ease.backIn ),
				new AnimateTo( plane.x, plane.x._, 2, Ease.backIn ),
				new Shake( 10, 10, 2 ),
				new AnimateTo( plane.alpha, 0.0, 1, Ease.linear ),
			] ) );
			planeEntity.add( script );
				
			scene.addChild( planeEntity.add( plane ) );
			++planIndex;
		}
		
		{
			var text : TextSprite = new TextSprite( font, "tween\nparallel" );
			text.x._ = startX + offsetX * planIndex;
			text.y._ = textStartY;
			text.align = TextAlign.Center;
			scene.addChild( new Entity().add( text ) );
			
			var planeEntity : Entity = new Entity();
			
			var plane : ImageSprite = new ImageSprite( pack_.getTexture( "plane" ) );
			plane.centerAnchor().x._ = startX + planIndex * offsetX;
			plane.centerAnchor().y._ = startY;
			
			var script : Script = new Script();
			script.run( new Sequence( [
				new Parallel( [	new AnimateTo( plane.centerAnchor().y, plane.centerAnchor().y._ + 200, 2, Ease.circOut ),
								new AnimateTo( plane.centerAnchor().x, plane.centerAnchor().x._ + 200, 2, Ease.circOut ), ] ),
				new Parallel( [	new AnimateTo( plane.centerAnchor().y, plane.centerAnchor().y._, 2, Ease.circOut ),
								new AnimateTo( plane.centerAnchor().x, plane.centerAnchor().x._, 2, Ease.circOut ), ] ),
			] ) );
			planeEntity.add( script );
				
			scene.addChild( planeEntity.add( plane ) );
			++planIndex;
		}
		
		return scene;
	}
	
	public function demo_gui() : Entity {
		var font = new Font( pack_, "font" );
		
		var scene : Entity = new Entity().add( new Scene() );
		scene.addChild( new Entity().add( new FillSprite( Std.int( Math.random() * 0xFFFFFF ), System.stage.width, System.stage.height ) ) );
		scene.addChild( new Entity().add( new TextSprite( font, "demo gui" ) ) );
		
		{
			var buttonStateText : TextSprite = new TextSprite( font, "button up" ); 
			scene.addChild( new Entity().add( buttonStateText ) );
			buttonStateText.setXY( 0, 100 );
			
			var e : Entity = new Entity();
			var texture1 : Texture = pack_.getTexture( "gui/start-normal" );
			var texture2 : Texture = pack_.getTexture( "gui/start-hover" );
			var texture3 : Texture = pack_.getTexture( "gui/start-click" );
			
			var button1 : GUI_Button = new GUI_Button( texture1, texture3, function( str : String ) { Console.log( str ); } );
			e.add( button1 );
			button1.setXY( 80, 200 );
			button1.centerAnchor();
			button1.rotation.animateTo( 80, 1, Ease.circIn );
			
			button1.pointerDown.connect( function( _ ) {
				buttonStateText.text = "button down";
			} );
			
			button1.pointerUp.connect( function( _ ) {
				buttonStateText.text = "button up";
			} );
			
			scene.addChild( e );
		}
		
		{
			//var e : Entity = new Entity();
			//
			//var button : GUI_TextButton = new GUI_TextButton();
			//scene.addChild( e );
		}
		return scene;
	}
	
	public function demo_tween() : Entity {
		var font = new Font( pack_, "font" );
		
		var scene : Entity = new Entity().add( new Scene() );
		scene.addChild( new Entity().add( new FillSprite( Std.int( Math.random() * 0xFFFFFF ), System.stage.width, System.stage.height ) ) );
		scene.addChild( new Entity().add( new TextSprite( font, "demo tween" ) ) );
		return scene;
	}
	
	public function demo_test() : Entity {
		var font = new Font( pack_, "font" );
		
		var scene : Entity = new Entity().add( new Scene() );
		scene.addChild( new Entity().add( new FillSprite( Std.int( Math.random() * 0xFFFFFF ), System.stage.width, System.stage.height ) ) );
		scene.addChild( new Entity().add( new TextSprite( font, "demo test" ) ) );
		return scene;
	}
	
	public function demo_gameEntity() : Entity {
		var font = new Font( pack_, "font" );
		
		var scene : Entity = new Entity().add( new Scene() );
		scene.addChild( new Entity().add( new FillSprite( Std.int( 0xAAAAAA ), System.stage.width, System.stage.height ) ) );
		scene.addChild( new Entity().add( new TextSprite( font, "demo_gameEntity" ) ) );
		
		{
			var e : Entity = new Entity();
			
			{	
				var texture : Texture = pack_.getTexture( "plane" );
				var sprite : ImageSprite = new ImageSprite( texture );
				sprite.centerAnchor();
				e.add( sprite );
			
				var collisionBox : CollisionBox = new CollisionBox();
				collisionBox.createRect( 0, 0, texture.width, texture.height );
				e.add( collisionBox );
				
				var gameEntity : GameEntity = new GameEntity( 200, 200, sprite );
				e.add( gameEntity );
				gameEntity.sprite.x.animateBy( 300, 2 );
				gameEntity.sprite.y.animateBy( 200, 2 );
			
				scene.addChild( e );
			}
		}
		
		return scene;
	}
	
	public function demo_primitive() : Entity  {
		var font = new Font( pack_, "font" );
		
		var scene : Entity = new Entity().add( new Scene() );
		scene.addChild( new Entity().add( new FillSprite( Std.int( 0xAAAAAA ), System.stage.width, System.stage.height ) ) );
		scene.addChild( new Entity().add( new TextSprite( font, "demo primtive" ) ) );
		
		{
			var e : Entity = new Entity();
			e.add( new LineSprite( new Point( 50, 50 ), new Point( 200, 200 ), 0xFF0000, 1 ) );
			scene.addChild( e );
		}
		
		{
			var e : Entity = new Entity();
			circleSprite.centerAnchor();
			circleSprite.setXY( 300, 300 );
			//sprite.rotation.animateTo( 360, 1 );
			scene.addChild( e.add( circleSprite ) );
		}
		
		{
			var e : Entity = new Entity();
			mouseSprite.centerAnchor();
			mouseSprite.setXY( 300, 300 );
			//sprite.rotation.animateTo( 360, 1 );
			scene.addChild( e.add( mouseSprite ) );
		}
		
		{
			var e : Entity = new Entity();
			//polygonSprite.centerAnchor();
			polygonSprite.rotation.animateTo( 360, 1 );
			polygonSprite.setXY( 300, 300 );
			scene.addChild( e.add( polygonSprite ) );
		}
		
		{
			var e : Entity = new Entity();
			//var gradientSprite : GradientSprite = new GradientSprite( 100, 20, 0x2F2F6A, 0x5C5C80 );
			var gradientSprite : GradientSprite = new GradientSprite( 200, 40, 0xFFFFAA, 0xFFFFFF );
			scene.addChild( e.add( gradientSprite ) );
		}
		return scene;
	}
	
	
	public function demo_particle() : Entity  {
		var font = new Font( pack_, "font" );
		
		var scene : Entity = new Entity().add( new Scene() );
		scene.addChild( new Entity().add( new FillSprite( Std.int( 0xAAAAAA ), System.stage.width, System.stage.height ) ) );
		scene.addChild( new Entity().add( new TextSprite( font, "demo particle" ) ) );
		
		return scene;
	}
	
	private function onKeyUp( event : KeyboardEvent ) : Void {
		if ( event.key == Key.Left ) {
			gotoPreviousDemo();
		} else if ( event.key == Key.Right ) {
			gotoNextDemo();
		}
	}
	
	public function onMouseMove( e : PointerEvent ) : Void {
		mouseSprite.setXY( e.viewX, e.viewY );
		
		mouseShape.position.x = mouseSprite.x._;
		mouseShape.position.y = mouseSprite.y._;
		
		circleSprite.x._ = circleShape.position.x;
		circleSprite.y._ = circleShape.position.y;
		
		polygonSprite.x._ = polygonShape.position.x;
		polygonSprite.y._ = polygonShape.position.y;
		
		{
			var mouseCollideData : CollisionData = Collision.test( mouseShape, circleShape );
			if ( mouseCollideData != null ) {
				var shape1 = mouseCollideData.shape1 == mouseShape? mouseCollideData.shape1 : mouseCollideData.shape2;
				var shape2 = mouseCollideData.shape1 == mouseShape? mouseCollideData.shape2 : mouseCollideData.shape1;
				if ( shape1 == mouseShape || shape2 == mouseShape ) {
					shape2.x -= mouseCollideData.overlap * mouseCollideData.unitVector.x;
					shape2.y -= mouseCollideData.overlap * mouseCollideData.unitVector.y;
				}
			}
		}
		
		{
			var mouseCollideData : CollisionData = Collision.test( mouseShape, polygonShape );
			if ( mouseCollideData != null ) {
				var shape1 = mouseCollideData.shape1 == mouseShape? mouseCollideData.shape1 : mouseCollideData.shape2;
				var shape2 = mouseCollideData.shape1 == mouseShape? mouseCollideData.shape2 : mouseCollideData.shape1;
				if ( shape1 == mouseShape || shape2 == mouseShape ) {
					shape2.x -= mouseCollideData.overlap * mouseCollideData.unitVector.x;
					shape2.y -= mouseCollideData.overlap * mouseCollideData.unitVector.y;
				}
			}
		}
	}
	
	private static var s_instance : Demo = null;
	public static function instance() : Demo {
		if ( s_instance == null ) {
			s_instance = new Demo();
		}
		return s_instance;
	}
}