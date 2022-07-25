#include <sourcemod>
#include <connect>

#pragma semicolon 1
#pragma newdecls required

public Plugin myinfo =
{
    name = "GateKeeper",
    author = "Monera",
    description = "This plugin prevents players joining when (primary) server is not full (or almost full).",
    version = "1.0.0",
    url = "https://github.com/plugins-for-hosting/sourcemod-gatekeeper/"
};

bool g_bPluginEnabled = false;
bool g_bIdentifierExists = false;

char g_sServerIdentifier[32] = "";

int g_iPlayerMargin = 4;
int g_iValidPlayers = 0;

#include <gatekeeper/cvar.sp>
#include <gatekeeper/db.sp>
#include <gatekeeper/hook.sp>
#include <gatekeeper/lateload.sp>
#include <gatekeeper/misc.sp>

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
    lateload_Set();
}

// SourceMod Hooks

public void OnPluginStart()
{
    cvar_Setup();

    lateload_Check();
}

public void OnConfigsExecuted()
{
    cvar_ConfigSetup();

    lateload_DBQuery();
}

public void OnPluginEnd()
{
    LogPlayers(0, 0);
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
        return true;
    }

    if(available != 0)
    {
        return true;
    }

    strcopy(rejectReason, 255, "This server is closed now. Please consider going to our other server.");

    return false;
}