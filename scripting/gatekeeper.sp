#include <sourcemod>
#include <sdktools>
#include <connect>

#pragma semicolon 1
#pragma newdecls required

#define SV_LOCK_PASSWORD "adolfhitler"

public Plugin myinfo =
{
    name = "GateKeeper",
    author = "Monera",
    description = "This plugin prevents players joining when (primary) server is not full (or almost full).",
    version = "1.0.0",
    url = "https://github.com/plugins-for-hosting/sourcemod-gatekeeper/"
};

#include <gatekeeper/global.sp>
#include <gatekeeper/cvar.sp>
#include <gatekeeper/db.sp>
#include <gatekeeper/hook.sp>
#include <gatekeeper/lateload.sp>
#include <gatekeeper/misc.sp>
#include <gatekeeper/notify.sp>

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
    lateload_Set();

    return APLRes_Success;
}

// SourceMod Hooks

public void OnPluginStart()
{
    cvar_OnPluginStart();
    notify_OnPluginStart();

    lateload_Check();
}

public void OnConfigsExecuted()
{
    cvar_OnConfigsExecuted();

    notify_OnConfigsExecuted();

    lateload_DBQuery();
}

public void OnPluginEnd()
{
    if(!g_bIdentifierExists)
    {
        return;
    }

    db_LogPlayers(0, 0);
}

public void OnMapStart()
{
    notify_OnMapStart();
}

// Connect Extension Hook

public bool OnClientPreConnectEx(const char[] name, char password[255], const char[] ip, const char[] steamID, char rejectReason[255])
{
    if(!g_bPluginEnabled)
    {
        return true;
    }

    AdminId admin = FindAdminByIdentity(AUTHMETHOD_STEAM, steamID);

    if(GetAdminFlag(admin, Admin_Generic))
    {
        return true;
    }

    Database db = db_ConnectToDB();
    if(db == null)
    {
        return true;
    }

    int available = 1;
    if(!db_SelectServerAvailability(db, g_sServerIdentifier, available))
    {
        delete db;

        return true;
    }

    delete db;

    if(available != 0)
    {
        return true;
    }

    strcopy(rejectReason, 255, g_sServerKickMessage);
    strcopy(password, 255, SV_LOCK_PASSWORD);

    return false;
}

public void OnClientPostAdminCheck(int client)
{
    if(!g_bPluginEnabled)
    {
        return;
    }

    AdminId admin = GetUserAdmin(client);

    if(GetAdminFlag(admin, Admin_Generic))
    {
        return;
    }
    
    Database db = db_ConnectToDB();
    if(db == null)
    {
        return;
    }

    int available = 1;

    if(!db_SelectServerAvailability(db, g_sServerIdentifier, available))
    {
        delete db;

        return;
    }

    delete db;

    if(available != 0)
    {
        return;
    }

    KickClient(client, "%s", g_sServerKickMessage);
}