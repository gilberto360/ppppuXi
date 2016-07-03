package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	
	/**
	 * ...
	 * @author 
	 */
	public class Iris extends AnimatedCharacter 
	{
		
		public function Iris() 
		{
			m_topLeftDiamondColor = CreateColorTransformFromHex(0xBC508D);
			m_centerDiamondColor = CreateColorTransformFromHex(0xB43C76);
			m_bottomRightDiamondColor = CreateColorTransformFromHex(0xA03167);
			m_outerDiamondColor = CreateColorTransformFromHex(0x8F2C5B);
			m_backlightColor = new ColorTransform(0,0,0,0);
			
			m_menuIcon = new AAIcon();
			
			m_name = "Iris"; 
			m_defaultMusicName = "Turnabout Sisters";
		}
		
	}
	
}