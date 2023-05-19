using UnrealBuildTool;

public class BP_RTSTarget : TargetRules
{
	public BP_RTSTarget(TargetInfo Target) : base(Target)
	{
		DefaultBuildSettings = BuildSettingsVersion.V2;
		Type = TargetType.Game;
		ExtraModuleNames.Add("BP_RTS");
	}
}
