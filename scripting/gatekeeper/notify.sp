#define ALERT_SOUND "ui/system_message_alert.wav"

static Handle timer = null;

static Handle hudText = null;

void notify_OnPluginStart()
{
	hudText = CreateHudSynchronizer();
	if(hudText == null) {
		LogMessage("HUD text is not supported on this mod. The persistant timer will not display.");
	} else {
		LogMessage("HUD text is supported on this mod. The persistant timer will display.");
	}
}

void notify_OnMapStart()
{
    PrecacheSound(ALERT_SOUND);
}

void notify_StartTimer()
{
    if(timer == null)
    {
        timer = CreateTimer(1.0, notify_OnTimerFire, _, TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);
    }
}

void notify_StopTimer()
{
    delete timer;
}

public Action notify_OnTimerFire(Handle timer)
{
    notify_PrintHudText();
}

void notify_PrintHudText()
{
    if(hudText != null)
    {
        SetHudTextParams(g_hud.PosX, g_hud.PosY, 1.0, g_hud.ColorRed, g_hud.ColorGreen, g_hud.ColorBlue, 255);

        for(int i = 1; i <= MaxClients; i++)
        {
            if(!IsValidClient(i))
            {
                continue;
            }

            ShowSyncHudText(i, hudText, g_sNotifyMessage);
        }
    }
}