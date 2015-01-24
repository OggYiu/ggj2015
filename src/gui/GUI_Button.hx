package gui;
import flambe.display.ImageSprite;
import flambe.display.Texture;
import flambe.Disposer;
import flambe.input.PointerEvent;
import flambe.System;

/**
 * ...
 * @author ragbit
 */
class GUI_Button extends ImageSprite
{
	public static var DOWN : String = "down";
	public static var UP : String = "up";
	public static var CANCELED : String = "canceled";
	
	private var normalTexture : Texture;
	private var pressedTexture : Texture;
	private var func_ : String -> Void;
	
	public function new( l_normalTexture : Texture, l_pressedTexture : Texture, func : String -> Void ) 
	{
		normalTexture = l_normalTexture;
		pressedTexture = l_pressedTexture;
		func_ = func;
		
		super( normalTexture ); 
	}
	
	override public function onAdded() : Void 
	{
		super.onAdded();
		
		var disposer = owner.get( Disposer );
		
		if ( disposer == null ) {
			owner.add( disposer = new Disposer() );
		}
		
		disposer.add( this.pointerDown.connect( onPressed ) ); 
		disposer.add( this.pointerUp.connect( onRelease ) );
		disposer.add( this.pointerOut.connect( onOut ) );
	}
	
	private function onPressed( e : PointerEvent ) : Void {
		this.texture = this.pressedTexture;
		
		if ( func_ != null ) {
			func_( GUI_Button.DOWN );
		}
	}
	
	private function onRelease( e : PointerEvent ) : Void {
		this.texture = this.normalTexture;
		
		if ( func_ != null ) {
			func_( GUI_Button.UP );
		}
	}
	
	private function onOut( e : PointerEvent ) : Void {
		this.texture = this.normalTexture;
		
		if ( func_ != null ) {
			func_( GUI_Button.CANCELED );
		}
	}
}