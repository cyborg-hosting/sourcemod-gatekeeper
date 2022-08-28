static char sCreateTable[] = "CREATE TABLE IF NOT EXISTS `current_player` ( \
    `id` INT NOT NULL AUTO_INCREMENT, \
    `server` VARCHAR(32), \
    `player` INT NOT NULL, \
    `maxplayer` INT NOT NULL, \
    PRIMARY KEY (`id`) \
);";

static char sInsertPlayer[] = "INSERT INTO `current_player` (`server`, `player`, `maxplayer`) VALUES ('%s', %d, %d);";
static char sSelectPlayer[] = "SELECT 1 = ALL( \
    SELECT (`maxplayer` - `player` <= %d) as `condition` \
    FROM ( \
        SELECT `id`, \
               `server`, \
               `player`, \
               `maxplayer`, \
               ROW_NUMBER() OVER (PARTITION BY `server` ORDER BY `id` DESC) as `server_rank` \
        FROM `current_player` \
        WHERE `server` != '%s' \
    ) as `ranks` \
    WHERE `server_rank` = 1 \
) as `condition`;";

static char temp[1024];


stock Database db_ConnectToDB()
{
    static bool bConnection = false;

    Database db = null;
    char error[256];

    if(SQL_CheckConfig("gatekeeper"))
    {
        db = SQL_Connect("gatekeeper", true, error, sizeof(error));
    }
    else
    {
        db = SQL_Connect("default", true, error, sizeof(error));
    }

    if(db == null)
    {
        LogError("Could not connect to the database: %s", error);

        return null;
    }

    if(!bConnection)
    {
        bConnection = CreateTable(db);	
    }

    if(!bConnection)
    {
        return null;
    }	

    return db;
}

stock bool CreateTable(Database db)
{
    bool connection = true;

    connection = connection && SQL_FastQuery(db, sCreateTable);

    return connection;
}

bool db_InsertServerPlayer(Database db, const char[] server, int player, int maxplayer)
{
    int escapedServerLength = 2 * strlen(server) + 1;
    char[] escapedServer = new char[escapedServerLength];
    SQL_EscapeString(db, server, escapedServer, escapedServerLength);

    int queryStatementLength = sizeof(sInsertPlayer) + strlen(escapedServer) + 22;
    char[] queryStatement = new char[queryStatementLength];
    Format(queryStatement, queryStatementLength, sInsertPlayer, escapedServer, player, maxplayer);

    return FastQuery(db, queryStatement);
}

bool db_SelectServerAvailability(Database db, const char[] server, int &available)
{
    int escapedServerLength = 2 * strlen(server) + 1;
    char[] escapedServer = new char[escapedServerLength];
    SQL_EscapeString(db, server, escapedServer, escapedServerLength);

    int queryStatementLength = sizeof(sSelectPlayer) + 11 + strlen(escapedServer);
    char[] queryStatement = new char[queryStatementLength];
    Format(queryStatement, queryStatementLength, sSelectPlayer, g_iPlayerMargin, escapedServer);

    return SelectIntegerQuery(db, queryStatement, available);
}

stock bool FastQuery(Database db, const char[] queryStatement)
{
    char error[255];

    if(!SQL_FastQuery(db, queryStatement))
    {
        SQL_GetError(db, error, sizeof(error));
        LogError("Could not query to database: %s", error);

        return false;
    }

    return true;
}

stock bool SelectIntegerQuery(Database db, const char[] queryStatement, int &data)
{
    char error[255];

    DBResultSet hQuery;

    if((hQuery = SQL_Query(db, queryStatement)) == null)
    {
        SQL_GetError(db, error, sizeof(error));
        LogError("Could not query to database: %s", error);

        return false;
    }

    if(SQL_FetchRow(hQuery))
    {
        data = SQL_FetchInt(hQuery, 0);
    }

    delete hQuery;

    return true;
}

// Notify

public Action db_NotifyOnQueryTimerFire(Handle timer)
{
    if(SQL_CheckConfig("gatekeeper"))
    {
        Database.Connect(db_NotifyOnDatabaseConnect, "gatekeeper");
    }
    else
    {
        Database.Connect(db_NotifyOnDatabaseConnect, "default");
    }

    return Plugin_Continue;
}

public void db_NotifyOnDatabaseConnect(Database db, const char[] error, any data)
{
    if(db == null)
    {
        return;
    }

    db.Format(temp, sizeof(temp), sSelectPlayer, g_iPlayerMargin, g_sServerIdentifier);

    db.Query(db_NotifyOnQuery, temp);
}

public void db_NotifyOnQuery(Database db, DBResultSet results, const char[] error, any data)
{
    if(!results.FetchRow())
    {
        notify_StopTimer();

        delete db;

        return;
    }

    int available = results.FetchInt(0);

    if(available == 0)
    {
        notify_StartTimer();
    }
    else
    {
        notify_StopTimer();
    }

    delete db;
}