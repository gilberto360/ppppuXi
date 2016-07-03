package 
{
	import flash.geom.ColorTransform;
	/**
	 * ...
	 * @author 
	 */
	public class Fiora extends AnimatedCharacter 
	{
		
		public function Fiora() 
		{
			m_topLeftDiamondColor = CreateColorTransformFromHex(0xBDCEEC);
			m_centerDiamondColor = CreateColorTransformFromHex(0x98B4DC);
			m_bottomRightDiamondColor = CreateColorTransformFromHex(0x7C99C3);
			m_outerDiamondColor = CreateColorTransformFromHex(0x494E62);
			m_backlightColor = new ColorTransform(0, 0, 0, 0);
			
			m_menuIcon = new XenoIcon();
			
			m_name = "Fiora";
			m_defaultMusicName = "Gaur Plain";
		}
		
	}

}