static ConVar hPluginEnabled = null;
static ConVar hServerIdentifier = null;
static ConVar hPlayerMargin = null;

stock void cvar_Setup()
{
    hPluginEnabled = CreateConVar("sm_gk_enabled", "0", "Gatekeepr enabled", _, true, 0.0, true, 1.0);
    hServerIdentifier = CreateConVar("sm_gk_svr_id", "", "Gatekeeper identifier for database (MUST BE SET, IF NOT THE PLUGIN WILL NOT LOG SERVER'S PLAYER)");
    hPlayerMargin = CreateConVar("sm_gk_plyr_margin", "4", "Gatekeeper player margin to enable player joining (if 4 then, when 28 <= players <= 32 in other server, can join this server)", _, true, 0.0);

    hPluginEnabled.AddChangeHook(OnPluginEnabledChange);
    hServerIdentifier.AddChangeHook(OnServerIdentifierChange);
    hPlayerMargin.AddChangeHook(OnPlayerMarginChange);
}

stock void cvar_ConfigSetup()
{
    g_bPluginEnabled = hPluginEnabled.BoolValue;

    hServerIdentifier.GetString(g_sServerIdentifier, sizeof(g_sServerIdentifier));
    g_bIdentifierExists = strlen(g_sServerIdentifier) != 0;

    g_iPlayerMargin = hPlayerMargin.IntValue;
}

public void OnPluginEnabledChange(ConVar convar, const char[] oldValue, const char[] newValue)
{
    g_bPluginEnabled = (StringToInt(newValue) != 0);
}

public void OnServerIdentifierChange(ConVar convar, const char[] oldValue, const char[] newValue)
{
    strcopy(g_sServerIdentifier, sizeof(g_sServerIdentifier), newValue);
    g_bIdentifierExists = strlen(g_sServerIdentifier) != 0;

    if(!g_bIdentifierExists)
    {
        LogPlayers(0, 0);
    }
}

public void OnPlayerMarginChange(ConVar convar, const char[] oldValve, const char[] newValue)
{
    g_iPlayerMargin = StringToInt(newValue);
}