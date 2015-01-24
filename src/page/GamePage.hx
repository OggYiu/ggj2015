package page;
import flambe.asset.AssetPack;
import flambe.Component;
import flambe.display.FillSprite;
import flambe.display.Font;
import flambe.Disposer;
import flambe.Entity;
import flambe.input.KeyboardEvent;
import flambe.input.MouseEvent;
import flambe.input.PointerEvent;
import flambe.input.TouchPoint;
import flambe.System;
//import flash.events.TouchEvent;
import urgame.Game;
import urgame.Global;
import urgame.Kernel;

/**
 * ...
 * @author ragbit
 */
class GamePage extends Component
{
	private var parent( default, default ) : Entity;
	private var kernel( default, default ) : Kernel;
	private var pack( default, default ) : AssetPack;
	private var game( default, default ) : Game;
	private var font( default, default ) : Font;
	private var screenWidth( default, default ) : Int;
	private var screenHeight( default, default ) : Int;
	private var background( default, default ) : Entity;
	private var overlay( default, default ) : Entity;
	private var entityLayer( default, default ) : Entity;
	private var timeElapsed( default, default ) : Float = 0;
	private var disposer : Disposer = new Disposer();
	
	public function new( l_parent : Entity ) 
	{
		super();
		
		this.parent = l_parent;
		this.kernel = Kernel.instance();
		this.pack = Kernel.instance().pack;
		this.game = Game.instance();
		this.font = Kernel.instance().font;
		this.screenWidth = System.stage.width;
		this.screenHeight = System.stage.height;
		
		//Console.log( "stage size: " + System.stage.width + ", " + System.stage.height );
		//Console.log( "screen size: " + Global.getPageWidth() + ", " + Global.getPageHeight() );
	}
	
	override public function onAdded() 
	{
		super.onAdded();
		
		this.background = new Entity();
		this.parent.addChild( this.background );
		
		this.entityLayer = new Entity();
		this.parent.addChild( this.entityLayer );
	
		this.overlay = new Entity();
		this.parent.addChild( this.overlay );
		
		this.disposer.add( System.keyboard.up.connect( onKeyUp ) );
		this.disposer.add( System.keyboard.down.connect( onKeyDown ) );
		this.disposer.add( System.pointer.down.connect( onMouseDown ) );
		this.disposer.add( System.pointer.up.connect( onMouseUp ) );
		this.disposer.add( System.pointer.move.connect( onMouseMove ) );
		this.disposer.add( System.touch.down.connect( onTouchDown ) );
		this.disposer.add( System.touch.up.connect( onTouchUp ) );
		this.disposer.add( System.touch.move.connect( onTouchMove ) );
		this.owner.add( this.disposer );
		
		{	
			{
				var e : Entity = new Entity();
				var sprite : FillSprite = new FillSprite( 0xAAAAAA, Global.getPageWidth(), Global.getPageHeight() );
				sprite.x._ = Global.getPage1X();
				sprite.y._ = Global.getPage1Y();
				e.add( sprite );
				
				this.background.addChild( e );
			}
				
			{
				var e : Entity = new Entity();
				var sprite : FillSprite = new FillSprite( 0xAAAAAA, Global.getPageWidth(), Global.getPageHeight() );
				sprite.x._ = Global.getPage2X();
				sprite.y._ = Global.getPage2Y();
				e.add( sprite );
				
				this.background.addChild( e );
			}
		}
	}
	
	override public function onUpdate( l_dt : Float ) 
	{
		this.timeElapsed = l_dt;
		super.onUpdate( l_dt );
	}
	
	override public function dispose() 
	{
		super.dispose();
	}
	
	private function x1( v : Float = 0 ) : Float {
		return Global.getPage1X( v );
	}
	
	private function x2( v : Float = 0 ) : Float {
		return Global.getPage2X( v );
	}
	
	private function y1( v : Float = 0 ) : Float {
		return Global.getPage1Y( v );
	}
	
	private function y2( v : Float = 0 ) : Float {
		return Global.getPage2Y( v );
	}
	
	private function pageWidth() : Float {
		return Global.getPageWidth();
	}
	
	private function pageHeight() : Float {
		return Global.getPageHeight();
	}
	
	private function isWithinRect( l_x : Float, l_y : Float, l_rx : Float, l_ry : Float, l_rw : Float, l_rh : Float ) : Bool {
		return ( l_x >= l_rx ) &&
				( l_x <= ( l_rx + l_rw ) ) &&
				( l_y >= l_ry ) &&
				( l_y <= ( l_ry + l_rh ) );
		
	}
	
	private function isWithinPage1( l_x : Float, l_y : Float ) : Bool {
		return ( l_x >= x1() ) &&
				( l_x <= ( x1() + this.pageWidth() ) ) &&
				( l_y >= y1() ) &&
				( l_y <= ( y1() + this.pageHeight() ) );
	}
	
	private function isWithinPage2( l_x : Float, l_y : Float ) : Bool {
		return ( l_x >= x2() ) &&
				( l_x <= ( x2() + this.pageWidth() ) ) &&
				( l_y >= y2() ) &&
				( l_y <= ( y2() + this.pageHeight() ) );
	}
	
	private function onKeyUp( e : KeyboardEvent ) : Void {
	}
	
	private function onKeyDown( e : KeyboardEvent ) : Void {
	}
	
	private function onMouseDown( e : PointerEvent ) : Void {
	}
	
	private function onMouseUp( e : PointerEvent ) : Void {
	}
	
	private function onMouseMove( e : PointerEvent ) : Void {
	}
	
	private function onTouchMove( p : TouchPoint ) : Void {
	}
	
	private function onTouchDown( p : TouchPoint ) : Void {
	}
	
	private function onTouchUp( p : TouchPoint ) : Void {
	}
}