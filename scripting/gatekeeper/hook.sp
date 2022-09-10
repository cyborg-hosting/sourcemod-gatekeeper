public void OnClientConnected(int client)
{
    if(client <= 0 || client > MaxClients)
    {
        return;
    }

    if(!IsClientConnected(client))
    {
        return;
    }

    g_iValidPlayers += 1;

    if(!g_bIdentifierExists)
    {
        return;
    }

    db_LogPlayers(g_iValidPlayers, MaxClients);
}

public void OnClientDisconnect(int client)
{
    if(client <= 0 || client > MaxClients)
    {
        return;
    }

    if(!IsClientConnected(client))
    {
        return;
    }

    g_iValidPlayers -= 1;

    if(!g_bIdentifierExists)
    {
        return;
    }

    db_LogPlayers(g_iValidPlayers, MaxClients);
}