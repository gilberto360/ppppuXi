﻿package 
{
	import events.AnimationTransitionEvent;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	/**
	 * ...
	 * @author 
	 */
	public class AnimatedCharacter 
	{
		//The name of the character
		protected var m_name:String = null;
		
		/*The vector that contains all animation movieclips for the character.*/
		protected var m_charAnimations:Vector.<MovieClip> = new Vector.<MovieClip>();
		//animation labels are used to tell which animations are linked.
		protected var m_animationLabel:Vector.<String> = new Vector.<String>();
		
		private var m_currentlyPlayingAnimation:MovieClip = null;
		//The id of the characters animation collection that is slated to play or is playing currently. -1 indicates nothing is playing.
		private var m_currentAnimationId:int = -1;
		/*Background colors*/
		//The current colors of the background elements for the character
		protected var m_backgroundColors:Object;
		//The original colors set for the character
		protected var m_topLeftDiamondColor:ColorTransform = new ColorTransform();
		protected var m_centerDiamondColor:ColorTransform = new ColorTransform(); //For the top right and bottom left sections of the diamond
		protected var m_bottomRightDiamondColor:ColorTransform = new ColorTransform();
		protected var m_outerDiamondColor:ColorTransform = new ColorTransform();
		protected var m_backlightColor:ColorTransform = new ColorTransform();
		
		//The name of the music to play for the character.
		protected var m_defaultMusicName:String = "Beep Block Skyway";
		
		public var test:MovieClip;
		//private var m_playAnimationId:int = 0;
		//Indicates whether the animation to play is to be randomly chosen.
		private var m_randomizePlayAnim:Boolean = true;
		private var m_lockedAnimation:Vector.<Boolean> = new Vector.<Boolean>(); //Keeps track if an animation can be switched to.
		
		//Graphic used to represent the character on the menu
		protected var m_menuIcon:Sprite = null;
		
		/*Index targets is used to maintain a key-value pairing of the accessible animations id (starts from 0) to a specific index
		 * of charAnimations that contains an animation. This is done as certain animations may not be intended to be accessible 
		 * by normal means.*/
		private var m_idTargets:Vector.<int> = new Vector.<int>();
		
		//The frame in the current animation to switch to the linked animation. 
		private var frameToTransitionToLinkedAnimation:int = -1;
		/*The index of the animation in the character animations vector that will be switched to when the current animation reaches
		* the frame denoted in the above variable (frameToTransitionToLinkedAnimation)*/
		private var queuedLinkedAnimationIndex:int = -1;
		/*Indicates if the character is still in their linked animation, which are able to be set to loop a section endlessly until the 
		 * character or animation is switched by the user.*/
		private var isInLinkedAnimation:Boolean = false;
		
		private var displayArea:Sprite = new Sprite();
		
		public function AnimatedCharacter() 
		{
			
		}
		
		//Resets the background colors object to the default values set for the character.
		public function SetBackgroundColorsToDefault():void
		{
			m_backgroundColors = { inDiaTL:m_topLeftDiamondColor, inDiaCen:m_centerDiamondColor, inDiaBR:m_bottomRightDiamondColor, 
				outDia: m_outerDiamondColor,light:m_backlightColor };
		}
		
		//Returns an object containing the current colors to use for background elements.
		public function GetBackgroundColors():Object
		{
			return m_backgroundColors;
		}
		
		public function IsValidCharacter():Boolean	{return (m_name != null && m_menuIcon != null);}
		
		public function GetName():String	{return m_name;}
		public function GetIcon():Sprite	{ return m_menuIcon; }
		
		public function GetDefaultMusicName():String	{return m_defaultMusicName;}
		
		public function UpdateBackgroundColors():void
		{
			
		}
		
		private function UpdateIdTargets():void
		{
			m_idTargets = new Vector.<int>();
			var inaccessibleIndices:Vector.<int> = new Vector.<int>();
			var label:String;
			for (var x:int = 0; x < m_animationLabel.length; ++x)
			{
				label = m_animationLabel[x] as String;
				//"Into_" must be found in the name at the first position of the string (0) for the labeled animation to be 
				//accessible via normal means.
				if (label != null && label.length > 0 && label.indexOf("Into_") != 0)
				{
					inaccessibleIndices[inaccessibleIndices.length] = x;
				}
			}
			for (var i:int = 0; i < m_charAnimations.length; ++i)
			{
				if (inaccessibleIndices.indexOf(i) == -1)
				{
					m_idTargets[m_idTargets.length] = i;
				}
			}
		}
		
		//Adds multiple animations from a single multi framed movieclip, in which each of those frames containing an animation.
		public function AddAnimationsFromMovieClip(animationCollection:MovieClip):void
		{
			//TODO: Reactivate commented out code.
			for (var i:int = 1; i <= animationCollection.totalFrames; ++i)
			{
				animationCollection.gotoAndStop(i);
				var animationIndex:int = m_charAnimations.length;
				
				var label:String = animationCollection.currentFrameLabel;
				var isLinkedEndAnimation:Boolean = false;
				if (label && label.indexOf("Into_") != 0)
				{
					isLinkedEndAnimation = true;
				}
				//Animation labels are not allowed to overwrite each other
				if (label && m_animationLabel.indexOf(label) != -1)
				{
					label = null;
				}
				var animationClass:Class = Object(animationCollection.getChildAt(0)).constructor;
				var animation:DisplayObject = new animationClass();
				if (animation && (animation as MovieClip).totalFrames > 1)
				{
					(animation as MovieClip).stop();
					if (isLinkedEndAnimation == false)
					{
						//add animation
						m_charAnimations[animationIndex] = animation/*animationCollection.getChildAt(0)*/ as MovieClip;
						m_animationLabel[animationIndex] = label; //add label
						m_lockedAnimation[m_lockedAnimation.length] = false;
						
					}
					else if (isLinkedEndAnimation == true && label != null)
					{
						m_charAnimations[animationIndex] = animation/*animationCollection.getChildAt(0)*/ as MovieClip;
						m_animationLabel[animationIndex] = label; //add label
						//No need to worry about the animation's lock since linked end animations are unaccessible by normal means anyway.
					}
					//m_charAnimations[animationIndex].stop();
				}
				
				
				//animationCollection.removeChild(m_charAnimations[animationIndex]);
				
			}
			//Allow the movie clip to be garbage collected
			animationCollection.removeChildren();
			animationCollection = null;
			UpdateIdTargets();
		}
		
		//Adds a movieclip to the character's animation vector. An animation added this way can not be linked to another.
		public function AddAnimation(animation:MovieClip):void
		{
			//TODO: Complete function
			UpdateIdTargets();
		}
		
		[inline]
		public function StopAnimation():void
		{
			if (m_currentlyPlayingAnimation)
			{
				if (m_currentlyPlayingAnimation.isPlaying)
				{
					m_currentlyPlayingAnimation.stop();
				}
			}
		}
		
		public function GetCurrentAnimationId():int
		{
			return m_currentAnimationId;
		}
		
		public function SetRandomizeAnimation(randomStatus:Boolean):void
		{
			m_randomizePlayAnim = randomStatus;
		}
		public function GetRandomAnimStatus() : Boolean
		{
			return m_randomizePlayAnim;
		}
		
		public function RandomizePlayAnim():void
		{
			if(m_randomizePlayAnim)
			{
				//Randomly select a number out of the number of accessible animations
				var accessibleAnimationCount:int = GetNumberOfAccessibleAnimations();
				var randomAnimIndex:int = Math.floor(Math.random() * accessibleAnimationCount);
				
				if((accessibleAnimationCount - GetNumberOfLockedAnimations()) > 2)
				{
					while(randomAnimIndex == m_currentAnimationId || GetAnimationLockedStatus(randomAnimIndex))
					{
						randomAnimIndex = Math.floor(Math.random() * accessibleAnimationCount);
					}
				}
				else
				{
					while(GetAnimationLockedStatus(randomAnimIndex))
					{
						randomAnimIndex = Math.floor(Math.random() * accessibleAnimationCount);
					}
				}
				ChangeAnimationIndexToPlay(randomAnimIndex);
			}
		}
		
		public function SetLockOnAnimation(animId:int, lockValue:Boolean):void
		{
			var indexForId:int = m_idTargets.indexOf(animId);
			/*Conditions that will not have a set locked:
			 * 1) index for id [id target] is -1 (animation id did not belong to an accessible animation). 
			 * 2) if lockValue is true: setting the lock on the given animation will lead to all animations being locked.*/
			if( indexForId == -1 || (lockValue == true && GetNumberOfLockedAnimations() + 1 >= GetNumberOfAccessibleAnimations()) )
			{
				return;
			}
			m_lockedAnimation[indexForId] = lockValue;
		}
		
		public function GetTotalNumberOfAnimations():int
		{
			return m_charAnimations.length;
		}
		
		/*"accessible" animations are animations that are not end linked animations (meaning, they must be manually activated by the user
		 * with a special command)*/
		[inline]
		public function GetNumberOfAccessibleAnimations():int
		{
			return m_idTargets.length;
		}
		
		[inline]
		private function GetNumberOfLockedAnimations():int
		{
			var lockedAnimNum:int = 0;
			for(var i:int = 0, l:int = m_lockedAnimation.length; i < l; ++i)
			{
				if(m_lockedAnimation[i] == true)
				{
					++lockedAnimNum;
				}
			}
			return lockedAnimNum;
		}
		
		public function PlayingLockedAnimCheck():void
		{
			//Only 1 animation is available, so search for it and use it.
			var accessibleId:int = GetIdTargetForIndex(m_currentAnimationId);
			if (accessibleId == -1) { return;}
			if(GetAnimationLockedStatus(accessibleId) && (GetNumberOfAccessibleAnimations() - GetNumberOfLockedAnimations() == 1))
			{
				var unlockedAnimNum:int = 0;
				for each(var locked:Boolean in m_lockedAnimation)
				{
					if(!locked)
					{
						break;
					}
					++unlockedAnimNum;
				}
				ChangeAnimationIndexToPlay(unlockedAnimNum);
			}
		}
		
		public function CheckAndSetupLinkedTransition():Boolean
		{
			var linkedAnimationIndex:int = -1;
			var currLabel:String = m_animationLabel[m_currentAnimationId];// m_charAnimations.currentFrameLabel;
			if (currLabel == null || currLabel.indexOf("Into_") == -1) 
			{ 
				return false;
			}
			
			var labelSearchingFor:String = currLabel.replace("Into_", "");
			var labels:Vector.<String> = m_animationLabel;
			for (var x:int = 0, y:int = labels.length; x < y; ++x )
			{
				var label:String = labels[x] as String;
				if (label != null && label == labelSearchingFor)
				{
					linkedAnimationIndex = x;
					break;
				}
			}
			if (linkedAnimationIndex == -1) { return false; }
		
			//Now to check the linked animation to do things
			var currentAnimation:MovieClip = m_currentlyPlayingAnimation;
			var frameLabels:Array = currentAnimation.currentLabels;
			var startFrame:int = -1, endFrame:int = -1;
			for (var i:int = 0, l:int = frameLabels.length; i < l; ++i )
			{
				var animationLabel:FrameLabel = frameLabels[i] as FrameLabel;
				if (animationLabel.name == "ActivateStart")
				{
					startFrame = animationLabel.frame;
				}
				else if (animationLabel.name == "ActivateEnd")
				{
					endFrame = animationLabel.frame;
				}
			}
			if (endFrame > -1)
			{
				if (startFrame > -1)
				{
					if (currentAnimation.currentFrame >= startFrame && currentAnimation.currentFrame <= endFrame)
					{
						frameToTransitionToLinkedAnimation = endFrame;
						queuedLinkedAnimationIndex = linkedAnimationIndex;
						currentAnimation.addEventListener(Event.ENTER_FRAME, TryChangingToQueuedAnimation);
						return true;
					}
				}
				else
				{
					if (currentAnimation.currentFrame <= endFrame)
					{
						frameToTransitionToLinkedAnimation = endFrame;
						queuedLinkedAnimationIndex = linkedAnimationIndex;
						currentAnimation.addEventListener(Event.ENTER_FRAME, TryChangingToQueuedAnimation);
						return true;
					}
				}
			}
			return false;
		}
		
		public function RemoveFromDisplay():void
		{
			displayArea.removeChildren();
			if (displayArea.parent != null)	{displayArea.parent.removeChild(displayArea);}
		}
		
		private function TryChangingToQueuedAnimation(e:Event):void
		{
			if (e.target.currentFrame == this.frameToTransitionToLinkedAnimation)
			{
				this.ChangeAnimationIndexToPlay(queuedLinkedAnimationIndex);
				this.GotoFrameAndPlayForCurrentAnimation(1);
				frameToTransitionToLinkedAnimation = -1;
				queuedLinkedAnimationIndex = -1;
				e.target.removeEventListener(Event.ENTER_FRAME, TryChangingToQueuedAnimation);
				isInLinkedAnimation = true;
				displayArea.dispatchEvent(new Event(AnimationTransitionEvent.ANIMATION_TRANSITIONED));
			}
			//Makes sure that if somehow it misses the transition to abort and remove the event listener.
			if (e.target.currentFrame == e.target.totalFrames)
			{
				frameToTransitionToLinkedAnimation = -1;
				queuedLinkedAnimationIndex = -1;
				e.target.removeEventListener(Event.ENTER_FRAME, TryChangingToQueuedAnimation);
				//Even though the transition is unable to activate, this event needs to be dispatched so any listeners can remove any sort 
				//of locks put in place for animation transitions.
				displayArea.dispatchEvent(new Event(AnimationTransitionEvent.ANIMATION_TRANSITIONED));
				isInLinkedAnimation = false;
			}
		}
		
		public function GotoFrameAndPlayForCurrentAnimation(animationFrame:int):void
		{
			//StopAnimation();
			//select the animation to play
			//AddCharacterToDisplay();
			//m_charAnimations.gotoAndStop(m_playAnimationFrame);
			//if (displayArea.numChildren > 0) { displayArea.removeChildren();}
			if (m_currentAnimationId < 0 || m_charAnimations.length == 0)	{ return; }
			
			//and set this animation's frame number to reflect where it would be if animations weren't changed on a whim
			var animation:MovieClip = m_charAnimations[m_currentAnimationId];
			if(animation)
			{
				//displayArea.addChild(animation);
				//animation.nextFrame();
				animation.gotoAndPlay(animationFrame);
				//animation.play();
			}
			//test.gotoAndStop(m_currentAnimationId);
			//(test.getChildAt(0) as MovieClip).gotoAndPlay(animationFrame);
			/*if (test.numChildren == 1 )
			{
				displayArea.addChild(test.getChildAt(0));
			}
			(test).gotoAndStop(m_currentAnimationId+1);
			(displayArea.getChildAt(0) as MovieClip).gotoAndPlay(animationFrame);
			trace(displayArea.getChildAt(0).toString());*/
			
			
		}
		
		public function AddToDisplay(parent:DisplayObjectContainer):void
		{
			parent.addChild(displayArea);
		}
		
		public function IsStillInLinkedAnimation():Boolean
		{
			return isInLinkedAnimation;
		}
		
		public function ChangeInLinkedAnimationStatus(value:Boolean):void
		{
			isInLinkedAnimation = value;
		}
		
		[inline]
		private function GetIdTargetForIndex(index:int):int
		{
			return m_idTargets.indexOf(index);
		}
		
		public function GetAnimationLockedStatus(animIndex:int):Boolean
		{
			var idTarget:int = GetIdTargetForIndex(animIndex);
			if (idTarget == -1) { return false; }
			else
				return m_lockedAnimation[idTarget];
		}
		
		public function GetAnimationLocks():Vector.<Boolean>
		{
			return m_lockedAnimation;
		}
		
		/* Chnages the id of the animation to play and adds the appropriate animation to the display area.
		* Parameter "animIndex" - the index of the character animations vector to pull the animation from and place on the display area.
		* Result: -1 doesn't change the current animation id. Values >= 0 get the animation from the animations vector.
		* */
		public function ChangeAnimationIndexToPlay(animIndex:int=-1):void
		{
			if (animIndex > -1)	{ m_currentAnimationId = animIndex /*+ 1*/; }
			
			if (displayArea.numChildren == 1) 
			{ 
				(displayArea.getChildAt(0) as MovieClip).stop();  
				displayArea.removeChildAt(0); 
				m_currentlyPlayingAnimation = null;
			}
			
			if (m_currentAnimationId > -1 && m_currentAnimationId < m_charAnimations.length && displayArea.numChildren == 0)
			{
				m_currentlyPlayingAnimation = m_charAnimations[m_currentAnimationId];
				displayArea.addChild(m_charAnimations[m_currentAnimationId]);
			}
		}
		
		public function GetAnimationIdTargets():Vector.<int>
		{
			return m_idTargets;
		}
		
		protected function CreateColorTransformFromHex(colorValue:uint, alpha:uint = 255):ColorTransform
		{
			var ct:ColorTransform = new ColorTransform();
			ct.color = colorValue;
			if (alpha != 255)
			{
				if (alpha > 255) { alpha = 255; }
				ct.alphaMultiplier = 0;
				ct.alphaOffset = alpha;
			}
			return ct;
		}
	}

}