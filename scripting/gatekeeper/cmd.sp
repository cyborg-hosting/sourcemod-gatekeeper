void cmd_OnPluginStart()
{
    RegAdminCmd("sm_gatekeeper_lock", cmd_LockServer, ADMFLAG_GENERIC, "Gatekeeper: Locks the server");
    RegAdminCmd("sm_gatekeeper_unlock", cmd_UnlockServer, ADMFLAG_GENERIC, "Gatekeeper: Unlocks the server");

    RegAdminCmd("sm_gatekeeper_toggle", cmd_ToggleLock, ADMFLAG_GENERIC, "Gatekeeper: Toggle lock of the server");
}

public Action cmd_LockServer(int client, int args)
{
    g_bIsServerLocked = true;    

    ReplyToCommand(client, "The server is locked by gatekeeper.");

    return Plugin_Continue;
}

public Action cmd_UnlockServer(int client, int args)
{
    g_bIsServerLocked = false;

    ReplyToCommand(client, "The server is unlocked by gatekeeper.");

    return Plugin_Continue;
}

public Action cmd_ToggleLock(int client, int args)
{
    g_bIsServerLocked = !g_bIsServerLocked;

    ReplyToCommand(client, "The server is %s by gatekeeper.", ((g_bIsServerLocked) ? "unlocked" : "locked"));

    return Plugin_Continue;
}