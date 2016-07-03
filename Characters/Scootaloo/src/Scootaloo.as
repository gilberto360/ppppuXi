package
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author 
	 */
	public class Scootaloo extends AnimatedCharacter 
	{
		
		public function Scootaloo() 
		{
			m_topLeftDiamondColor = CreateColorTransformFromHex(0xEF67A5);
			m_centerDiamondColor = CreateColorTransformFromHex(0xD7298F);
			m_bottomRightDiamondColor = CreateColorTransformFromHex(0x99258E);
			m_outerDiamondColor = CreateColorTransformFromHex(0xF6B7D2);
			m_backlightColor = CreateColorTransformFromHex(0x49FBE1);
			
			m_menuIcon = new ScootalooIcon();
			
			m_name = "Scootaloo"; 
			m_defaultMusicName = "CMC GC";
		}
		
	}
	
}