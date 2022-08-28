bool g_bPluginEnabled = false;
bool g_bIdentifierExists = false;
char g_sServerIdentifier[32] = "";
char g_sServerKickMessage[256] = "This server is closed now. Please consider going to our other server.";

int g_iPlayerMargin = 4;
int g_iValidPlayers = 0;


// Hud Settings

char g_sNotifyMessage[256] = "Server will be locked on map change.";
enum struct Hud
{
    float PosX;
    float PosY;

    int ColorRed;
    int ColorGreen;
    int ColorBlue;
}

Hud g_hud = {0.01, 0.01, 0, 255, 0};
