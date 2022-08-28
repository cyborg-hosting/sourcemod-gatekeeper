public void OnClientPutInServer(int client)
{
    if(!IsValidClient(client))
    {
        return;
    }

    g_iValidPlayers += 1;

    if(g_iValidPlayers != 0)
    {
        g_bIsServerLocked = false;
    }

    if(!g_bIdentifierExists)
    {
        return;
    }

    LogPlayers(g_iValidPlayers, MaxClients);
}

public void OnClientDisconnect(int client)
{
    if(!IsValidClient(client))
    {
        return;
    } 

    g_iValidPlayers -= 1;

    if(g_iValidPlayers == 0)
    {
        g_bIsServerLocked = false;
    }

    if(!g_bIdentifierExists)
    {
        return;
    }

    LogPlayers(g_iValidPlayers, MaxClients);
}