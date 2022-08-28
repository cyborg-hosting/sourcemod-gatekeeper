static bool lateload = false;

void lateload_Set()
{
    lateload = true;
}

void lateload_Check()
{
    if(!lateload)
    {
        return;
    }

    g_iValidPlayers = 0;

    for(int i = 1; i <= MaxClients; i++)
    {
        if(!IsValidClient(i))
        {
            continue;
        }

        g_iValidPlayers += 1;
    }
}

void lateload_DBQuery()
{
    if(!lateload)
    {
        return;
    }

    if(!g_bIdentifierExists)
    {
        return;
    }

    db_LogPlayers(g_iValidPlayers, MaxClients);
}