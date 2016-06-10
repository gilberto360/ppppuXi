package
{
	import flash.display.MovieClip;
	import flash.geom.ColorTransform;
	
	/**
	 * ...
	 * @author 
	 */
	public class Isabelle extends AnimatedCharacter 
	{
		
		public function Isabelle()
		{
			m_topLeftDiamondColor = CreateColorTransformFromHex(0xFFEC9B);
			m_centerDiamondColor = CreateColorTransformFromHex(0xEAC033);
			m_bottomRightDiamondColor = CreateColorTransformFromHex(0x55482A);
			m_backgroundColor = CreateColorTransformFromHex(0x956329);
			//m_backlightColor = new ColorTransform(1.0, 1.0, 1.0, 1.0, 156, -22, -103);
			m_charAnimations = new IsabelleAnimations();
			m_charAnimations.x = -54.75;
			m_charAnimations.y = 92;
			m_menuButton = new IsabelleButton();
			var isabelleHitArea:SquareBtnHitArea = new SquareBtnHitArea(79, 75);
			m_menuButton.SetHitArea(isabelleHitArea);
			m_name = "Isabelle";
			m_musicClassName = m_name + "BGM";
			m_musicTitle = "2:00 A.M. - Super Smash Bros. Brawl";
			m_musicStartPoint = ConvertSamplesToMilliseconds(576);
			m_musicLoopStartPoint = ConvertSamplesToMilliseconds(190538+576);
			m_musicLoopEndPoint = -(ConvertSamplesToMilliseconds(618) + m_musicStartPoint);
		}
		
	}

}