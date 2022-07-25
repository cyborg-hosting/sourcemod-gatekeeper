# SOURCEMOD-GATEKEEPER

This is a plugin for blocking people from joining server when primary server is not full.

## Console Variables

* sm_gk_enabled (defaults to 0)
  * Whether this plugin should block players joining when conditions is not satisfied
* sm_gk_svr_id (defaults to "")
  * Identifier that plugin can identify in database (if not specified, this plugin will not log server's current player, which leads this plugin to be just a client)
* sm_gk_plyr_margin (defaults to 4)
  * Margin that which condition that plugin will consider as a full server. For instance, if server's max player is 4, then allowed 'full server condition' is 28 ≤ player ≤ 32.
