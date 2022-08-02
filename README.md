# SOURCEMOD-GATEKEEPER

This is a plugin for blocking people from joining server when primary server is not full.

## Console Variables

* sm_gk_enabled (defaults to 0)
  * Whether this plugin should block players joining when conditions is not satisfied
* sm_gk_svr_id (defaults to "")
  * Identifier that plugin can identify in database (if not specified, this plugin will not log server's current player, which leads this plugin to be just a client)
* sm_gk_plyr_margin (defaults to 4)
  * Margin that which condition that plugin will consider as a full server. For instance, if server's max player is 4, then allowed 'full server condition' is 28 ≤ player ≤ 32.

## Notes

* 맵첸으로 인한 재 접속은 OnClientPreConnectEx의 영향을 받지 않음 (false를 리턴하여도 접속할 수 있었음)
* 현재 Primary 서버의 사람이 빠졌을 경우 기존 인원들의 존재 때문에 접속은 허용하지만 Primary 서버의 인원을 채우기 위하여 Secondary 서버는 해당 맵을 마지막으로 하여 맵 변경 대신 HUD와 소리로 서버가 꺼진다고 알린 후 서버를 재시작 하도록 한다.
* 퇴장 시기: 맵이 다 끝나고
* 퇴장 조건: Primary 서버들이 현재 서버 인원을 수용할 수 있을 때 ( SUM(MAX_PLAYER - CUR_PLAYER) > SECONDARY_CURRENT_PLAYER)
* 결정해야 할 것: 퇴장 HUD가 돌 때마다 DB에 쿼리를 날려 인원수를 계속 체크해야 할 지, 퇴장할 때 맞춰 쿼리를 한번 날리고 말 것인지
* HUD는 auto_steam_update 플러그인에서 돚거해올 것