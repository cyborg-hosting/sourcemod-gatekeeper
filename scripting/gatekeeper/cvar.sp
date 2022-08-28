static ConVar hPluginEnabled = null;
static ConVar hServerIdentifier = null;
static ConVar hPlayerMargin = null;

static ConVar hKickMessage = null;

// HUD SETTINGS
static ConVar hNotifyMessage = null;

static ConVar hHudXCvar = null;
static ConVar hHudYCvar = null;
static ConVar hHudRCvar = null;
static ConVar hHudGCvar = null;
static ConVar hHudBCvar = null;


stock void cvar_OnPluginStart()
{
    hPluginEnabled = CreateConVar("sm_gatekeeper_enabled", "0", "Gatekeeper enabled", _, true, 0.0, true, 1.0);
    hServerIdentifier = CreateConVar("sm_gatekeeper_server_id", "", "Gatekeeper identifier for database (MUST BE SET, IF NOT THE PLUGIN WILL NOT LOG SERVER'S PLAYER)");
    hPlayerMargin = CreateConVar("sm_gatekeeper_player_margin", "4", "Gatekeeper player margin to enable player joining (if 4 then, when 28 <= players <= 32 in other server, can join this server)", _, true, 0.0);

    hKickMessage = CreateConVar("sm_gatekeeper_kick_msg", "This server is closed now. Please consider going to our other server.", "Gatekeeper Kick Message");

    hPluginEnabled.AddChangeHook(OnPluginEnabledChange);
    hServerIdentifier.AddChangeHook(OnServerIdentifierChange);
    hPlayerMargin.AddChangeHook(OnPlayerMarginChange);

    hKickMessage.AddChangeHook(OnKickMessageChange);

    // HUD SETTINGS
    hNotifyMessage = CreateConVar("sm_gatekeeper_notify_message", "Server will be locked on map change.", "Gatekeeper Hud Message for notifying lock");

    hHudXCvar = CreateConVar("sm_gatekeeper_hud_text_x_pos", "0.01", "X-position for HUD timer (only on supported games) -1 = center", _, true, -1.0, true, 1.0);
    hHudYCvar = CreateConVar("sm_gatekeeper_hud_text_y_pos", "0.01", "Y-position for HUD timer (only on supported games) -1 = center", _, true, -1.0, true, 1.0);
    hHudRCvar = CreateConVar("sm_gatekeeper_hud_text_red", "0", "Amount of red for the HUD timer (only on supported games)", _, true, 0.0, true, 255.0);
    hHudGCvar = CreateConVar("sm_gatekeeper_hud_text_green", "255", "Amount of red for the HUD timer (only on supported games)", _, true, 0.0, true, 255.0);
    hHudBCvar = CreateConVar("sm_gatekeeper_hud_text_blue", "0", "Amount of red for the HUD timer (only on supported games)", _, true, 0.0, true, 255.0);

    hNotifyMessage.AddChangeHook(OnNotifyMessageChange);

    hHudXCvar.AddChangeHook(OnHudXChange);
    hHudYCvar.AddChangeHook(OnHudYChange);
    hHudRCvar.AddChangeHook(OnHudRChange);
    hHudGCvar.AddChangeHook(OnHudGChange);
    hHudBCvar.AddChangeHook(OnHudBChange);
}

stock void cvar_OnConfigsExecuted()
{
    g_bPluginEnabled = hPluginEnabled.BoolValue;

    hServerIdentifier.GetString(g_sServerIdentifier, sizeof(g_sServerIdentifier));
    g_bIdentifierExists = strlen(g_sServerIdentifier) != 0;

    g_iPlayerMargin = hPlayerMargin.IntValue;

    hKickMessage.GetString(g_sServerKickMessage, sizeof(g_sServerKickMessage));

    // HUD SETTINGS
    hNotifyMessage.GetString(g_sNotifyMessage, sizeof(g_sNotifyMessage));

    g_hud.PosX = hHudXCvar.FloatValue;
    g_hud.PosY = hHudYCvar.FloatValue;
    g_hud.ColorRed = hHudRCvar.IntValue;
    g_hud.ColorGreen = hHudGCvar.IntValue;
    g_hud.ColorBlue = hHudBCvar.IntValue;
}

public void OnPluginEnabledChange(ConVar convar, const char[] oldValue, const char[] newValue)
{
    g_bPluginEnabled = StringToInt(newValue) != 0;
}

public void OnServerIdentifierChange(ConVar convar, const char[] oldValue, const char[] newValue)
{
    g_bIdentifierExists = strlen(g_sServerIdentifier) != 0;

    if(!g_bIdentifierExists)
    {
        db_LogPlayers(0, 0);
    }

    strcopy(g_sServerIdentifier, sizeof(g_sServerIdentifier), newValue);
}

public void OnPlayerMarginChange(ConVar convar, const char[] oldValve, const char[] newValue)
{
    g_iPlayerMargin = StringToInt(newValue);
}

public void OnKickMessageChange(ConVar convar, const char[] oldValue, const char[] newValue)
{
    strcopy(g_sServerKickMessage, sizeof(g_sServerKickMessage), newValue);
}

// HUD CONVAR CHANGE HOOK

public void OnNotifyMessageChange(ConVar convar, const char[] oldValue, const char[] newValue)
{
    strcopy(g_sNotifyMessage, sizeof(g_sNotifyMessage), newValue);
}

public void OnHudXChange(ConVar convar, const char[] oldValue, const char[] newValue)
{
    g_hud.PosX = StringToFloat(newValue);
}

public void OnHudYChange(ConVar convar, const char[] oldValue, const char[] newValue)
{
    g_hud.PosY = StringToFloat(newValue);
}

public void OnHudRChange(ConVar convar, const char[] oldValue, const char[] newValue)
{
    g_hud.ColorRed = StringToInt(newValue);
}

public void OnHudGChange(ConVar convar, const char[] oldValue, const char[] newValue)
{
    g_hud.ColorGreen = StringToInt(newValue);
}

public void OnHudBChange(ConVar convar, const char[] oldValue, const char[] newValue)
{
    g_hud.ColorBlue = StringToInt(newValue);
}