package urgame ;
import flambe.animation.Ease;
import flambe.display.Font;
import flambe.Entity;
import flambe.input.Key;
import flambe.input.KeyboardEvent;
import flambe.scene.SlideTransition;
import flambe.System;
import flambe.asset.AssetPack;
import flambe.Component;
import flambe.scene.Director;

/**
 * ...
 * @author ragbit
 */
class Kernel extends Component
{
	public var pack( default, null ) : AssetPack = null;
	public var font( default, null ) : Font = null;
	public var collisionMgr( default, null ) : CollisionMgr = null;
	
	private var director_ : Director;
	private var debuggerIsOn_ : Bool = false;
	
	public function new() {
		super();
		
		Console.start();
	}
	
	public function create( l_pack : AssetPack ) : Kernel {
		this.pack = l_pack;
		this.font = new Font( this.pack, "font" );
		//Console.log( "this.font: " + this.font );
		
		System.keyboard.up.connect( onKeyUp );
		
		//System.stage.requestFullscreen();
		
		//Console.defaultPrinter.attach();
		//Console.log( "onAdded" );
		
		//Console.log( "stage size: " + System.stage.width + ", " + System.stage.height );
		
		return this;
	}
	
	override public function onAdded() 
	{
		super.onAdded();
		
		this.collisionMgr = new CollisionMgr();
		System.root.add( this.collisionMgr );
		
		System.root.add( director_ = new Director() );
		Game.instance().create();
		//Demo.instance().create();
	}
	
	private function toggleDebugger() : Void {
		debuggerIsOn_ = !debuggerIsOn_;
		debuggerIsOn_? Console.defaultPrinter.attach() : Console.defaultPrinter.remove();
	}
	
	private function onKeyUp( event : KeyboardEvent ) : Void {
		//Console.log( "key : " + event.key );
		if ( event.key == Key.Q ) {
			toggleDebugger();
		} else if ( event.key == Key.Left ) {
			Game.instance().gotoPreviousPage();
		} else if ( event.key == Key.Right ) {
			Game.instance().gotoNextPage();
		}
	}
	
	public function goto( sceneEntity : Entity, transitToLeft : Bool ) : Void {
		var transition : SlideTransition = new SlideTransition( 1, Ease.quintInOut );
		
		transitToLeft? transition.right() : transition.left();
		
		//var transition : FadeTransition = new FadeTransition( 1, Ease.quadIn );
		// left() slide to the left, also has right(), up() and down()
		
		director_.unwindToScene( sceneEntity, transition );
	}
	
	override public function onUpdate(dt:Float) {
		super.onUpdate(dt);
		
		//var mouseCollideData : CollisionData = Collision.test( circle );
	}
	
	private static var s_instance : Kernel = null;
	public static function instance() : Kernel {
		if ( s_instance == null ) {
			s_instance = new Kernel();
		}
		return s_instance;
	}
}