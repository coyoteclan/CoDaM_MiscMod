init()
{
	level.groups = []; // "group1;group2;group3"
	if(getCvar("scr_mm_groups") != "")
		level.groups = codam\_mm_mmm::strTok(getCvar("scr_mm_groups"), ";");

	if(!isDefined(level.groups) || level.groups.size < 1)
		return;

	level.users = []; // "user1:password user2:password"
	level.perms = []; // "*:<id>:<id1>-<id2>:!<id>"
	for(i = 0; i < level.groups.size; i++) {
		if(getCvar("scr_mm_users_" + level.groups[i]) != "")
			level.users[level.groups[i]] = codam\_mm_mmm::strTok(getCvar("scr_mm_users_" + level.groups[i]), " ");

		if(getCvar("scr_mm_perms_" + level.groups[i]) != "")
			level.perms[level.groups[i]] = codam\_mm_mmm::strTok(getCvar("scr_mm_perms_" + level.groups[i]), ":");
	}

	if(level.users.size < 1 || level.perms.size < 1) // TODO: add check for errors
		return;

	level.help = [];
	level.banactive = false; // flag for file in use, yeah I know, I'll write it better later
	level.reportactive = false; // flag for file in use, yeah I know, I'll write it better later

	level.workingdir = getCvar("fs_basepath") + "/main/";
	if(getCvar("scr_mm_cmd_path") != "")
		level.workingdir = getCvar("scr_mm_cmd_path") + "/";

	level.banfile = "miscmod_bans.dat";
	level.reportfile = "miscmod_reports.dat";

	if(!isDefined(level.perms["default"]))
		level.perms["default"] = codam\_mm_mmm::strTok("0-4:25:26", ":"); // pff xD

	level.prefix = "!";
	if(getCvar("scr_mm_cmd_prefix") != "")
		level.prefix = getCvar("scr_mm_cmd_prefix");

	level.nameprefix = "[MiscMod]";
	if(getCvar("scr_mm_cmd_nameprefix") != "")
		level.nameprefix = getCvar("scr_mm_cmd_nameprefix");

	level.command = ::command;
	level.commands = [];

	// MiscMod commands
	commands(level.prefix + "login"	, 	::cmd_login		, "Login to access commands. [" + level.prefix + "login <user> <pass>]");
	commands(level.prefix + "help"	, 	::cmd_help		, "Display this help. [" + level.prefix + "help]");
	commands(level.prefix + "version",	::cmd_version		, "Display MiscMod version. [" + level.prefix + "version]");
	commands(level.prefix + "name"	, 	::cmd_name		, "Change name. [" + level.prefix + "name <new name>]");
	commands(level.prefix + "fov"	, 	::cmd_fov		, "Set field of view. [" + level.prefix + "fov <value>]");//commands(level.prefix + "test"	, 	::cmd_test		, "Test function. [" + level.prefix + "test]");
	commands(level.prefix + "rename", 	::cmd_rename		, "Change name of a player. [" + level.prefix + "rename <num> <new name>]");
	commands(level.prefix + "logout", 	::cmd_logout		, "Logout. [" + level.prefix + "logout]");
	commands(level.prefix + "say",		::cmd_say		, "Say a message with group as prefix. [" + level.prefix + "say <message>]");
	commands(level.prefix + "saym",		::cmd_saym		, "Print a message in the middle of the screen. [" + level.prefix + "saym <message>]");
	commands(level.prefix + "sayo",		::cmd_sayo		, "Print a message in the obituary. [" + level.prefix + "saym <message>]");
	commands(level.prefix + "kick",		::cmd_kick		, "Kick a player. [" + level.prefix + "kick <num> <reason>]");
	commands(level.prefix + "reload",	::cmd_reload		, "Reload MiscMod commands. [" + level.prefix + "reload]");
	commands(level.prefix + "restart",	::cmd_restart		, "Restart map (soft). [" + level.prefix + "restart (*)]");
	commands(level.prefix + "endmap",	::cmd_endmap		, "End the map. [" + level.prefix + "endmap]");
	commands(level.prefix + "map",		::cmd_map		, "Change map and gametype. [" + level.prefix + "map <map> (gametype)]");
	commands(level.prefix + "status",	::cmd_status		, "List players. [" + level.prefix + "status]");
	commands(level.prefix + "mute",		::cmd_mute		, "Mute player. [" + level.prefix + "mute <num|list>]");
	commands(level.prefix + "unmute",	::cmd_unmute		, "Unmute player. [" + level.prefix + "unmute <num>]");
	commands(level.prefix + "warn",		::cmd_warn		, "Warn player. [" + level.prefix + "warn <num> <message>]");
	commands(level.prefix + "kill",		::cmd_kill		, "Kill a player. [" + level.prefix + "kill <num>]");
	commands(level.prefix + "weapon",	::cmd_weapon		, "Give weapon to player. [" + level.prefix + "weapon <num> <weapon>]");
	commands(level.prefix + "heal",		::cmd_heal		, "Heal player. [" + level.prefix + "heal <num>]");
	commands(level.prefix + "invisible",	::cmd_invisible		, "Become invisible. [" + level.prefix + "invisible <on|off>]");
	commands(level.prefix + "ban",		::cmd_ban		, "Ban player. [" + level.prefix + "ban <num> <reason>]");
	commands(level.prefix + "unban",	::cmd_unban		, "Unban player. [" + level.prefix + "unban <ip>]");
	commands(level.prefix + "pm",		::cmd_pm		, "Private message a player. [" + level.prefix + "pm <player> <message>]");
	commands(level.prefix + "re",		::cmd_re		, "Respond to private message. [" + level.prefix + "re <message>]");
	commands(level.prefix + "who",		::cmd_who		, "Display logged in users. [" + level.prefix + "who]");
	// Cheese commands
	commands(level.prefix + "drop",		::cmd_drop		, "Drop a player. [" + level.prefix + "drop <num> <height>]");
	commands(level.prefix + "spank",	::cmd_spank		, "Spank a player. [" + level.prefix + "spank <num> <time>]");
	commands(level.prefix + "slap",		::cmd_slap		, "Slap a player. [" + level.prefix + "slap <num> <damage>]");
	commands(level.prefix + "blind",	::cmd_blind		, "Blind a player. [" + level.prefix + "blind <num> <time>]");
	commands(level.prefix + "runover",	::cmd_runover		, "Run over a player. [" + level.prefix + "runover <num>]");
	commands(level.prefix + "squash",	::cmd_squash		, "Squash a player. [" + level.prefix + "squash <num>]");
	commands(level.prefix + "rape",		::cmd_rape		, "Rape a player. [" + level.prefix + "rape <num>]");
	commands(level.prefix + "toilet",	::cmd_toilet		, "Turn player into a toilet. [" + level.prefix + "toilet <num>]");
	// PowerServer
	commands(level.prefix + "explode",	::cmd_explode		, "Explode a player. [" + level.prefix + "explode <num>]");
	commands(level.prefix + "force",	::cmd_force		, "Force players to team. [" + level.prefix + "<axis|allies|spectator> <num|all> (...)]");
	commands(level.prefix + "mortar",	::cmd_mortar		, "Mortar a player. [" + level.prefix + "mortar <num>]");
	commands(level.prefix + "matrix",	::cmd_matrix		, "Matrix. [" + level.prefix + "matrix]");
	commands(level.prefix + "burn",		::cmd_burn		, "Burn a player. [" + level.prefix + "burn <num>]");
	commands(level.prefix + "cow",		::cmd_cow		, "BBQ a player. [" + level.prefix + "cow <num>]");
	commands(level.prefix + "disarm",	::cmd_disarm		, "Disarm a player. [" + level.prefix + "disarm <num>]");
	// War commands
	commands(level.prefix + "os",		::cmd_wos		, "Snipers only. [" + level.prefix + "os]");
	commands(level.prefix + "aw",		::cmd_waw		, "All weapons (1 sniper). [" + level.prefix + "aw (*)]");
	commands(level.prefix + "omp",		::cmd_womp		, "Only machine guns. [" + level.prefix + "omp]");
	commands(level.prefix + "rifles",	::cmd_wrifles		, "Rifle settings. [" + level.prefix + "rifles <on|off|only>]");
	commands(level.prefix + "health",	::cmd_whealth		, "Health settings. [" + level.prefix + "health <off|0|1|2|3>]");
	commands(level.prefix + "grenade",	::cmd_wgrenade		, "Grenade settings. [" + level.prefix + "grenades <off|0|1|2|3|reset>]");
	commands(level.prefix + "pistols",	::cmd_wpistols		, "Pistol settings. [" + level.prefix + "pistols <on|empty|disable|bullets> (<chamber|clip>)]");
	commands(level.prefix + "1sk",		::cmd_w1sk		, "Instant kill. [" + level.prefix + "1sk <on|off>]");
	commands(level.prefix + "roundlength",	::cmd_wroundlength	, "Set roundlegth. [" + level.prefix + "roundlength <time>]");
	commands(level.prefix + "psk",		::cmd_wpsk		, "Instant kill on pistols. [" + level.prefix + "psk <on|off>]");
	// Extra commands
	commands(level.prefix + "belmenu",	::cmd_belmenu		, "Enable BEL menu instead of normal menu. [" + level.prefix + "belmenu <on|off>]");
	commands(level.prefix + "report",	::cmd_report		, "Report a player. [" + level.prefix + "report <num> <reason>]");
	commands(level.prefix + "plist",		::cmd_status		, "List players and their <num> values. [" + level.prefix + "list]");
	// momo74 commands
	commands(level.prefix + "rs",		::cmd_rs		, "Reset your scores in the scoreboard. [" + level.prefix + "rs ]");
	commands(level.prefix + "optimize",	::cmd_optimize		, "Set optimal connection settings for a player. [" + level.prefix + "optimize <num>]");
	// Client CVAR commands
	commands(level.prefix + "pcvar",		::cmd_pcvar		, "Set a player CVAR (e.g fps, rate, etc). [" + level.prefix + "pcvar <num> <cvar> <value>]");
	commands(level.prefix + "respawn",		::cmd_respawn		, "Reload a player spawnpoint. [" + level.prefix + "respawn <num> <sd|dm|tdm>]");
	// More commands
	commands(level.prefix + "wmap",		::cmd_wmap	, "Change CoDaM weapon_map settings. [" + level.prefix + "wmap <weapon=map|codam|reset>]");
	commands(level.prefix + "meleekill",		::cmd_wmeleekill	, "Instant kill on melee. [" + level.prefix + "meleekill <on|off>]");
	commands(level.prefix + "teleport",		::cmd_teleport	, "Teleport a player to a player or (x, y, z) coordinates. [" + level.prefix + "teleport <num> (<num>|<x> <y> <z>)]");
	commands(level.prefix + "teambalance",		::cmd_teambalance	, "Enable/disable teambalance or rebalance teams. [" + level.prefix + "teambalance <on|off|force>]");
	commands(level.prefix + "swapteams",		::cmd_swapteams	, "Swap teams. [" + level.prefix + "swapteams]");
	commands(level.prefix + "freeze",		::cmd_freeze	, "Freeze player(s). [" + level.prefix + "freeze <on|off> <num|all>]");

	level.tmp_mm_weapon_map = getCvar("tmp_mm_weapon_map");
	if(level.tmp_mm_weapon_map == "") { // cmd_wmap
		scr_weapon_map = getCvar("scr_weapon_map");
		if(scr_weapon_map == "")
			scr_weapon_map = "empty";

		setCvar("tmp_mm_weapon_map", scr_weapon_map);
	}

	thread _loadBans(); // reload bans from dat file every round
	thread _loadFOV();
	thread _loadBadWords();
}

precache()
{
	precacheShellshock("default");
	precacheShellshock("groggy");
	precacheModel("xmodel/vehicle_tank_tiger");
	precacheModel("xmodel/vehicle_russian_barge");
	precacheModel("xmodel/playerbody_russian_conscript");
	precacheModel("xmodel/toilet");
	precacheModel("xmodel/cow_dead");
	precacheModel("xmodel/cow_standing");

	level._effect["fireheavysmoke"]	= loadfx("fx/fire/fireheavysmoke.efx");
	level._effect["flameout"] = loadfx("fx/tagged/flameout.efx");
	level._effect["bombexplosion"] = loadfx("fx/explosions/pathfinder_explosion.efx");
	level._effect["mortar_explosion"][0] = loadfx("fx/impacts/newimps/minefield.efx");
	level._effect["mortar_explosion"][3] = loadfx("fx/impacts/newimps/minefield.efx");
	level._effect["mortar_explosion"][2] = loadfx("fx/impacts/dirthit_mortar.efx");
	level._effect["mortar_explosion"][1] = loadfx("fx/impacts/newimps/blast_gen3.efx");
	level._effect["mortar_explosion"][4] = loadfx("fx/impacts/newimps/dirthit_mortar2daymarked.efx");
}

commands(cmd, func, desc)
{
	id = level.commands.size;
	level.commands[cmd]["func"]	= func;
	level.commands[cmd]["desc"]	= desc;
	level.commands[cmd]["id"]	= id; // :)

	level.help[level.commands[cmd]["id"]]["cmd"] = cmd; // not the solution I wanted tho
}

command(str)
{
	if(!isDefined(str)) // string index 0 out of range
		return;

	str = codam\_mm_mmm::strip(str);
	if(str.size < 1) { // string index 0 out of range
		creturn(); // return in codextended.so
		return;
	}

	if(level.maxmessages > 0 && !isDefined(self.pers["mm_group"])) {
		penaltytime = level.penaltytime;
		if(self.pers["mm_chatmessages"] > level.maxmessages)
			penaltytime += self.pers["mm_chatmessages"] - level.maxmessages;
		penaltytime *= 1000;

		if(getTime() - self.pers["mm_chattimer"] >= penaltytime) {
			self.pers["mm_chattimer"] = getTime();
			self.pers["mm_chatmessages"] = 1;
		}	else {
			self.pers["mm_chatmessages"]++;
			if(self.pers["mm_chatmessages"] > level.maxmessages)
				message_player("You are currently muted for " + (float)(penaltytime / 1000) + " second(s).");
		}
	}

	if(isDefined(self.pers["mm_mute"]) || (level.maxmessages > 0 && self.pers["mm_chatmessages"] > level.maxmessages)) {
		creturn(); // return in codextended.so
		return;
	}

	if(str.size == 1) return; // just 1 letter, ignore

	if(str[0] != level.prefix) { // string index 0 out of range (fixed above)
		if(isDefined(level.badwords)) {
			//print message to console with cleaned string say or sayt
			//requires modification to codextended, or sendservercommand with say/sayt
			//str = badwords_clean(str, badwords);

			if(badwords_mute(str)) {
				badmessage = "^5INFO: ^7You were silenced due to inappropriate language.";
				if(isDefined(self.badword))
					badmessage += " The offensive word in question was: " + self.badword + ".";
				message_player(badmessage);

				creturn();
			}
		}

		return;
	}

	creturn(); // return in codextended.so

	cmd = codam\_mm_mmm::strTok(str, " "); // is a command with level.prefix

	if(isDefined(level.commands[cmd[0]])) {
		if(isDefined(self.pers["mm_group"])) { // permissions granted with !login
			if(permissions(level.perms[self.pers["mm_group"]], level.commands[cmd[0]]["id"]) || level.commands[cmd[0]]["id"] == 0) {
				codam\_mm_mmm::mmlog("command;" + self.pers["mm_user"] + ";" + self.pers["mm_group"] + ";" + cmd[0]);
				thread [[ level.commands[cmd[0]]["func"] ]](cmd);
			} else
				message_player("^1ERROR: ^7Access denied.");
		} else {
			if(permissions(level.perms["default"], level.commands[cmd[0]]["id"], true) || level.commands[cmd[0]]["id"] == 0)
				thread [[ level.commands[cmd[0]]["func"] ]](cmd);
		}
	} else {
		if(getCvarInt("scr_mm_rcm_compatibility") > 0) { // RCM compatibility
			logmessage = "";
			for(i = 0; i < cmd.size; i++) {
				logmessage += cmd[i];
				if(i != cmd.size - 1)
					logmessage += " ";
			}

			codam\_mm_mmm::mmlog("say;" + self.name + ";" + logmessage);
		}
	}
}

badwords_mute(str) // str - mute
{
	if(!isDefined(str) || !isDefined(level.badwords))
		return false;

	str = codam\_mm_mmm::strTok(str, " ");
	for(i = 0; i < str.size; i++) {
		for(b = 0; b < level.badwords.size; b++) {
			// it's expected all badwords are lower case for better performance
			str[i] = codam\_mm_mmm::monotone(str[i]); // TODO: add removal of anything not letters
			if(codam\_mm_mmm::pmatch(tolower(str[i]), level.badwords[b])) {
				self.badword = level.badwords[b];
				return true;
			}
		}
	}

	return false;
}

/*badwords_clean(str, badwords) // str, arr - asterix
{ // Defected can fix this for codextended
	if(!isDefined(str) || !isDefined(badwords))
		return str;

	cleanstr = "";

	str = codam\_mm_mmm::strTok(str, " ");
	for(i = 0; i < str.size; i++) {
		for(b = 0; b < badwords.size; b++) {
			// it's expected all badwords are lower case for better performance
			str[i] = codam\_mm_mmm::monotone(str[i]);
			if(codam\_mm_mmm::pmatch(tolower(str[i]), badwords[b])) {
				_tmp = "";
				for(a = 0; a < str[i].size; a++)
					_tmp += "*";

				str[i] = _tmp;
				break;
			}
		}

		cleanstr += str[i];
	}

	return cleanstr;
}*/

permissions(perms, id, def) // "*:<id>:<id1>-<id2>:!<id>" :P
{
	if(!isDefined(def))
		perms = codam\_mm_mmm::array_join(perms, level.perms["default"]); // always allow default permissions if they're not overridden

	wildcard = false;
	for(i = 0; i < perms.size; i++) {
		if(perms[i] == "*")
			wildcard = true;
		else if(perms[i] == id)
			return true;
		else if(perms[i] == ("!" + id))
			return false;
		else {
			range = codam\_mm_mmm::strTok(perms[i], "-");
			if(range.size == 2) {
				rangeperm = false;
				if(range[0][0] == "!") { // idk about this XD XD
					_tmp = "";
					for(s = 1; s < range[0].size; s++)
						_tmp += range[0][s];

					range[0] = _tmp;
					rangeperm = true;
				}

				hi = (int)range[1];
				lo = (int)range[0];

				if(lo >= hi || hi < lo)
					continue;

				if(id >= lo && id <= hi)
					return !rangeperm;
			}
		}
	}

	return wildcard;
}

cmd_login(args)
{
	if(args.size != 3) {
		message_player("^1ERROR: ^7Invalid number of arguments.");
		return;
	}

	if(isDefined(self.pers["mm_group"])) {
		message_player("^5INFO: ^7You are already logged in.");
		return;
	}

	loginis = "unsuccessful";

	username = args[1];
	password = args[2];

	if(isDefined(username) && isDefined(password)) {
		loggedin = getCvar("tmp_mm_loggedin");
		if(loggedin != "") {
			loggedin = codam\_mm_mmm::strTok(loggedin, ";");
			for(i = 0; i < loggedin.size; i++) {
				user = codam\_mm_mmm::strTok(loggedin[i], "|");
				if(user[0] == username) {
					player = codam\_mm_mmm::playerByNum(user[2]);
					loginis = "loggedin";
					codam\_mm_mmm::mmlog("login;" + self.name + ";" + loginis + ";" + self getip() + ";" + username + ";" + password);
					message_player("^5INFO: ^7" + codam\_mm_mmm::namefix(self.name) + " ^7tried to login with your username.", player);
					message_player("^1ERROR: ^7You shall not pass!");
					return;
				}
			}
		}

		for(i = 0; i < level.groups.size; i++) {
			group = level.groups[i];
			if(isDefined(group) && isDefined(level.users[group])) {
				users = level.users[group];
				for(u = 0; u < users.size; u++) {
					user = codam\_mm_mmm::strTok(users[u], ":");
					if(user.size == 2) {
						if(username == user[0] && password == user[1]) {
							message_player("You are logged in.");
							message_player("Group: " + group);

							loginis = "successful";
							codam\_mm_mmm::mmlog("login;" + self.name + ";" + loginis + ";" + self getip() + ";" + username + ";" + password);

							self.pers["mm_group"]	= group;
							self.pers["mm_user"]	= username;

							rSTR = "";
							if(getCvar("tmp_mm_loggedin") != "")
								rSTR += getCvar("tmp_mm_loggedin");

							rSTR += self.pers["mm_user"];
							rSTR += "|" + self.pers["mm_group"];
							rSTR += "|" + self getEntityNumber();
							rSTR += ";";

							setCvar("tmp_mm_loggedin", rSTR);
							return;
						}
					}
				}
			}
		}
	}

	if(!isDefined(username)) // quickfix -- fixed in strTok, but I guess can never be tooo careful
		username = "_UNDEFINED_";
	if(!isDefined(password))
		password = "_UNDEFINED_";

	codam\_mm_mmm::mmlog("login;" + self.name + ";" + loginis + ";" + self getip() + ";" + username + ";" + password);
	message_player("^1ERROR: ^7You shall not pass!");
}

cmd_test(args)
{
	message_player("^1ERROR: ^7Not in use.");
}

cmd_invisible(args)
{
	if(args.size != 2) {
		message_player("^1ERROR: ^7Invalid number of arguments.");
		return;
	}

	args1 = args[1];
	if(!isDefined(args1)) {
		message_player("^1ERROR: ^7Invalid argument.");
		return;
	}

	switch(args1) {
		case "on":
			message_player("^5INFO: ^7You are invisible.");
			self ShowToPlayer(self);
		break;
		case "off":
			message_player("^5INFO: ^7You are visible.");
			self ShowToPlayer(undefined);
		break;
		default:
			message_player("^1ERROR: ^7Invalid argument.");
		break;
	}
}

cmd_fov(args)
{
	if(args.size != 2) {
		message_player("^1ERROR: ^7Invalid number of arguments.");
		return;
	}

	args1 = args[1]; // num
	if(!codam\_mm_mmm::validate_number(args1)) {
		message_player("^1ERROR: ^7Invalid argument.");
		return;
	}

	if(isDefined(self.pers["mm_fov"]) && args1 == self.pers["mm_fov"]) {
		message_player("^5INFO: ^7Your FOV is already set to " + self.pers["mm_fov"] + ".");
		return;
	}

	if((int)args1 > 95 || (int)args1 < 80) {
		message_player("^5INFO: ^7FOV must be between 80 and 95.");
		return;
	}

	self.pers["mm_fov"] = args1;
	self setClientCvar("cg_fov", self.pers["mm_fov"]);

	message_player("^5INFO: ^7Your FOV changed to: " + self.pers["mm_fov"]);

	clientnum = self getEntityNumber();
	_removeFOV(clientnum);

	rSTR = "";
	if(getCvar("tmp_mm_fov") != "")
		rSTR += getCvar("tmp_mm_fov");

	rSTR += args1;
	rSTR += "|" + clientnum;
	rSTR += ";";

	setCvar("tmp_mm_fov", rSTR);
}

cmd_version(args)
{
	if(args.size != 1) {
		message_player("^1ERROR: ^7Invalid number of arguments.");
		return;
	}

	message_player("This server is running " + level.miscmodversion + "^7.");
}

cmd_name(args)
{
	if(args.size < 2) {
		message_player("^1ERROR: ^7Invalid number of arguments.");
		return;
	}

	args1 = args[1]; // name
	if(!isDefined(args1)) {
		message_player("^1ERROR: ^7Invalid argument.");
		return;
	}

	if(args.size > 2) {
		for(a = 2; a < args.size; a++)
			if(isDefined(args[a]))
				args1 += " " + args[a];
	}

	self setClientCvar("name", args1);
	message_player("Your name was changed to: " + args1 + "^7.");
}

cmd_help(args)
{
	if(args.size != 1) {
		message_player("^1ERROR: ^7Invalid number of arguments.");
		return;
	}

	message_player("Here is a list of available commands.");

	for(i = 0; i < level.help.size; i++) {
		if(i == 0 && isDefined(self.pers["mm_group"]))
			continue;

		if(!isDefined(level.help[i]))
			continue;

		cmd = level.help[i]["cmd"];
		spaces = "";
		if(cmd.size < 20)
			for(s = cmd.size; s < 20; s++)
				spaces += " ";

		if(isDefined(self.pers["mm_group"])) {
			if(permissions(level.perms[self.pers["mm_group"]], level.commands[cmd]["id"]))
				message_player(cmd + spaces + level.commands[cmd]["desc"]);
		} else {
			if(permissions(level.perms["default"], level.commands[cmd]["id"], true))
				message_player(cmd + spaces + level.commands[cmd]["desc"]);
		}

		if(!(i % 15))
			wait 0.10;
	}
}

cmd_logout(args)
{
	if(args.size != 1) {
		message_player("^1ERROR: ^7Invalid number of arguments.");
		return;
	}

	if(isDefined(self.pers["mm_group"])) {
		self.pers["mm_group"]	= undefined;
		self.pers["mm_user"]	= undefined;
		message_player("You are logged out.");
		_removeLoggedIn(self getEntityNumber()); // cvar
	}
}

cmd_say(args)
{
	if(args.size < 2) {
		message_player("^1ERROR: ^7Invalid number of arguments.");
		return;
	}

	args1 = args[1];
	if(!isDefined(args1)) {
		message_player("^1ERROR: ^7Invalid argument.");
		return;
	}

	if(args.size > 2) {
		for(a = 2; a < args.size; a++)
			if(isDefined(args[a]))
				args1 += " " + args[a];
	}

	if(isDefined(self.pers["mm_group"]))
		sendservercommand("i \"^7^3[^7" + self.pers["mm_group"] + "^3] ^7" + codam\_mm_mmm::namefix(self.name) + "^7: " + args1 + "\"");
}

cmd_saym(args)
{
	if(args.size < 2) {
		message_player("^1ERROR: ^7Invalid number of arguments.");
		return;
	}

	args1 = args[1];
	if(!isDefined(args1)) {
		message_player("^1ERROR: ^7Invalid argument.");
		return;
	}

	if(args.size > 2) {
		for(a = 2; a < args.size; a++)
			if(isDefined(args[a]))
				args1 += " " + args[a];
	}

	iPrintLnBold(args1);
}

cmd_sayo(args)
{
	if(args.size < 2) {
		message_player("^1ERROR: ^7Invalid number of arguments.");
		return;
	}

	args1 = args[1];
	if(!isDefined(args1)) {
		message_player("^1ERROR: ^7Invalid argument.");
		return;
	}

	if(args.size > 2) {
		for(a = 2; a < args.size; a++)
			if(isDefined(args[a]))
				args1 += " " + args[a];
	}

	iPrintLn(args1);
}

cmd_rename(args)
{
	if(args.size < 2) {
		message_player("^1ERROR: ^7Invalid number of arguments.");
		return;
	}

	args1 = args[1]; // num | string
	args2 = args[2]; // name
	if(!isDefined(args1) || !isDefined(args2)) {
		message_player("^1ERROR: ^7Invalid argument.");
		return;
	}

	if(codam\_mm_mmm::validate_number(args1)) {
		if(args1 == self getEntityNumber()) {
			message_player("^1ERROR: ^7You can't use this command on yourself.");
			return;
		}

		player = codam\_mm_mmm::playerByNum(args1);
		if(!isDefined(player)) {
			message_player("^1ERROR: ^7No such player.");
			return;
		}
	} else {
		player = playerByName(args1);
		if(!isDefined(player)) return;

		if(player == self) {
			message_player("^1ERROR: ^7You can't use this command on yourself.");
			return;
		}
	}

	if(args.size > 3) {
		for(a = 3; a < args.size; a++)
			if(isDefined(args[a]))
				args2 += " " + args[a];
	}

	message_player("^5INFO: ^7You renamed " + codam\_mm_mmm::namefix(player.name) + " ^7to " + args2 + "^7.");
	player setClientCvar("name", args2);
}

cmd_endmap(args)
{
	if(args.size != 1) {
		message_player("^1ERROR: ^7Invalid number of arguments.");
		return;
	}

	message("^5INFO: ^7Forcing the map to end.");
	wait 1;
	level notify("end_map");
}

cmd_who(args)
{
	if(args.size != 1) {
		message_player("^1ERROR: ^7Invalid number of arguments.");
		return;
	}

	pdata = spawnStruct();
	pdata.num = 0;
	pdata.highscore = 0;
	pdata.ping = 0;
	pdata.user = 0;

	players = codam\_mm_mmm::getOnlinePlayers();
	playersloggedin = [];
	for(i = 0; i < players.size; i++) {
		player = players[i];

		if(!isDefined(player.pers["mm_group"]))
			continue;

		playersloggedin[playersloggedin.size] = player;

		pnum = player getEntityNumber();

		if(player.score > pdata.highscore)
			pdata.highscore = player.score;

		if(pnum > pdata.num)
			pdata.num = pnum;

	 	ping = player getping();
		if(ping > pdata.ping)
			pdata.ping = ping;

		puser = player.pers["mm_user"] + " (" + player.pers["mm_group"] + "^7)";
		if(puser.size > pdata.user)
			pdata.user = puser.size;
	}

	pdata.num = pdata.num + "";
	pdata.num = pdata.num.size;

	pdata.highscore = pdata.highscore + "";
	pdata.highscore = pdata.highscore.size;

	pdata.ping = pdata.ping + "";
	pdata.ping = pdata.ping.size;

	message_player("-----------------------------------------------------");
	for(i = 0; i < playersloggedin.size; i++) {
		player = playersloggedin[i];
		pnum = player getEntityNumber();
		pnumstr = pnum + "";
		pscorestr = player.score + "";
		pping = player getping();
		ppingstr = pping + "";
		puser = player.pers["mm_user"] + " (" + player.pers["mm_group"] + "^7)";
		message = "^1[^7NUM: " + pnum + spaces(pdata.num - pnumstr.size) + " ^1|^7 Score: " + player.score + spaces(pdata.highscore - pscorestr.size) + " ^1|^7 ";
		message += "Ping: " + pping + spaces(pdata.ping - ppingstr.size) + " ^1|^7 ";
		message += "User: " + puser + spaces(pdata.user - puser.size);
		message += "^1]^3 -->^7 " + codam\_mm_mmm::namefix(player.name);

		message_player(message);
	}
}

cmd_kick(args)
{
	if(args.size < 2) {
		message_player("^1ERROR: ^7Invalid number of arguments.");
		return;
	}

	args1 = args[1]; // num | string
	if(!isDefined(args1)) {
		message_player("^1ERROR: ^7Invalid argument.");
		return;
	}

	if(codam\_mm_mmm::validate_number(args1)) {
		if(args1 == self getEntityNumber()) {
			message_player("^1ERROR: ^7You can't use this command on yourself.");
			return;
		}

		player = codam\_mm_mmm::playerByNum(args1);
		if(!isDefined(player)) {
			message_player("^1ERROR: ^7No such player.");
			return;
		}
	} else {
		player = playerByName(args1);
		if(!isDefined(player)) return;

		if(player == self) {
			message_player("^1ERROR: ^7You can't use this command on yourself.");
			return;
		}
	}

	args2 = args[2];
	if(isDefined(args2)) {
		if(args.size > 2) {
			for(a = 3; a < args.size; a++)
				if(isDefined(args[a]))
					args2 += " " + args[a];
		}

		message("Player " + codam\_mm_mmm::namefix(player.name) + " ^7was kicked by " + codam\_mm_mmm::namefix(self.name) + " ^7with reason: " + args2  + ".");
		kickmsg = "Player Kicked: ^1" + args2; // can't be specified in dropclient cases crash ?!
		player dropclient(kickmsg);
	} else {
		message("Player " + codam\_mm_mmm::namefix(player.name) + " ^7was kicked by " + codam\_mm_mmm::namefix(self.name) + "^7.");
		player dropclient("Player Kicked.");
	}
}

cmd_reload(args)
{
	if(args.size != 1) {
		message_player("^1ERROR: ^7Invalid number of arguments.");
		return;
	}

	init();

	message_player("^5INFO: ^7Config reloaded.");
}

cmd_restart(args)
{
	if(args.size > 2) {
		message_player("^1ERROR: ^7Invalid number of arguments.");
		return;
	}

	restart = false;
	if(args.size == 2)
		restart = true;

	map_restart(restart);
}

cmd_map(args)
{
	if(args.size > 3) {
		message_player("^1ERROR: ^7Invalid number of arguments.");
		return;
	}

	map = args[1];
	if(!isDefined(map)) {
		message_player("^1ERROR: ^7Invalid argument.");
		return;
	}

	gametype = level.mmgametype;
	if(isDefined(args[2]))
		gametype = args[2];

	mapvar = getCvar("scr_mm_cmd_maps");
	for(i = 1;; i++) {
		tmpvar = getCvar("scr_mm_cmd_maps" + i);
		if(tmpvar != "") {
			if(mapvar != "")
				mapvar += " ";
			mapvar += tmpvar;
		} else
			break;
	}

	if(mapvar != "")
		maps = codam\_mm_mmm::strTok(mapvar, " ");
	else
		maps = codam\_mm_mmm::strTok("mp_harbor mp_brecourt mp_carentan mp_railyard mp_dawnville mp_depot mp_rocket mp_pavlov mp_powcamp mp_hurtgen mp_ship mp_chateau", " ");

	if(!codam\_mm_mmm::in_array(maps, map)) {
		for(i = 0; i < maps.size; i++) {
			if(codam\_mm_mmm::pmatch(tolower(maps[i]), tolower(map))) {
				map = maps[i];
				break;
			}
		}
	}

	if(codam\_mm_mmm::in_array(maps, map)) {
		setCvar("sv_mapRotationCurrent", "gametype " + gametype + " map " + map);
		message("^5INFO: ^7Map changed to " + map + " (" + gametype + ") by " + codam\_mm_mmm::namefix(self.name) + "^7.");

		wait 1;

		exitLevel(false);
	} else
		message_player("^1ERROR: ^7Not a valid map.");
}

cmd_status(args)
{
	if(args.size != 1) {
		message_player("^1ERROR: ^7Invalid number of arguments.");
		return;
	}

	pdata = spawnStruct();
	pdata.num = 0;
	pdata.highscore = 0;
	pdata.ip = 0;
	pdata.ping = 0;

	players = codam\_mm_mmm::getOnlinePlayers();
	for(i = 0; i < players.size; i++) {
		player = players[i];
		pnum = player getEntityNumber();

		if(player.score > pdata.highscore)
			pdata.highscore = player.score;

		if(pnum > pdata.num)
			pdata.num = pnum;

		ip = player getip();
		if(ip.size > pdata.ip)
			pdata.ip = ip.size;

	 	ping = player getping();
		if(ping > pdata.ping)
			pdata.ping = ping;
	}

	pdata.num = pdata.num + "";
	pdata.num = pdata.num.size;

	pdata.highscore = pdata.highscore + "";
	pdata.highscore = pdata.highscore.size;

	pdata.ping = pdata.ping + "";
	pdata.ping = pdata.ping.size;

	message_player("-----------------------------------------------------");
	for(i = 0; i < players.size; i++) {
		player = players[i];
		pnum = player getEntityNumber();
		pnumstr = pnum + "";
		pscorestr = player.score + "";
		pping = player getping();
		ppingstr = pping + "";
		message = "^1[^7NUM: " + pnum + spaces(pdata.num - pnumstr.size) + " ^1|^7 Score: " + player.score + spaces(pdata.highscore - pscorestr.size) + " ^1|^7 ";
		message += "Ping: " + pping + spaces(pdata.ping - ppingstr.size);

		if(args[0] == "!status" && getCvarInt("scr_mm_showip_status") > 0) {
			pip = player getip();
			message += " ^1|^7 IP: " + pip + spaces(pdata.ip - pip.size);
		}

		message += "^1]^3 -->^7 " + codam\_mm_mmm::namefix(player.name);

		message_player(message);
	}
}

spaces(amount)
{
	spaces = "";
	for(i = 0; i < amount; i++)
		spaces += " ";

	return spaces;
}

cmd_pm(args)
{
	if(args.size < 3) {
		message_player("^1ERROR: ^7Invalid number of arguments.");
		return;
	}

	args1 = args[1]; // num | string
	args2 = args[2]; // message
	if(!isDefined(args1) || !isDefined(args2)) {
		message_player("^1ERROR: ^7Invalid argument.");
		return;
	}

	if(codam\_mm_mmm::validate_number(args1)) {
		if(args1 == self getEntityNumber()) {
			message_player("^1ERROR: ^7You can't use this command on yourself.");
			return;
		}

		player = codam\_mm_mmm::playerByNum(args1);
		if(!isDefined(player)) {
			message_player("^1ERROR: ^7No such player.");
			return;
		}
	} else {
		player = playerByName(args1);
		if(!isDefined(player)) return;

		if(player == self) {
			message_player("^1ERROR: ^7You can't use this command on yourself.");
			return;
		}
	}

	if(args.size > 2) {
		for(a = 3; a < args.size; a++)
			if(isDefined(args[a]))
				args2 += " " + args[a];
	}

	message_player("^2[^7PM^2]^7 " + codam\_mm_mmm::namefix(self.name) + "^7: " + args2, player);
	message_player("^1[^7PM^1]^7 " + codam\_mm_mmm::namefix(player.name) + "^7: " + args2);

	self.pers["pm"] = player getEntityNumber();
	player.pers["pm"] = self getEntityNumber();
}

cmd_re(args)
{
	if(!isDefined(self.pers["pm"])) {
		message_player("^1ERROR: ^7Player ID not found, use !pm <player> <message> first.");
		return;
	}

	player = codam\_mm_mmm::playerByNum(self.pers["pm"]);
	if(!isDefined(player)) {
		message_player("^1ERROR: ^7Player ID not found, use !pm <player> <message> first.");
		return;
	}

	if(args.size == 1)
		message_player("^5INFO: ^7Replies are sent to: " + codam\_mm_mmm::namefix(player.name) + "^7.");
	else {
		args1 = args[1];

		//pair has unmatching types 'string' and 'undefined': (file 'codam\_mm_commands.gsc', line 829)
		//  message_player("^2[^7PM^2]^7 " + codam\_mm_mmm::namefix(self.name) + "^7: " + args1, player);
		//                                                                              *
		if(!isDefined(args1)) // Reported by ImNoob
			return; // Attempted fix

		if(args.size > 2) {
			for(a = 2; a < args.size; a++)
				if(isDefined(args[a]))
					args1 += " " + args[a];
		}

		message_player("^2[^7PM^2]^7 " + codam\_mm_mmm::namefix(self.name) + "^7: " + args1, player);
		message_player("^1[^7PM^1]^7 " + codam\_mm_mmm::namefix(player.name) + "^7: " + args1);

		self.pers["pm"] = player getEntityNumber();
		player.pers["pm"] = self getEntityNumber();
	}
}

cmd_mute(args)
{
	if(args.size != 2) {
		message_player("^1ERROR: ^7Invalid number of arguments.");
		return;
	}

	args1 = args[1]; // num | string
	if(!isDefined(args1)) {
		message_player("^1ERROR: ^7Invalid argument.");
		return;
	}

	if(args1 == "list") { // new feature, but recode sometime, too lazy to make better
		muted = codam\_mm_mmm::strTok(getCvar("tmp_mm_muted"), ";");
		if(muted.size > 0) {
			message_player("^5INFO: ^7Muted players:"); // + codam\_mm_mmm::namefix(player.name));
			for(i = 0; i < muted.size; i++) {
				player = codam\_mm_mmm::playerByNum(muted[i]);
				if(isDefined(player)) {
					spaces = "";
					if((int)muted[i] < 10) // or: if(muted[i].size == 1)
						spaces = " ";

					message_player(spaces + muted[i] + ": " + codam\_mm_mmm::namefix(player.name));
				}
			}
		} else
			message_player("^5INFO: ^7No muted players.");
		return;
	}

	if(codam\_mm_mmm::validate_number(args1)) {
		if(args1 == self getEntityNumber()) {
			message_player("^1ERROR: ^7You can't use this command on yourself.");
			return;
		}

		player = codam\_mm_mmm::playerByNum(args1);
		if(!isDefined(player)) {
			message_player("^1ERROR: ^7No such player.");
			return;
		}
	} else {
		player = playerByName(args1);
		if(!isDefined(player)) return;

		if(player == self) {
			message_player("^1ERROR: ^7You can't use this command on yourself.");
			return;
		}
	}

	muted = codam\_mm_mmm::strTok(getCvar("tmp_mm_muted"), ";");
	playernum = player getEntityNumber();
	if(!codam\_mm_mmm::in_array(muted, playernum)) {
		player.pers["mm_mute"] = true;
		message(codam\_mm_mmm::namefix(player.name) + " ^7is muted by " + codam\_mm_mmm::namefix(self.name) + "^7.");

		rID = "";
		if(getCvar("tmp_mm_muted") != "")
			rID += getCvar("tmp_mm_muted");

		rID += playernum;
		rID += ";";

		setCvar("tmp_mm_muted", rID);
	} else
		message_player("^1ERROR: ^7Player is already muted.");
}

cmd_unmute(args)
{
	if(args.size != 2) {
		message_player("^1ERROR: ^7Invalid number of arguments.");
		return;
	}

	args1 = args[1]; // num | string
	if(!isDefined(args1)) {
		message_player("^1ERROR: ^7Invalid argument.");
		return;
	}

	if(codam\_mm_mmm::validate_number(args1)) {
		if(args1 == self getEntityNumber()) {
			message_player("^1ERROR: ^7You can't use this command on yourself.");
			return;
		}

		player = codam\_mm_mmm::playerByNum(args1);
		if(!isDefined(player)) {
			message_player("^1ERROR: ^7No such player.");
			return;
		}
	} else {
		player = playerByName(args1);
		if(!isDefined(player)) return;

		if(player == self) {
			message_player("^1ERROR: ^7You can't use this command on yourself.");
			return;
		}
	}

	if(isDefined(player.pers["mm_mute"])) {
		playernum = player getEntityNumber();
		player.pers["mm_mute"] = undefined;
		message(codam\_mm_mmm::namefix(player.name) + " ^7is unmuted by " + codam\_mm_mmm::namefix(self.name) + "^7.");
		_removeMuted(playernum);
	} else
		message_player("^1ERROR: ^7Player is not muted.");
}

cmd_warn(args)
{
	if(args.size < 3) {
		message_player("^1ERROR: ^7Invalid number of arguments.");
		return;
	}

	args1 = args[1]; // num | string
	args2 = args[2]; // message
	if(!isDefined(args1) || !isDefined(args2)) {
		message_player("^1ERROR: ^7Invalid argument.");
		return;
	}

	if(codam\_mm_mmm::validate_number(args1)) {
		if(args1 == self getEntityNumber()) {
			message_player("^1ERROR: ^7You can't use this command on yourself.");
			return;
		}

		player = codam\_mm_mmm::playerByNum(args1);
		if(!isDefined(player)) {
			message_player("^1ERROR: ^7No such player.");
			return;
		}
	} else {
		player = playerByName(args1);
		if(!isDefined(player)) return;

		if(player == self) {
			message_player("^1ERROR: ^7You can't use this command on yourself.");
			return;
		}
	}

	if(args.size > 2) {
		for(a = 3; a < args.size; a++)
			if(isDefined(args[a]))
				args2 += " " + args[a];
	}

	message_player("^5INFO: ^7Warning sent to " + codam\_mm_mmm::namefix(player.name) + "^7.");
	message_player("^1Warning: ^7" + args2, player);
}

cmd_kill(args)
{
	if(args.size != 2) {
		message_player("^1ERROR: ^7Invalid number of arguments.");
		return;
	}

	args1 = args[1]; // num | string
	if(!isDefined(args1)) {
		message_player("^1ERROR: ^7Invalid argument.");
		return;
	}

	if(codam\_mm_mmm::validate_number(args1)) {
		if(args1 == self getEntityNumber()) {
			message_player("^1ERROR: ^7You can't use this command on yourself.");
			return;
		}

		player = codam\_mm_mmm::playerByNum(args1);
		if(!isDefined(player)) {
			message_player("^1ERROR: ^7No such player.");
			return;
		}
	} else {
		player = playerByName(args1);
		if(!isDefined(player)) return;

		if(player == self) {
			message_player("^1ERROR: ^7You can't use this command on yourself.");
			return;
		}
	}

	if(isAlive(player)) {
		player suicide();
		message_player("^5INFO: ^7You killed " + codam\_mm_mmm::namefix(player.name) + "^7.");
		message_player("^5INFO: ^7You were killed by " + codam\_mm_mmm::namefix(self.name) + "^7.", player);
	} else
		message_player("^1ERROR: ^7Player must be alive.");
}

cmd_weapon(args) // without the _mp at end of filename
{ // requested by hehu
	if(args.size < 2 || args.size > 3) {
		message_player("^1ERROR: ^7Invalid number of arguments.");
		return;
	}

	args1 = args[1]; // num | string
	if(!isDefined(args1)) {
		message_player("^1ERROR: ^7Invalid argument.");
		return;
	}

	if(!codam\_mm_mmm::validate_number(args1) && args.size != 3) {
		player = self;
		weapon = args1;
	} else {
		weapon = args[2];
		if(!isDefined(weapon)) {
			message_player("^1ERROR: ^7Invalid weapon.");
			return;
		}

		if(codam\_mm_mmm::validate_number(args1)) {
			player = codam\_mm_mmm::playerByNum(args1);
			if(!isDefined(player)) {
				message_player("^1ERROR: ^7No such player.");
				return;
			}
		} else {
			player = playerByName(args1);
			if(!isDefined(player)) return;
		}
	}

	weapontypes = "primary secondary grenade";
	weapontypes = codam\_mm_mmm::strTok(weapontypes, " ");

	if(isAlive(player)) { // requested by hehu
		player endon("disconnect");
		for(i = 0; i < weapontypes.size; i++) {
			if(!isAlive(player))
				break;

			weaponlist = getCvar("scr_mm_weaponcmd_list_" + weapontypes[i]);
			if(weaponlist == "none")
				continue;

			if(weaponlist != "")
				weapons = codam\_mm_mmm::strTok(weaponlist, " "); // requested by hehu
			else {
				switch(weapontypes[i]) {
					case "primary":
						weapons = codam\_mm_mmm::strTok("mosin_nagant_sniper ppsh42 bar bren enfield fg42 kar98k kar98k_sniper m1carbine m1garand mosin_nagant mp40 mp44 panzerfaust ppsh springfield sten thompson", " ");
					break;

					case "secondary":
						weapons = codam\_mm_mmm::strTok("colt luger", " ");
					break;

					case "grenade":
						weapons = codam\_mm_mmm::strTok("fraggrenade mk1britishfrag rgd-33russianfrag stielhandgranate", " ");
					break;
				}
			}

			if(!codam\_mm_mmm::in_array(weapons, weapon)) {
				for(w = 0; w < weapons.size; w++) {
					if(codam\_mm_mmm::pmatch(tolower(weapons[w]), tolower(weapon))) {
						weapon = weapons[w];
						break;
					}
				}
			}

			if(codam\_mm_mmm::in_array(weapons, weapon)) {
				if(player != self) {
					message_player("^5INFO: ^7You gave " + codam\_mm_mmm::namefix(player.name) + " ^7a/an " + weapon + "^7.");
					message_player("You were given a/an " + weapon + " by " + codam\_mm_mmm::namefix(self.name) + "^7.", player);
				} else
					message_player("^5INFO: ^7You gave yourself a/an " + weapon + "^7.");

				switch(weapontypes[i]) {
					case "primary":
						playerweapon = player getWeaponSlotWeapon("primaryb");
						if(isDefined(playerweapon))
							player takeWeapon(player getWeaponSlotWeapon("primaryb"));
					break;

					case "secondary":
						playerweapon = player getWeaponSlotWeapon("pistol");
						if(isDefined(playerweapon))
							player takeWeapon(player getWeaponSlotWeapon("pistol"));
					break;

					case "grenade":
						playerweapon = player getWeaponSlotWeapon("grenade");
						if(isDefined(playerweapon))
							player takeWeapon(player getWeaponSlotWeapon("grenade"));
					break;
				}

				weapon = weapon + "_mp";

				player giveWeapon(weapon);
				player giveMaxAmmo(weapon);
				player switchToWeapon(weapon);
				break;
			} else {
				if(i == (weapontypes.size - 1))
					message_player("^1ERROR: ^7Unable to determine weapon.");
			}
		}
	} else
		message_player("^1ERROR: ^7Player must be alive.");
}

cmd_heal(args)
{
	if(args.size != 2) {
		message_player("^1ERROR: ^7Invalid number of arguments.");
		return;
	}

	args1 = args[1]; // num | string
	if(!isDefined(args1)) {
		message_player("^1ERROR: ^7Invalid argument.");
		return;
	}

	if(codam\_mm_mmm::validate_number(args1)) {
		player = codam\_mm_mmm::playerByNum(args1);
		if(!isDefined(player)) {
			message_player("^1ERROR: ^7No such player.");
			return;
		}
	} else {
		player = playerByName(args1);
		if(!isDefined(player)) return;
	}

	if(isAlive(player)) {
		player.health = player.maxhealth;
		if(player != self) {
			message_player("^5INFO: ^7You healed " + codam\_mm_mmm::namefix(player.name) + "^7.");
			message_player("^5INFO: ^7You were healed by " + codam\_mm_mmm::namefix(self.name) + "^7.", player);
		} else
			message_player("^5INFO: ^7You healed yourself.");
	} else
		message_player("^1ERROR: ^7Player must be alive.");
}

valid_ip(ip)
{
	ip = codam\_mm_mmm::strTok(ip, ".");
	if(ip.size != 4)
		return false;

	for(i = 0; i < ip.size; i++) {
		validip = false;

		if(!codam\_mm_mmm::validate_number(ip[i]))
			break;

		if((int)ip[i] >= 0 && (int)ip[i] <= 255)
			validip = true;
		else
			break;
	}

	return validip;
}

cmd_ban(args)
{
	if(args.size < 3) {
		message_player("^1ERROR: ^7Invalid number of arguments.");
		return;
	}

	args1 = args[1]; // num | string | IP
	args2 = args[2]; // reason

	if(!isDefined(args1) || !isDefined(args2)) {
		message_player("^1ERROR: ^7Invalid argument.");
		return;
	}

	validip = false;
	if(isDefined(args[3]))
		validip = valid_ip(args1);

	if(!validip) {
		if(codam\_mm_mmm::validate_number(args1)) {
			if(args1 == self getEntityNumber()) {
				message_player("^1ERROR: ^7You can't use this command on yourself.");
				return;
			}

			player = codam\_mm_mmm::playerByNum(args1);
			if(!isDefined(player)) {
				message_player("^1ERROR: ^7No such player.");
				return;
			}
		} else {
			player = playerByName(args1);
			if(!isDefined(player)) return;

			if(player == self) {
				message_player("^1ERROR: ^7You can't use this command on yourself.");
				return;
			}
		}
	}

	if(level.banactive) {
		message_player("^1ERROR: ^7Database is already in use. Try again.");
		return;
	}

	bannedreason = codam\_mm_mmm::namefix(args2); // To prevent malicious input

	level.banactive = true;
	filename = level.workingdir + level.banfile;
	if(fexists(filename)) {
		if(validip) {
			bannedip = args1;
			bannedname = "^7An IP address";
		} else {
			bannedip = player getip();
			bannedname = codam\_mm_mmm::namefix(player.name);
			kickmsg = "Player Banned: ^1" + bannedreason;
			player dropclient(kickmsg);
		}

		bannedby = codam\_mm_mmm::namefix(self.pers["mm_user"]);

		file = fopen(filename, "a"); // append
		if(file != -1) {
			line = "";
			line += bannedip;
			line += "%%" + bannedname;
			line += "%%" + bannedreason;
			line += "%%" + bannedby;
			line += "\n";
			fwrite(line, file);
		}

		fclose(file);

		message_player("^5INFO: ^7You banned IP: " + bannedip);
		message(bannedname + " ^7was banned by " + codam\_mm_mmm::namefix(self.name) + " ^7for reason: " + bannedreason + ".");

		index = level.bans.size;
		level.bans[index]["bannedip"] = bannedip;
		level.bans[index]["bannedname"] = bannedname;
		level.bans[index]["bannedreason"] = bannedreason;
		level.bans[index]["bannedby"] = bannedby;
	} else
		message_player("^1ERROR: ^7Ban database file doesn't exist.");

	level.banactive = false;
}

cmd_report(args)
{
	if(args.size < 3) {
		message_player("^1ERROR: ^7Invalid number of arguments.");
		return;
	}

	args1 = args[1]; // num | string
	args2 = args[2]; // reason

	if(!isDefined(args1) || !isDefined(args2)) {
		message_player("^1ERROR: ^7Invalid argument.");
		return;
	}

	if(codam\_mm_mmm::validate_number(args1)) {
		if(args1 == self getEntityNumber()) {
			message_player("^1ERROR: ^7You can't use this command on yourself.");
			return;
		}

		player = codam\_mm_mmm::playerByNum(args1);
		if(!isDefined(player)) {
			message_player("^1ERROR: ^7No such player.");
			return;
		}
	} else {
		player = playerByName(args1);
		if(!isDefined(player)) return;

		if(player == self) {
			message_player("^1ERROR: ^7You can't use this command on yourself.");
			return;
		}
	}

	if(level.reportactive) {
		message_player("^1ERROR: ^7Database is already in use. Try again.");
		return;
	}

	reportreason = codam\_mm_mmm::namefix(args2); // To prevent malicious input

	level.reportactive = true;
	filename = level.workingdir + level.reportfile;
	if(fexists(filename)) {
		file = fopen(filename, "a"); // append
		if(file != -1) {
			line = "";
			line += codam\_mm_mmm::namefix(self.name);
			line += "%%" + self getip();
			line += "%%" + codam\_mm_mmm::namefix(player.name);
			line += "%%" + player getip();
			line += "%%" + reportreason;
			line += "\n";
			fwrite(line, file);
		}

		fclose(file);

		message_player("^5INFO: ^7You reported " + codam\_mm_mmm::namefix(player.name) + "^7 with reason: " + reportreason);
	} else
		message_player("^1ERROR: ^7Report database file doesn't exist.");

	level.reportactive = false;
}

isbanned(bannedip)
{
	for(b = 0; b < level.bans.size; b++) {
		if(isDefined(level.bans[b]) && level.bans[b]["bannedip"] == bannedip)
			return b;
	}

	return -1;
}

cmd_unban(args)
{
	if(args.size != 2) {
		message_player("^1ERROR: ^7Invalid number of arguments.");
		return;
	}

	if(level.banactive) {
		message_player("^1ERROR: ^7Database is already in use. Try again.");
		return;
	}

	bannedip = args[1]; // IP
	if(!isDefined(bannedip)) {
		message_player("^1ERROR: ^7Invalid argument.");
		return;
	}

	if(!valid_ip(bannedip)) {
		message_player("^1ERROR: ^7Invalid IP address.");
		return;
	}

	banindex = isbanned(bannedip);
	if(banindex != -1) {
		message_player("^5INFO: ^7You unbanned IP: " + bannedip);
		message(level.bans[banindex]["bannedname"] + " ^7got unbanned by " + codam\_mm_mmm::namefix(self.name) + "^7.");
		codam\_mm_mmm::mmlog("unban;" + bannedip + ";" + level.bans[banindex]["bannedname"] + ";" + level.bans[banindex]["bannedreason"] + ";" + level.bans[banindex]["bannedby"] + ";" + codam\_mm_mmm::namefix(self.name));
		level.bans[banindex] = undefined;

		level.banactive = true;
		filename = level.workingdir + level.banfile;
		if(fexists(filename)) { // may not be needed as "w" created a new file
			file = fopen(filename, "w");
			if(file != -1) {
				for(i = 0; i < level.bans.size; i++) {
					if(!isDefined(level.bans[i])) // if(i == banindex)
						continue;

					line = "";
					line += level.bans[i]["bannedip"];
					line += "%%" + level.bans[i]["bannedname"];
					line += "%%" + level.bans[i]["bannedreason"];
					line += "%%" + level.bans[i]["bannedby"];
					line += "\n";
					fwrite(line, file);
				}
			}
			fclose(file);
		} else
			message_player("^1ERROR: ^7Ban database file doesn't exist.");

		level.banactive = false;
	} else
		message_player("^1ERROR: ^7IP not found in loaded banlist.");
}

/* ---------- */
_checkMuted(a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, b0, b1, b2, b3, b4, b5, b6, b7, b8, b9) // "num;num;num"
{
	muted = getCvar("tmp_mm_muted");
	if(muted != "") {
		num = self getEntityNumber();
		muted = codam\_mm_mmm::strTok(muted, ";");

		if(codam\_mm_mmm::in_array(muted, num))
			self.pers["mm_mute"] = true;
	}
}

_checkLoggedIn(a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, b0, b1, b2, b3, b4, b5, b6, b7, b8, b9) // "username|group|num;username|group|num"
{
	loggedin = getCvar("tmp_mm_loggedin");
	if(loggedin != "") {
		loggedin = codam\_mm_mmm::strTok(loggedin, ";");
		for(i = 0; i < loggedin.size; i++) {
			num = self getEntityNumber();
			user = codam\_mm_mmm::strTok(loggedin[i], "|");

			if(user[2] == num) {
				self.pers["mm_group"] = user[1];
				self.pers["mm_user"] = user[0];
			}
		}
	}
}

_checkFOV(a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, b0, b1, b2, b3, b4, b5, b6, b7, b8, b9) // "fov|num;fov|num"
{
	fov = getCvar("tmp_mm_fov");
	if(fov != "") {
		fov = codam\_mm_mmm::strTok(fov, ";");
		for(i = 0; i < fov.size; i++) {
			num = self getEntityNumber();
			user = codam\_mm_mmm::strTok(fov[i], "|");

			if(user[1] == num) {
				self.pers["mm_fov"] = user[0];
				self setClientCvar("cg_fov", self.pers["mm_fov"]);
				break;
			}
		}
	}
}

_loadFOV()
{
	wait 1;

	players = getEntArray("player", "classname");
	for(i = 0; i < players.size; i++)
		if(isDefined(players[i].pers["mm_fov"]))
			players[i] setClientCvar("cg_fov", players[i].pers["mm_fov"]);
}

_loadBans()
{
	filename = level.workingdir + level.banfile;
	if(fexists(filename)) {
		file = fopen(filename, "r");
		if(file != -1) {
			data = fread(0, file); // codextended.so bug?
			if(isDefined(data)) {
				data = codam\_mm_mmm::strTok(data, "\n");
				for(i = 0; i < data.size; i++) {
					if(!isDefined(data[i])) // crashed here for some odd reason? this should never happen
						continue; // crashed here for some odd reason? this should never happen

					line = codam\_mm_mmm::strTok(data[i], "%"); // crashed here for some odd reason? this should never happen
					if(line.size != 4) // Reported by ImNoob
						continue;

					banfile_error = false;
					for(l = 0; l < line.size; l++) {
						if(!isDefined(line[l])) {
							banfile_error = true;
							break;
						}
					}

					if(banfile_error)
						continue;// Reported by ImNoob

					bannedip = line[0];
					bannedname = codam\_mm_mmm::namefix(line[1]);
					bannedreason = codam\_mm_mmm::namefix(line[2]);
					bannedby = codam\_mm_mmm::namefix(line[3]);

					index = level.bans.size;
					level.bans[index]["bannedip"] = bannedip;
					level.bans[index]["bannedname"] = bannedname;
					level.bans[index]["bannedreason"] = bannedreason;
					level.bans[index]["bannedby"] = bannedby;
				}
			}
		}

		fclose(file);
	}
}

_delete(a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, b0, b1, b2, b3, b4, b5, b6, b7, b8, b9)
{
	num = self getEntityNumber();
	_removeLoggedIn(num);
	_removeMuted(num);
	_removeFOV(num);
}

_removeMuted(num)
{
	muted = getCvar("tmp_mm_muted");
	if(muted != "") {
		muted = codam\_mm_mmm::strTok(muted, ";");
		if(codam\_mm_mmm::in_array(muted, num)) {
			rID = "";
			for(i = 0; i < muted.size; i++) {
				if(muted[i] != num) {
					rID += muted[i];
					rID += ";";
				}
			}

			setCvar("tmp_mm_muted", rID);
		}
	}
}

_removeLoggedIn(num)
{
	loggedin = getCvar("tmp_mm_loggedin");
	if(loggedin != "") {
		loggedin = codam\_mm_mmm::strTok(loggedin, ";");
		validuser = false;

		rSTR = "";
		for(i = 0; i < loggedin.size; i++) {
			user = codam\_mm_mmm::strTok(loggedin[i], "|");
			if(user[2] == num) {
				validuser = true;
				continue;
			}

			rSTR += loggedin[i];
			rSTR += ";";
		}

		if(validuser)
			setCvar("tmp_mm_loggedin", rSTR);
	}
}

_removeFOV(num)
{
	fov = getCvar("tmp_mm_fov");
	if(fov != "") {
		fov = codam\_mm_mmm::strTok(fov, ";");
		validuser = false;

		rSTR = "";
		for(i = 0; i < fov.size; i++) {
			user = codam\_mm_mmm::strTok(fov[i], "|");
			if(user[1] == num) {
				validuser = true;
				continue;
			}

			rSTR += fov[i];
			rSTR += ";";
		}

		if(validuser)
			setCvar("tmp_mm_fov", rSTR);
	}
}

_loadBadWords()
{
	badwords = "";
	for(i = 1; /* /!\ */; i++) {
		if(getCvar("scr_mm_badwords" + i) != "") {
			if(i > 1)
				badwords += " ";
			badwords += getCvar("scr_mm_badwords" + i);
		} else
			break;
	}

	if(badwords != "")
		level.badwords = codam\_mm_mmm::strTok(badwords, " ");

	level notify("badwords_check");
}

/* ---------- */
/*
c = iPrintLnBold (all)
e = iPrintLn (all)
f = iPrintLn (all)
g = iPrintLnBold (all)
h = say (all)
i = say (all)
t = open team menu
w = drop client with message
*/
message_player(msg, player)
{
	if(!isDefined(player))
		player = self;

	player sendservercommand("i \"^7^7" + level.nameprefix + ": ^7" + msg + "\""); // ^7^7 fixes spaces problem
}

message(msg)
{
	sendservercommand("i \"^7^7" + level.nameprefix + ": ^7" + msg + "\""); // ^7^7 fixes spaces problem
}

playerByName(str) // 2021 attempt
{
	player = undefined;

	players = codam\_mm_mmm::getPlayersByName(str);
	if(players.size == 0)
		message_player("^1ERROR: ^7No matches.");
	else if(players.size != 1) {
		message_player("^1ERROR: ^7Too many matches.");
		message_player("-----------------------------------------------------");

		pdata = spawnStruct();
		pdata.num = 0;
		pdata.highscore = 0;
		pdata.ping = 0;

		for(i = 0; i < players.size; i++) {
			player = players[i];
			pnum = player getEntityNumber();

			if(player.score > pdata.highscore)
				pdata.highscore = player.score;

			if(pnum > pdata.num)
				pdata.num = pnum;

		 	ping = player getping();
			if(ping > pdata.ping)
				pdata.ping = ping;
		}

		pdata.num = pdata.num + "";
		pdata.num = pdata.num.size;

		pdata.highscore = pdata.highscore + "";
		pdata.highscore = pdata.highscore.size;

		pdata.ping = pdata.ping + "";
		pdata.ping = pdata.ping.size;

		for(i = 0; i < players.size; i++) {
			player = players[i];
			pnum = player getEntityNumber();
			pnumstr = pnum + "";
			pscorestr = player.score + "";
			pping = player getping();
			ppingstr = pping + "";
			message = "^1[^7NUM: " + pnum + spaces(pdata.num - pnumstr.size) + " ^1|^7 Score: " + player.score + spaces(pdata.highscore - pscorestr.size) + " ^1|^7 ";
			message += "Ping: " + pping + spaces(pdata.ping - ppingstr.size);
			message += "^1]^3 -->^7 " + codam\_mm_mmm::namefix(player.name);

			message_player(message);
		}
		return undefined; // recode sometime used to be player = undefined from start of function
	} else
		player = players[0];

	return player;
}

/* ---------- */
/*     Cheese */

cmd_drop(args)
{
	if(args.size < 2 || args.size > 3) {
		message_player("^1ERROR: ^7Invalid number of arguments.");
		return;
	}

	args1 = args[1]; // num | string
	if(!isDefined(args1)) {
		message_player("^1ERROR: ^7Invalid argument.");
		return;
	}

	if(codam\_mm_mmm::validate_number(args1)) {
		if(args1 == self getEntityNumber()) {
			message_player("^1ERROR: ^7You can't use this command on yourself.");
			return;
		}

		player = codam\_mm_mmm::playerByNum(args1);
		if(!isDefined(player)) {
			message_player("^1ERROR: ^7No such player.");
			return;
		}
	} else {
		player = playerByName(args1);
		if(!isDefined(player)) return;

		if(player == self) {
			message_player("^1ERROR: ^7You can't use this command on yourself.");
			return;
		}
	}

	height = 512;
	if(args.size == 3)
		if(codam\_mm_mmm::validate_number(args[2]))
			height = (int)args[2];

	if(isAlive(player)) {
		player endon("disconnect");
		player.drop = spawn("script_origin", player.origin);
		player linkto(player.drop);

		player.drop movez(height, 2);
		wait 2;
		player unlink();
		player.drop delete();

		iPrintLn(codam\_mm_mmm::namefix(player.name) + " ^7was dropped.");
	} else
		message_player("^1ERROR: ^7Player must be alive.");
}

cmd_spank(args)
{
	if(args.size < 2 || args.size > 3) {
		message_player("^1ERROR: ^7Invalid number of arguments.");
		return;
	}

	args1 = args[1]; // num | string
	if(!isDefined(args1)) {
		message_player("^1ERROR: ^7Invalid argument.");
		return;
	}

	if(codam\_mm_mmm::validate_number(args1)) {
		if(args1 == self getEntityNumber()) {
			message_player("^1ERROR: ^7You can't use this command on yourself.");
			return;
		}

		player = codam\_mm_mmm::playerByNum(args1);
		if(!isDefined(player)) {
			message_player("^1ERROR: ^7No such player.");
			return;
		}
	} else {
		player = playerByName(args1);
		if(!isDefined(player)) return;

		if(player == self) {
			message_player("^1ERROR: ^7You can't use this command on yourself.");
			return;
		}
	}

	time = 15;
	if(args.size == 3)
		if(codam\_mm_mmm::validate_number(args[2]))
			time = (int)args[2];

	if(isAlive(player)) {
		player endon("disconnect");

		iPrintLn(codam\_mm_mmm::namefix(player.name) + " ^7is getting spanked.");

		player shellshock("default", time / 2);

		for(i = 0; i < time; i++) {
			player playSound("melee_hit");
			player setClientCvar("cl_stance", 2);
			wait randomFloat(0.5);
		}

		player shellshock("default", 1);
	} else
		message_player("^1ERROR: ^7Player must be alive.");
}

cmd_slap(args)
{
	if(args.size < 2 || args.size > 3) {
		message_player("^1ERROR: ^7Invalid number of arguments.");
		return;
	}

	args1 = args[1]; // num | string
	if(!isDefined(args1)) {
		message_player("^1ERROR: ^7Invalid argument.");
		return;
	}

	if(codam\_mm_mmm::validate_number(args1)) {
		if(args1 == self getEntityNumber()) {
			message_player("^1ERROR: ^7You can't use this command on yourself.");
			return;
		}

		player = codam\_mm_mmm::playerByNum(args1);
		if(!isDefined(player)) {
			message_player("^1ERROR: ^7No such player.");
			return;
		}
	} else {
		player = playerByName(args1);
		if(!isDefined(player)) return;

		if(player == self) {
			message_player("^1ERROR: ^7You can't use this command on yourself.");
			return;
		}
	}

	dmg = 10;
	if(args.size == 3)
		if(codam\_mm_mmm::validate_number(args[2]))
			dmg = (int)args[2];

	if(isAlive(player)) {
		player endon("disconnect");

		iPrintLn(codam\_mm_mmm::namefix(player.name) + " ^7is getting slapped.");

		eInflictor = player;
		eAttacker = player;
		iDamage = dmg;
		iDFlags = 0;
		sMeansOfDeath = "MOD_PROJECTILE";
		sWeapon = "panzerfaust_mp";
		vPoint = player.origin + (0, 0, -1);
		vDir = vectorNormalize( player.origin - vPoint );
		sHitLoc = "none";
		psOffsetTime = 0;

		player playSound("melee_hit");
		player finishPlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime);
	} else
		message_player("^1ERROR: ^7Player must be alive.");
}

cmd_blind(args)
{
	if(args.size < 2 || args.size > 3) {
		message_player("^1ERROR: ^7Invalid number of arguments.");
		return;
	}

	args1 = args[1]; // num | string
	if(!isDefined(args1)) {
		message_player("^1ERROR: ^7Invalid argument.");
		return;
	}

	if(codam\_mm_mmm::validate_number(args1)) {
		if(args1 == self getEntityNumber()) {
			message_player("^1ERROR: ^7You can't use this command on yourself.");
			return;
		}

		player = codam\_mm_mmm::playerByNum(args1);
		if(!isDefined(player)) {
			message_player("^1ERROR: ^7No such player.");
			return;
		}
	} else {
		player = playerByName(args1);
		if(!isDefined(player)) return;

		if(player == self) {
			message_player("^1ERROR: ^7You can't use this command on yourself.");
			return;
		}
	}

	time = 15;
	if(args.size == 3)
		if(codam\_mm_mmm::validate_number(args[2]))
			time = (int)args[2];

	player endon("disconnect");

	iPrintLn(codam\_mm_mmm::namefix(player.name) + " ^7was blinded for " + time + " seconds.");
	half = time / 2;

	player shellshock("default", time);
	player.blindscreen = newClientHudElem(player);
	player.blindscreen.x = 0;
	player.blindscreen.y = 0;
	player.blindscreen.alpha = 1;
	player.blindscreen setShader("white", 640, 480);
	wait half;
	player.blindscreen fadeOverTime(half);
	player.blindscreen.alpha = 0;
	wait half;
	player.blindscreen destroy();
}

cmd_runover(args)
{
	if(args.size != 2) {
		message_player("^1ERROR: ^7Invalid number of arguments.");
		return;
	}

	args1 = args[1]; // num | string
	if(!isDefined(args1)) {
		message_player("^1ERROR: ^7Invalid argument.");
		return;
	}

	if(codam\_mm_mmm::validate_number(args1)) {
		if(args1 == self getEntityNumber()) {
			message_player("^1ERROR: ^7You can't use this command on yourself.");
			return;
		}

		player = codam\_mm_mmm::playerByNum(args1);
		if(!isDefined(player)) {
			message_player("^1ERROR: ^7No such player.");
			return;
		}
	} else {
		player = playerByName(args1);
		if(!isDefined(player)) return;

		if(player == self) {
			message_player("^1ERROR: ^7You can't use this command on yourself.");
			return;
		}
	}

	if(isAlive(player)) {
		player endon("disconnect");

		lol = spawn("script_origin", player getOrigin());
		player linkto(lol);
		tank = spawn("script_model", player getOrigin() + (-512, 0, -256));
		tank setmodel("xmodel/vehicle_tank_tiger");
		angles = vectortoangles(player getOrigin() - (tank.origin + (0, 0, 256 )));
		tank.angles = angles;
		//tank playloopsound("tiger_engine_high");
		tank playloopsound("Tank_stone_breakthrough"); // alternative sound as above doesn't play, verified by AJ
		tank movez(256, 1);
		wait 1;
		tank movex(1024, 5);
		wait 1.8;
		iPrintLn(codam\_mm_mmm::namefix(player.name) + " ^7was run over by a tank.");
		player suicide();
		wait 3.2;
		tank movez(-256, 1);
		wait 1;
		tank stoploopsound();
		tank delete();
		lol delete();
	} else
		message_player("^1ERROR: ^7Player must be alive.");
}

cmd_squash(args)
{
	if(args.size != 2) {
		message_player("^1ERROR: ^7Invalid number of arguments.");
		return;
	}

	args1 = args[1]; // num | string
	if(!isDefined(args1)) {
		message_player("^1ERROR: ^7Invalid argument.");
		return;
	}

	if(codam\_mm_mmm::validate_number(args1)) {
		if(args1 == self getEntityNumber()) {
			message_player("^1ERROR: ^7You can't use this command on yourself.");
			return;
		}

		player = codam\_mm_mmm::playerByNum(args1);
		if(!isDefined(player)) {
			message_player("^1ERROR: ^7No such player.");
			return;
		}
	} else {
		player = playerByName(args1);
		if(!isDefined(player)) return;

		if(player == self) {
			message_player("^1ERROR: ^7You can't use this command on yourself.");
			return;
		}
	}

	if(isAlive(player)) {
		player endon("disconnect");

		lol = spawn("script_model", player getOrigin());
		player linkto(lol);
		thing = spawn("script_model", player getOrigin() + (0, 0, 1024));
		thing setmodel("xmodel/vehicle_russian_barge");
		thing movez(-1024, 2);
		wait 2;
		iPrintLn(codam\_mm_mmm::namefix(player.name) + " ^7was squashed with a russian barge!");
		player suicide();
		thing movez(-512, 5);
		wait 5;
		thing delete();
		lol delete();
	} else
		message_player("^1ERROR: ^7Player must be alive.");
}

cmd_rape(args)
{
	if(args.size != 2) {
		message_player("^1ERROR: ^7Invalid number of arguments.");
		return;
	}

	args1 = args[1]; // num | string
	if(!isDefined(args1)) {
		message_player("^1ERROR: ^7Invalid argument.");
		return;
	}

	if(codam\_mm_mmm::validate_number(args1)) {
		if(args1 == self getEntityNumber()) {
			message_player("^1ERROR: ^7You can't use this command on yourself.");
			return;
		}

		player = codam\_mm_mmm::playerByNum(args1);
		if(!isDefined(player)) {
			message_player("^1ERROR: ^7No such player.");
			return;
		}
	} else {
		player = playerByName(args1);
		if(!isDefined(player)) return;

		if(player == self) {
			message_player("^1ERROR: ^7You can't use this command on yourself.");
			return;
		}
	}

	if(isAlive(player)) {
		dumas = spawn("script_model", (0, 0, 0));
		dumas setmodel("xmodel/playerbody_russian_conscript");

		player thread forceprone();

		iPrintLnBold(codam\_mm_mmm::namefix(player.name) + "^3 is getting raped by dumas!");

		player endon("spawned");
		player endon("disconnect");

		while(isAlive(player)) {
			tracedir = anglestoforward(player getPlayerAngles());
			traceend = player.origin;
			traceend += codam\_mm_mmm::vectorScale(tracedir, -56);
			trace = bullettrace(player.origin, traceend, false, player);
			pos = trace["position"];

			dumas.origin = pos;
			dumas.angles = (45, player.angles[1], player.angles[2]);

			rapedir = dumas.origin - player.origin;

			dumas moveto(player.origin, 0.5);
			wait 0.3;
			dumas moveto(pos, 0.25);
			wait 0.25;
			player finishplayerdamage(player, player, 20, 0, "MOD_PROJECTILE", "panzerfaust_mp", dumas.origin, vectornormalize(dumas.origin - player.origin), "none");
		}

		dumas delete();
	} else
		message_player("^1ERROR: ^7Player must be alive.");
}

forceprone(args) {
	self endon("death");
	self endon("disconnect");
	self endon("spawned");

	while(isAlive(self)) {
		self setClientCvar("cl_stance", 2);
		wait 0.05;
	}
}

cmd_toilet(args)
{
	if(args.size < 2 || args.size > 3) {
		message_player("^1ERROR: ^7Invalid number of arguments.");
		return;
	}

	args1 = args[1]; // num | string
	if(!isDefined(args1)) {
		message_player("^1ERROR: ^7Invalid argument.");
		return;
	}

	if(codam\_mm_mmm::validate_number(args1)) {
		if(args1 == self getEntityNumber()) {
			message_player("^1ERROR: ^7You can't use this command on yourself.");
			return;
		}

		player = codam\_mm_mmm::playerByNum(args1);
		if(!isDefined(player)) {
			message_player("^1ERROR: ^7No such player.");
			return;
		}
	} else {
		player = playerByName(args1);
		if(!isDefined(player)) return;

		if(player == self) {
			message_player("^1ERROR: ^7You can't use this command on yourself.");
			return;
		}
	}

	time = 15;
	if(args.size == 3)
		if(codam\_mm_mmm::validate_number(args[2]))
			time = (int)args[2];

	if(isAlive(player)) {
		player endon("disconnect");

		player detachall();
		player takeAllWeapons();
		player setmodel("xmodel/toilet");

		iPrintLn(codam\_mm_mmm::namefix(player.name) + " ^7was turned into a toilet.");

		player setClientCvar("cg_thirdperson", "1");

		wait time;

		player setClientCvar("cg_thirdperson", "0");
		player suicide();
	} else
		message_player("^1ERROR: ^7Player must be alive.");
}

/* PowerServer */

cmd_explode(args)
{
	if(args.size != 2) {
		message_player("^1ERROR: ^7Invalid number of arguments.");
		return;
	}

	args1 = args[1]; // num | string
	if(!isDefined(args1)) {
		message_player("^1ERROR: ^7Invalid argument.");
		return;
	}

	if(codam\_mm_mmm::validate_number(args1)) {
		if(args1 == self getEntityNumber()) {
			message_player("^1ERROR: ^7You can't use this command on yourself.");
			return;
		}

		player = codam\_mm_mmm::playerByNum(args1);
		if(!isDefined(player)) {
			message_player("^1ERROR: ^7No such player.");
			return;
		}
	} else {
		player = playerByName(args1);
		if(!isDefined(player)) return;

		if(player == self) {
			message_player("^1ERROR: ^7You can't use this command on yourself.");
			return;
		}
	}

	if(isAlive(player)) {
		playfx(level._effect["bombexplosion"], player.origin);
		player suicide();
		iPrintLn(codam\_mm_mmm::namefix(player.name) + " ^7got a blowjob!");
	} else
		message_player("^1ERROR: ^7Player must be alive.");
}

cmd_force(args)
{
	if(args.size < 2) {
		message_player("^1ERROR: ^7Invalid number of arguments.");
		return;
	}

	args1 = args[1]; // axis | allies | spectator
	args2 = args[2]; // num | all
	if(!isDefined(args1) || !isDefined(args2)) {
		message_player("^1ERROR: ^7Invalid argument.");
		return;
	}

	if(args1 != "allies" && args1 != "axis" && args1 != "spectator") {
		message_player("^1ERROR: ^7Invalid team.");
		return;
	}

	players = [];
	if(args2 == "all") {
		players = getEntArray("player", "classname");
		[[ level.gtd_call ]]("switchTeam", players, args1, true);
		return;
	}

	for(i = 2; i < args.size; i++) {
		if(codam\_mm_mmm::validate_number(args[i])) {
			playernum = codam\_mm_mmm::playerByNum(args[i]);
			if(isDefined(playernum))
				players[players.size] = playernum;
		}
	}

	if(players.size > 0) {
		[[ level.gtd_call ]]("switchTeam", players, args1, true);

		for(i = 0; i < players.size; i++)
			iPrintLn(codam\_mm_mmm::namefix(players[i].name) + " ^7was forced to join " + args1 + ".");
	}
}

cmd_mortar(args)
{
	if(args.size != 2) {
		message_player("^1ERROR: ^7Invalid number of arguments.");
		return;
	}

	args1 = args[1]; // num | string
	if(!isDefined(args1)) {
		message_player("^1ERROR: ^7Invalid argument.");
		return;
	}

	if(codam\_mm_mmm::validate_number(args1)) {
		if(args1 == self getEntityNumber()) {
			message_player("^1ERROR: ^7You can't use this command on yourself.");
			return;
		}

		player = codam\_mm_mmm::playerByNum(args1);
		if(!isDefined(player)) {
			message_player("^1ERROR: ^7No such player.");
			return;
		}
	} else {
		player = playerByName(args1);
		if(!isDefined(player)) return;

		if(player == self) {
			message_player("^1ERROR: ^7You can't use this command on yourself.");
			return;
		}
	}

	if(isAlive(player)) {
		message_player("^5INFO: ^7Dropping deadly mortars on player " + codam\_mm_mmm::namefix(player.name) + "^7.");
		player endon("disconnect");
		player playsound("generic_undersuppression_foley");
		player iPrintLn("INCOMING!!!");
		player thread codam\_mm_mmm::playSoundAtLocation("mortar_incoming", player.origin, 1);

		wait 1.5;

		while(player.sessionstate == "playing") {
			wait 0.5;

			playfx(level._effect["mortar_explosion"][randomInt(3)], player.origin);
			radiusDamage(player.origin, 200, 10, 10);
			thread codam\_mm_mmm::playSoundAtLocation("mortar_explosion", player.origin, .1);
			earthquake(0.3, 3, player.origin, 850);
		}
	} else
		message_player("^1ERROR: ^7Player must be alive.");
}

cmd_matrix(args)
{
	if(args.size != 1) {
		message_player("^1ERROR: ^7Invalid number of arguments.");
		return;
	}

	matrixmsg = [];
	matrixmsg[matrixmsg.size] = "You think that's air you're breathing?";
	matrixmsg[matrixmsg.size] = "Dodge this";
	matrixmsg[matrixmsg.size] = "Only human";
	matrixmsg[matrixmsg.size] = "There is no spoon";
	matrixmsg[matrixmsg.size] = "Wake up Neo";
	matrixmsg[matrixmsg.size] = "The Matrix has you";
	matrixmsg[matrixmsg.size] = "Follow the white rabbit";

	iPrintLnBold(matrixmsg[randomInt(matrixmsg.size)]);

	wait 2;

	players = getEntArray("player", "classname");

	for(i = 0; i < players.size; i++)
		players[i] shellshock("groggy", 6);

	setCvar("timescale", "0.5");
	setCvar("g_gravity", "50");

	wait 5;
	for(x = 0.5; x < 1; x = x + 0.05) {
		wait (0.1 / x);
		setCvar("timescale", x);
	}

	setCvar("timescale", "1");
	setCvar("g_gravity", "800");
}

cmd_burn(args)
{
	if(args.size != 2) {
		message_player("^1ERROR: ^7Invalid number of arguments.");
		return;
	}

	args1 = args[1]; // num | string
	if(!isDefined(args1)) {
		message_player("^1ERROR: ^7Invalid argument.");
		return;
	}

	if(codam\_mm_mmm::validate_number(args1)) {
		if(args1 == self getEntityNumber()) {
			message_player("^1ERROR: ^7You can't use this command on yourself.");
			return;
		}

		player = codam\_mm_mmm::playerByNum(args1);
		if(!isDefined(player)) {
			message_player("^1ERROR: ^7No such player.");
			return;
		}
	} else {
		player = playerByName(args1);
		if(!isDefined(player)) return;

		if(player == self) {
			message_player("^1ERROR: ^7You can't use this command on yourself.");
			return;
		}
	}

	if(isAlive(player)) {
		message_player("^5INFO: ^7Player " + codam\_mm_mmm::namefix(player.name) + " ^7set on fire.");
		player endon("disconnect");

		burnTime = 10;
		startTime = getTime() + (burnTime * 1000);

		while(1) {
			playfx(level._effect["fireheavysmoke"], player.origin);

			if(startTime < getTime()) {
				playfx(level._effect["flameout"], player.origin);
				player suicide();
				player playsound("generic_death_russian_4");
				break;
			}

			wait 0.1;
		}
	} else
		message_player("^1ERROR: ^7Player must be alive.");
}

cmd_cow(args)
{
	if(args.size != 2) {
		message_player("^1ERROR: ^7Invalid number of arguments.");
		return;
	}

	args1 = args[1]; // num | string
	if(!isDefined(args1)) {
		message_player("^1ERROR: ^7Invalid argument.");
		return;
	}

	if(codam\_mm_mmm::validate_number(args1)) {
		if(args1 == self getEntityNumber()) {
			message_player("^1ERROR: ^7You can't use this command on yourself.");
			return;
		}

		player = codam\_mm_mmm::playerByNum(args1);
		if(!isDefined(player)) {
			message_player("^1ERROR: ^7No such player.");
			return;
		}
	} else {
		player = playerByName(args1);
		if(!isDefined(player)) return;

		if(player == self) {
			message_player("^1ERROR: ^7You can't use this command on yourself.");
			return;
		}
	}

	if(isAlive(player)) {
		player endon("disconnect");

		iPrintLnBold(codam\_mm_mmm::namefix(player.name) + " ^7has been turned into BBQ'd beef!");
		player setmodel("xmodel/cow_standing");
		player.health = 100;
		player thread cmd_cow_extra("burn");
		player thread cmd_cow_extra();
		wait 0.1;
		player notify("remove_body");
		wait 9.5;
		player setmodel("xmodel/cow_dead");
	} else
		message_player("^1ERROR: ^7Player must be alive.");
}

cmd_cow_extra(arg) // lazy to fix
{
	if(isDefined(arg) && arg == "burn") {
		self endon("disconnect");

		burnTime = 10;
		startTime = getTime() + (burnTime * 1000);

		while(1) {
			playfx(level._effect["fireheavysmoke"], self.origin);

			if(startTime < getTime()) {
				playfx(level._effect["flameout"], self.origin);
				self suicide();
				self playsound("generic_death_russian_4");
				break;
			}

			wait 0.1;
		}
	} else {
		grenade = self getWeaponSlotWeapon("grenade");
		pistol = self getWeaponSlotWeapon("pistol");
		primary = self getWeaponSlotWeapon("primary");
		primaryb = self getWeaponSlotWeapon("primaryb");

		if(!isDefined(grenade))
			grenade = "none";
		if(!isDefined(pistol))
			pistol = "none";
		if(!isDefined(primary))
			primary = "none";
		if(!isDefined(primaryb))
			primary = "none";

		self dropItem(grenade);
		self dropItem(pistol);
		self dropItem(primary);
		self dropItem(primaryb);
	}
}

cmd_disarm(args)
{
	if(args.size != 2) {
		message_player("^1ERROR: ^7Invalid number of arguments.");
		return;
	}

	args1 = args[1]; // num | string
	if(!isDefined(args1)) {
		message_player("^1ERROR: ^7Invalid argument.");
		return;
	}

	if(codam\_mm_mmm::validate_number(args1)) {
		if(args1 == self getEntityNumber()) {
			message_player("^1ERROR: ^7You can't use this command on yourself.");
			return;
		}

		player = codam\_mm_mmm::playerByNum(args1);
		if(!isDefined(player)) {
			message_player("^1ERROR: ^7No such player.");
			return;
		}
	} else {
		player = playerByName(args1);
		if(!isDefined(player)) return;

		if(player == self) {
			message_player("^1ERROR: ^7You can't use this command on yourself.");
			return;
		}
	}

	if(isAlive(player)) {
		message_player("^5INFO: ^7Disarmed player " + codam\_mm_mmm::namefix(player.name) + "^7.");
		grenade = player getWeaponSlotWeapon("grenade");
		pistol = player getWeaponSlotWeapon("pistol");
		primary = player getWeaponSlotWeapon("primary");
		primaryb = player getWeaponSlotWeapon("primaryb");

		if(!isDefined(grenade))
			grenade = "none";
		if(!isDefined(pistol))
			pistol = "none";
		if(!isDefined(primary))
			primary = "none";
		if(!isDefined(primaryb))
			primary = "none";

		player dropItem(grenade);
		player dropItem(pistol);
		player dropItem(primary);
		player dropItem(primaryb);
	} else
		message_player("^1ERROR: ^7Player must be alive.");
}

/* Extra commands */
cmd_belmenu(args)
{
	if(args.size != 2) {
		message_player("^1ERROR: ^7Invalid number of arguments.");
		return;
	}

	if(!isDefined(args[1])) {
		message_player("^1ERROR: ^7Invalid argument.");
		return;
	}

	switch(args[1]) {
		case "on":
			message("^5INFO: ^7Enabled BEL menu.");
			setCvar("scr_mm_bel_menu", "1");
		break;
		case "off":
			message("^5INFO: ^7Disabled BEL menu.");
			setCvar("scr_mm_bel_menu", "0");
		break;
		default:
			message_player("^1ERROR: ^7Invalid argument.");
		break;
	}
}

/* War Commands */

cmd_wos(args)
{
	if(args.size != 1) {
		message_player("^1ERROR: ^7Invalid number of arguments.");
		return;
	}

	wremoveall();
	setCvar("scr_allow_kar98ksniper", "1");
	setCvar("scr_allow_nagantsniper", "1");
	setCvar("scr_allow_springfield", "1");
	setCvar("scr_allow_mg42", "0");

	message("^5INFO: ^7Only snipers enabled.");
}

cmd_waw(args)
{
	if(args.size > 2) {
		message_player("^1ERROR: ^7Invalid number of arguments.");
		return;
	}

	wremoveall();
	setCvar("scr_allow_nagant", "1");
	setCvar("scr_allow_kar98k", "1");
	setCvar("scr_allow_enfield", "1");
	setCvar("scr_allow_nagantsniper", "1");
	setCvar("scr_allow_kar98ksniper", "1");
	setCvar("scr_allow_springfield", "1");
	setCvar("scr_allow_m1carbine", "1");
	setCvar("scr_allow_m1garand", "1");
	setCvar("scr_allow_ppsh", "1");
	setCvar("scr_allow_thompson", "1");
	setCvar("scr_allow_mp40", "1");
	setCvar("scr_allow_sten", "1");
	setCvar("scr_allow_mp44", "1");
	setCvar("scr_allow_bar", "1");
	setCvar("scr_allow_bren", "1");
	setCvar("scr_allow_mg42", "1");

	if(isDefined(args[1])) {
		message("^5INFO: ^7All weapons with 1 sniper enabled.");
		setCvar("scr_mm_restrict_springfield", "1");
		setCvar("scr_mm_restrict_kar98ksniper", "1");
		setCvar("scr_mm_restrict_nagantsniper", "1");
	} else
		message("^5INFO: ^7All weapons enabled.");
}

cmd_womp(args)
{
	if(args.size != 1) {
		message_player("^1ERROR: ^7Invalid number of arguments.");
		return;
	}

	wremoveall();
	setCvar("scr_allow_ppsh", "1");
	setCvar("scr_allow_thompson", "1");
	setCvar("scr_allow_mp40", "1");
	setCvar("scr_allow_sten", "1");
	setCvar("scr_allow_mp44", "1");
	setCvar("scr_allow_bar", "1");
	setCvar("scr_allow_bren", "1");
	setCvar("scr_allow_mg42", "1");

	message("^5INFO: ^7Only machine guns enabled.");
}

wremoveall()
{
	setCvar("scr_allow_nagant", "0");
	setCvar("scr_allow_kar98k", "0");
	setCvar("scr_allow_enfield", "0");
	setCvar("scr_allow_nagantsniper", "0");
	setCvar("scr_allow_kar98ksniper", "0");
	setCvar("scr_allow_springfield", "0");
	setCvar("scr_allow_m1carbine", "0");
	setCvar("scr_allow_m1garand", "0");
	setCvar("scr_allow_ppsh", "0");
	setCvar("scr_allow_thompson", "0");
	setCvar("scr_allow_mp40", "0");
	setCvar("scr_allow_sten", "0");
	setCvar("scr_allow_mp44", "0");
	setCvar("scr_allow_bar", "0");
	setCvar("scr_allow_bren", "0");
	setCvar("scr_allow_mg42", "0");
	setCvar("scr_allow_fg42", "0");
	setCvar("scr_allow_panzerfaust", "0");

	setCvar("scr_mm_restrict_springfield", "0");
	setCvar("scr_mm_restrict_kar98ksniper", "0");
	setCvar("scr_mm_restrict_nagantsniper", "0");
}

cmd_wrifles(args)
{
	if(args.size != 2) {
		message_player("^1ERROR: ^7Invalid number of arguments.");
		return;
	}

	switch(args[1]) {
		case "on":
		case "only":
			if(args[1] == "only") {
				message("^5INFO: ^7Only rifles enabled.");
				wremoveall();
			} else
				message("^5INFO: ^7Rifles enabled.");
			setCvar("scr_allow_kar98k", "1");
			setCvar("scr_allow_enfield", "1");
			setCvar("scr_allow_nagant", "1");
		break;
		case "off":
			message("^5INFO: ^7Rifles disabled.");
			setCvar("scr_allow_kar98k", "0");
			setCvar("scr_allow_enfield", "0");
			setCvar("scr_allow_nagant", "0");
		break;
		default:
			message_player("^1ERROR: ^7Invalid argument.");
		break;
	}
}

cmd_wpistols(args)
{
	if(args.size < 2 || args.size > 3) {
		message_player("^1ERROR: ^7Invalid number of arguments.");
		return;
	}

	args1 = args[1]; // on/empty/disable/bullets
	args2 = args[2]; // chamber or clip
	if(!isDefined(args2))
		args2 = "";

	if(!isDefined(args1)) {
		message_player("^1ERROR: ^7Argument not specified.");
		return;
	}

	switch(args1) {
		case "on":
		case "reset":
			message("^5INFO: ^7Pistols enabled.");
			setCvar("scr_mm_allow_pistols", ""); // ammo?
		break;
		case "0":
		case "empty":
			message("^5INFO: ^7Pistols set to empty ammo.");
			setCvar("scr_mm_allow_pistols", "0");
		break;
		case "disable":
			message("^5INFO: ^7Pistols disabled.");
			setCvar("scr_mm_allow_pistols", "-1");
		break;
		default:
			if(codam\_mm_mmm::validate_number(args1)) {
				if(args2 == "chamber")
					message("^5INFO: ^7Pistol chamber ammo set to: " + args1 + ".");
				else
					message("^5INFO: ^7Pistol clip ammo set to: " + args1 + ".");
				setCvar("scr_mm_allow_pistols", args1);
			} else
				message_player("^1ERROR: ^7Invalid argument. Expected numeric value.");
		break;
	}

	if(args2 != "") // "chamber" or "clip" but defaults to any text for clip, default cvar in miscmod.gsc is "chamber"
		setCvar("scr_mm_allow_pistols_ammotype", args2);
}

cmd_wmap(args)
{
	if(args.size != 2) {
		message_player("^1ERROR: ^7Invalid number of arguments.");
		return;
	}

	args1 = args[1]; // "m1garand=kar98k colt=luger ppsh=mp44"

	if(!isDefined(args1)) {
		message_player("^1ERROR: ^7Invalid argument.");
		return;
	}

	switch(args1) {
		case "":
		case "reset":
			args1 = "";
		break;
		case "codam":
			if(level.tmp_mm_weapon_map != "empty")
				args1 = level.tmp_mm_weapon_map;
			else
				args1 = "";
		break;
	}

	if(args1 == "")
		message("^5INFO: ^7Weapon map set to empty value.");
	else
		message("^5INFO: ^7Weapon map set to: " + args1);
	setCvar("scr_weapon_map", args1);
}

cmd_whealth(args)
{
	if(args.size != 2) {
		message_player("^1ERROR: ^7Invalid number of arguments.");
		return;
	}

	args1 = args[1];

	if(!isDefined(args1)) {
		message_player("^1ERROR: ^7Invalid argument.");
		return;
	}

	switch(args1) {
		case "0": case "1": case "2": case "3":
			message("^5INFO: ^7" + args1 + "x healthpack enabled.");
			setCvar("ham_xpacks", args1);
			setCvar("scr_nohealthdrop", "1");
		break;
		case "off":
			message("^5INFO: ^7Healthpacks disabled.");
			setCvar("ham_xpacks", "0");
			setCvar("scr_nohealthdrop", "0");
		break;
		default:
			message_player("^1ERROR: ^7Invalid argument.");
		break;
	}
}

cmd_wgrenade(args)
{
	if(args.size != 2) {
		message_player("^1ERROR: ^7Invalid number of arguments.");
		return;
	}

	args1 = args[1];

	if(!isDefined(args1)) {
		message_player("^1ERROR: ^7Invalid argument.");
		return;
	}

	switch(args1) {
		case "0": case "1": case "2": case "3":
			message("^5INFO: ^7" + args1 + "x grenade enabled.");
			setCvar("scr_mm_allow_grenades", args1);
		break;
		case "off":
			message("^5INFO: ^7Grenades disabled.");
			setCvar("scr_mm_allow_grenades", "999"); // TODO: improve in the future
		break;
		case "reset":
			message("^5INFO: ^7Grenades reset.");
			setCvar("scr_mm_allow_grenades", "");
		break;
		default:
			message_player("^1ERROR: ^7Invalid argument.");
		break;
	}
}

cmd_w1sk(args)
{
	if(args.size != 2) {
		message_player("^1ERROR: ^7Invalid number of arguments.");
		return;
	}

	if(!isDefined(args[1])) {
		message_player("^1ERROR: ^7Invalid argument.");
		return;
	}

	switch(args[1]) {
		case "on":
			message("^5INFO: ^7Instant kill enabled.");
			setCvar("scr_mm_instantkill", "1");
		break;
		case "off":
			message("^5INFO: ^7Instant kill disabled.");
			setCvar("scr_mm_instantkill", "0");
		break;
		default:
			message_player("^1ERROR: ^7Invalid argument.");
		break;
	}
}

cmd_wmeleekill(args)
{
	if(args.size != 2) {
		message_player("^1ERROR: ^7Invalid number of arguments.");
		return;
	}

	if(!isDefined(args[1])) {
		message_player("^1ERROR: ^7Invalid argument.");
		return;
	}

	switch(args[1]) {
		case "on":
			message("^5INFO: ^7Instant kill on melee enabled.");
			setCvar("scr_mm_meleekill", "1");
		break;
		case "off":
			message("^5INFO: ^7Instant kill on melee disabled.");
			setCvar("scr_mm_meleekill", "0");
		break;
		default:
			message_player("^1ERROR: ^7Invalid argument.");
		break;
	}
}

cmd_wpsk(args)
{
	if(args.size != 2) {
		message_player("^1ERROR: ^7Invalid number of arguments.");
		return;
	}

	if(!isDefined(args[1])) {
		message_player("^1ERROR: ^7Invalid argument.");
		return;
	}

	switch(args[1]) {
		case "on":
			message("^5INFO: ^7Instant kill on pistols enabled.");
			setCvar("scr_mm_pistolkill", "1");
		break;
		case "off":
			message("^5INFO: ^7Instant kill on pistols disabled.");
			setCvar("scr_mm_pistolkill", "0");
		break;
		default:
			message_player("^1ERROR: ^7Invalid argument.");
		break;
	}
}

cmd_wroundlength(args)
{
	if(level.mmgametype != "sd" && level.mmgametype != "re") {
		message_player("^1ERROR: ^7Roundlength can only be set on SD or RE gametype.");
		return;
	}

	if(args.size != 2) {
		message_player("^1ERROR: ^7Invalid number of arguments.");
		return;
	}

	if(codam\_mm_mmm::validate_number(args[1], true)) {
		time = (float)args[1];

		switch(level.mmgametype) {
			case "sd":
				setCvar("scr_sd_roundlength", time);
			break;
			case "re":
				setCvar("scr_re_roundlength", time);
			break;
		}

		message("^5INFO: ^7Roundlength set to " + time);
	}
}

// commands from momo74
cmd_rs(args)
{
	if(args.size != 1) {
		message_player("^1ERROR: ^7Invalid number of arguments.");
		return;
	}

	self.score = 0;
	self.deaths = 0;
	if(isDefined(self.pers["kills"]))
		self.pers["kills"] = 0;
	if(isDefined(self.pers["score"]))
		self.pers["score"] = 0;
	if(isDefined(self.pers["deaths"]))
		self.pers["deaths"] = 0;

	message_player("^5INFO: ^7Your score is reset." );
}

cmd_optimize(args)
{
	if(args.size != 2) {
		message_player("^1ERROR: ^7Invalid number of arguments.");
		return;
	}

	args1 = args[1]; // num | string
	if(!isDefined(args1)) {
		message_player("^1ERROR: ^7Invalid argument.");
		return;
	}

	if(codam\_mm_mmm::validate_number(args1)) {
		player = codam\_mm_mmm::playerByNum(args1);
		if(!isDefined(player)) {
			message_player("^1ERROR: ^7No such player.");
			return;
		}
	} else {
		player = playerByName(args1);
		if(!isDefined(player)) return;
	}

	player setClientCvar("rate", 25000);
	wait 0.05;
	player setClientCvar("cl_maxpackets", 100);
	wait 0.05;
	player setClientCvar("snaps", 40);

	message_player("^5INFO: ^7Player " + codam\_mm_mmm::namefix(player.name) + " ^7connection settings optimized.");
	message_player("^5INFO: ^7" + codam\_mm_mmm::namefix(self.name) + " ^7modifed your 'rate', 'snaps' and 'cl_maxpackets' to optimal values.", player);
}

cmd_pcvar(args) // Reworked some commands from AJ into a global !pcvar command
{
	if(args.size != 4) {
		message_player("^1ERROR: ^7Invalid number of arguments.");
		return;
	}

	args1 = args[1]; // num | string

	cvar = args[2];
	cval = args[3];

	if(!isDefined(args1) || !isDefined(cvar) || !isDefined(cval)) {
		message_player("^1ERROR: ^7Invalid argument.");
		return;
	}

	if(codam\_mm_mmm::validate_number(args1)) {
		player = codam\_mm_mmm::playerByNum(args1);
		if(!isDefined(player)) {
			message_player("^1ERROR: ^7No such player.");
			return;
		}
	} else {
		player = playerByName(args1);
		if(!isDefined(player)) return;
	}

	switch(cvar) {
		case "dfps":
		case "drawfps":
			cvar = "cg_drawfps";
			break;
		case "lago":
		case "lagometer":
			cvar = "cg_lagometer";
			break;
		case "fps":
		case "maxfps":
			cvar = "com_maxfps";
			break;
		case "fov":
			cvar = "cg_fov";
			break;
		case "maxpackets":
			cvar = "cl_maxpackets";
			break;
		case "smc":
			cvar = "r_smc_enable";
			break;
		case "packetdup":
			cvar = "cl_packetdup";
			break;
		case "shadows":
			cvar = "cg_shadows";
			break;
		case "brass":
			cvar = "cg_brass";
			break;
		case "mouseaccel":
			cvar = "cl_mouseaccel";
			break;
		case "vsync":
			cvar = "r_swapinterval";
			break;
		case "blood":
			cvar = "cg_blood";
			break;
		case "hunk":
		case "hunkmegs":
			cvar = "com_hunkmegs";
			break;
		case "sun":
		case "drawsun":
			cvar = "r_drawsun";
			break;
		case "fastsky":
			cvar = "r_fastsky";
			break;
		case "marks":
			cvar = "cg_marks";
			break;
		case "third":
			cvar = "cg_thirdperson";
			break;
	}

	player setClientCvar(cvar, cval);

	message_player("^5INFO: ^7" + cvar + " set with value " + cval + " on player " + codam\_mm_mmm::namefix(player.name) + "^7.");
	message_player("^5INFO: ^7" + codam\_mm_mmm::namefix(self.name) + " ^7changed your client cvar " + cvar + " to " + cval + ".", player);
}

cmd_respawn(args)
{
	if(args.size < 2) {
		message_player("^1ERROR: ^7Invalid number of arguments.");
		return;
	}

	g_gametype[0] = "sd";
	g_gametype[1] = "dm";
	g_gametype[2] = "tdm";

	args1 = args[1]; // num | string

	if(codam\_mm_mmm::validate_number(args1)) {
		player = codam\_mm_mmm::playerByNum(args1);
		if(!isDefined(player)) {
			message_player("^1ERROR: ^7No such player.");
			return;
		}
	} else {
		player = playerByName(args1);
		if(!isDefined(player)) return;
	}

	if(!isAlive(player) || player.pers["team"] == "spectator") {
		message_player("^1ERROR: ^7Player must be alive and playing.");
		return;
	}

	stype = args[2]; // dm | tdm | sd
	if(!isDefined(stype))
		stype = tolower(getCvar("g_gametype"));

	if(!codam\_mm_mmm::in_array(g_gametype, stype)) {
		message_player("^1ERROR: ^7Unknown gametype, specify with !respawn <num> <sd|dm|tdm>.");
		return;
	}

	switch(stype) {
		case "dm":
			spawnpoints = getEntArray("mp_deathmatch_spawn", "classname");
			spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_DM(spawnpoints);
		break;
		case "sd":
			if(!isDefined(player.pers["team"])) { // This will never be true?
				message_player("^1ERROR: ^7Player team is not defined.");
				return;
			}

			if(player.pers["team"] == "allies")
				spawnpoints = getEntArray("mp_searchanddestroy_spawn_allied", "classname");
			else if(player.pers["team"] == "axis")
				spawnpoints = getEntArray("mp_searchanddestroy_spawn_axis", "classname");
			else {
				message_player("^1ERROR: ^7Player is not axis or allies.");
				return;
			}

			spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(spawnpoints);
		break;
		case "tdm":
			spawnpoints = getEntArray("mp_teamdeathmatch_spawn", "classname");
			spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam(spawnpoints);
		break;
	}

	if(isDefined(spawnpoint) && !positionWouldTelefrag(spawnpoint.origin)) {
		if(player != self) {
			message_player("^5INFO: ^7You respawned player " + codam\_mm_mmm::namefix(player.name) + "^7.");
			message_player("^5INFO: ^7You were respawned by " + codam\_mm_mmm::namefix(self.name) + "^7.", player);
		} else
			message_player("^5INFO: ^7You respawned yourself.");

		player setPlayerAngles(spawnpoint.angles);
		player setOrigin(spawnpoint.origin);
	}	else
		message_player("^1ERROR: ^7Problem with new spawnpoint, run command again.");
}

// cmd_teleport(args)
// {
// 	if(args.size == 1) { // from MiscMod command uuma
// 		self iPrintLn("^5Origin: ^1" + self.origin[0] + ", ^2" + self.origin[1] + ", ^3" + self.origin[2]);
// 		self iPrintLn("^6Angles: ^1" + self.angles[0] + ", ^2" + self.angles[1] + ", ^3" + self.angles[2]);
// 		return;
// 	}

// 	if(args.size == 2) {
// 		message_player("^1ERROR: ^7Invalid number of arguments, should be none, two or five.");
// 		return;
// 	}

// 	args1 = args[1]; // num | string
// 	if(codam\_mm_mmm::validate_number(args1)) {
// 		player1 = codam\_mm_mmm::playerByNum(args1);
// 		if(!isDefined(player1)) {
// 			message_player("^1ERROR: ^7No such player (" +  args1 + ").");
// 			return;
// 		}
// 	} else {
// 		player1 = playerByName(args1);
// 		if(!isDefined(player1)) return;
// 	}

// 	if(args.size == 3) {
// 		args2 = args[2]; // num | string
// 		if(codam\_mm_mmm::validate_number(args2)) {
// 			player2 = codam\_mm_mmm::playerByNum(args2);
// 			if(!isDefined(player2)) {
// 				message_player("^1ERROR: ^7No such player (" +  args2 + ").");
// 				return;
// 			}
// 		} else {
// 			player2 = playerByName(args2);
// 			if(!isDefined(player2)) return;
// 		}

// 		self endon("spawned");
// 		self endon("disconnect");

// 		toplayerorigin = player2.origin;
// 		for(i = 0; i < 360; i += 36) {
// 			angle = (0, i, 0);

// 			trace = bulletTrace(toplayerorigin, toplayerorigin + maps\mp\_utility::vectorscale(anglesToForward(angle), 48), true, self);
// 			if(trace["fraction"] == 1 && !positionWouldTelefrag(trace["position"]) && codam\_mm_mmm::_canspawnat(trace["position"])) {
// 				player1 setPlayerAngles(self.angles);
// 				player1 setOrigin(trace["position"]);
// 				message_player("^5INFO: ^7You were teleported to player: " + codam\_mm_mmm::namefix(player2.name) + "^7.", player1);
// 				return;
// 			}

// 			wait 0.05;
// 		}

// 		message_player("^1ERROR: ^7Unable to teleport to player: " + codam\_mm_mmm::namefix(player2.name) + "^7.");
// 		return;
// 	}

// 	if(args.size != 5) {
// 		message_player("^1ERROR: ^7Invalid number of arguments, should be none, two or five.");
// 		return;
// 	}

// 	if(codam\_mm_mmm::validate_number(args[2], true)
// 		&& codam\_mm_mmm::validate_number(args[3], true)
// 		&& codam\_mm_mmm::validate_number(args[4], true)) {
// 		x = (float)args[2];
// 		if(x == 0)
// 			x = self.origin[0];

// 		y = (float)args[3];
// 		if(y == 0)
// 			y = self.origin[1];

// 		z = (float)args[4];
// 		if(z == 0)
// 			z = self.origin[2];
// 	} else {
// 		message_player("^1ERROR: ^7x, y and/or z is not a number.");
// 		return;
// 	}

// 	if(player1 != self) {
// 		message_player("^5INFO: ^7You teleported to coordinates (" + x + ", " + y + ", " + z + ") player " + codam\_mm_mmm::namefix(player1.name) + "^7.");
// 		message_player("^5INFO: ^7You were teleported to coordinates (" + x + ", " + y + ", " + z + ") by " + codam\_mm_mmm::namefix(self.name) + "^7.", player1);
// 	} else
// 		message_player("^5INFO: ^7You teleported yourself to coordinates (" + x + ", " + y + ", " + z + ").");

// 	player1 setPlayerAngles(self.angles);
// 	player1 setOrigin((x, y, z));
// }

cmd_teleport(args)
{
	if(args.size == 1) { // from MiscMod command uuma
		self iPrintLn("^5Origin: ^1" + self.origin[0] + ", ^2" + self.origin[1] + ", ^3" + self.origin[2]);
		self iPrintLn("^6Angles: ^1" + self.angles[0] + ", ^2" + self.angles[1] + ", ^3" + self.angles[2]);
		return;
	}

	if(args.size == 2) {
		message_player("^1ERROR: ^7Invalid number of arguments, should be none, two or five.");
		return;
	}

	args1 = args[1]; // num | string
	if(codam\_mm_mmm::validate_number(args1)) {
		player1 = codam\_mm_mmm::playerByNum(args1);
		if(!isDefined(player1)) {
			message_player("^1ERROR: ^7No such player (" +  args1 + ").");
			return;
		}
	} else {
		player1 = playerByName(args1);
		if(!isDefined(player1)) return;
	}

	if(args.size == 3) {
		args2 = args[2]; // num | string
		if(codam\_mm_mmm::validate_number(args2)) {
			player2 = codam\_mm_mmm::playerByNum(args2);
			if(!isDefined(player2)) {
				message_player("^1ERROR: ^7No such player (" +  args2 + ").");
				return;
			}
		} else {
			player2 = playerByName(args2);
			if(!isDefined(player2)) return;
		}

		self endon("spawned");
		self endon("disconnect");

		toplayerorigin = player2.origin;
		for(i = 0; i < 360; i += 36) {
			angle = (0, i, 0);

			trace = bulletTrace(toplayerorigin, toplayerorigin + maps\mp\_utility::vectorscale(anglesToForward(angle), 48), true, self);
			if(trace["fraction"] == 1 && !positionWouldTelefrag(trace["position"]) && codam\_mm_mmm::_canspawnat(trace["position"])) {
				player1 setPlayerAngles(self.angles);
				player1 setOrigin(trace["position"]);
				if(player1 != self) {
					if(player2 != self)
						message_player("^5INFO: ^7You teleported " + codam\_mm_mmm::namefix(player1.name) + " to player " + codam\_mm_mmm::namefix(player2.name) + "^7.");
					else
						message_player("^5INFO: ^7You teleported " + codam\_mm_mmm::namefix(player1.name) + " to yourself.");
					message_player("^5INFO: ^7You were teleported to player " + codam\_mm_mmm::namefix(player2.name) + "^7.", player1);
				} else
					message_player("^5INFO: ^7You teleported yourself to player " + codam\_mm_mmm::namefix(player2.name) + "^7.");
				return;
			}

			wait 0.05;
		}

		message_player("^1ERROR: ^7Unable to teleport to player " + codam\_mm_mmm::namefix(player2.name) + "^7.");
		return;
	}

	if(args.size != 5) {
		message_player("^1ERROR: ^7Invalid number of arguments, should be none, two or five.");
		return;
	}

	if(codam\_mm_mmm::validate_number(args[2], true)
		&& codam\_mm_mmm::validate_number(args[3], true)
		&& codam\_mm_mmm::validate_number(args[4], true)) {
		x = (float)args[2];
		if(x == 0)
			x = self.origin[0];

		y = (float)args[3];
		if(y == 0)
			y = self.origin[1];

		z = (float)args[4];
		if(z == 0)
			z = self.origin[2];
	} else {
		message_player("^1ERROR: ^7x, y and/or z is not a number.");
		return;
	}

	if(player1 != self) {
		message_player("^5INFO: ^7You teleported to coordinates (" + x + ", " + y + ", " + z + ") player " + codam\_mm_mmm::namefix(player1.name) + "^7.");
		message_player("^5INFO: ^7You were teleported to coordinates (" + x + ", " + y + ", " + z + ") by " + codam\_mm_mmm::namefix(self.name) + "^7.", player1);
	} else
		message_player("^5INFO: ^7You teleported yourself to coordinates (" + x + ", " + y + ", " + z + ").");

	player1 setPlayerAngles(self.angles);
	player1 setOrigin((x, y, z));
}

cmd_teambalance(args)
{
	if(args.size != 2) {
		message_player("^1ERROR: ^7Invalid number of arguments.");
		return;
	}

	switch(args[1]) {
		case "on": case "1":
			setCvar("scr_teambalance", "1");
			message_player("^5INFO: ^7Team balance enabled.");
		break;
		case "off": case "0":
			setCvar("scr_teambalance", "0");
			message_player("^5INFO: ^7Team balance disabled.");
		break;
		case "force": case "balance": case "rebalance":
			_tmp = []; // from CoDaM's own command system "swapteams" in teams.gsc
			_tmp[0] = "allies";
			_allies = codam\utils::playersFromList(_tmp); // can return undefined if zero or other failures
			if(!isDefined(_allies))
				_allies = [];

			_tmp[0] = "axis";
			_axis = codam\utils::playersFromList(_tmp); // can return undefined if zero or other failures
			if(!isDefined(_axis))
				_axis = [];

			if(_axis.size - _allies.size > 1) {
				toteam = "allies";
				fromteam = _axis;
				movecount = _axis.size - _allies.size;
			} else if(_allies.size - _axis.size > 1) {
				toteam = "axis";
				fromteam = _allies;
				movecount = _allies.size - _axis.size;
			} else {
				message_player("^5INFO: ^7Teams are already balanced.");
				return;
			}

			if(movecount % 2 == 0) // even
				movecount /= 2;
			else // odd
				movecount = (movecount - 1) / 2;

			fromteam = codam\_mm_mmm::array_shuffle(fromteam);

			_players = [];
			for(i = 0; i < movecount; i++)
				_players[_players.size] = fromteam[i];

			message_player("^5INFO: ^7Moving " + movecount + " player(s) to " + toteam + ".");
			iPrintLn("Balancing teams...");
			[[level.gtd_call]]("switchTeam", _players, toteam, false);
		break;
		default:
			message_player("^1ERROR: ^7Invalid argument. Should be 'on', 'off' or 'force'.");
		break;
	}
}

cmd_swapteams(args)
{
	_tmp = []; // from CoDaM's own command system "swapteams" in teams.gsc
	_tmp[0] = "allies";
	_allies = codam\utils::playersFromList(_tmp);

	_tmp[0] = "axis";
	_axis = codam\utils::playersFromList(_tmp);

	message_player("^5INFO: ^7Swapping teams.");
	iPrintLn("Swapping teams...");

	[[level.gtd_call]]("switchTeam", _allies, "axis", true);
	[[level.gtd_call]]("switchTeam", _axis, "allies", true);
}

cmd_freeze(args)
{
	if(args.size != 3) {
		message_player("^1ERROR: ^7Invalid number of arguments. Expected <on|off> <num|all>.");
		return;
	}

	args1 = args[1]; // <on|off>
	if(!(args1 == "on" || args1 == "off")) {
		message_player("^1ERROR: ^7Invalid argument. Expected <on|off> <num|all>.");
		return;
	}

	args2 = args[2]; // <num|all>
	if(args2 != "all") {
		if(codam\_mm_mmm::validate_number(args2)) {
			player = codam\_mm_mmm::playerByNum(args2);
			if(!isDefined(player)) {
				message_player("^1ERROR: ^7No such player (" +  args2 + ").");
				return;
			}
		} else {
			player = playerByName(args2);
			if(!isDefined(player)) return;
		}

		if(args1 == "on") {
			if(!isDefined(player.cmdfreeze)) {
				player.cmdfreeze = spawn("script_origin", player.origin);
				player linkTo(player.cmdfreeze);
				if(player != self) {
					message_player("^5INFO: ^7You froze player " + codam\_mm_mmm::namefix(player.name) + "^7.");
					message_player("^5INFO: ^7You are frozen by " + codam\_mm_mmm::namefix(self.name) + "^7.", player);
				} else
					message_player("^5INFO: ^7You froze yourself.");
			} else {
				if(player != self)
					message_player("^1ERROR: ^7Player already frozen.");
				else
					message_player("^1ERROR: ^You are already frozen.");
			}
		} else {
			if(isDefined(player.cmdfreeze)) {
				player unlink();
				player.cmdfreeze delete();
				player.cmdfreeze = undefined;
				if(player != self) {
					message_player("^5INFO: ^7You unfroze player " + codam\_mm_mmm::namefix(player.name) + "^7.");
					message_player("^5INFO: ^7You are unfrozen by " + codam\_mm_mmm::namefix(self.name) + "^7.", player);
				} else
					message_player("^5INFO: ^7You unfroze yourself.");
			} else {
				if(player != self)
					message_player("^1ERROR: ^7Player not frozen.");
				else
					message_player("^1ERROR: ^You are not frozen.");
			}
		}
	} else {
		players = getEntArray("player", "classname");
		for(i = 0; i < players.size; i++) {
			player = players[i];
			if(!isAlive(player) || player.sessionstate != "playing" || player == self) continue;

			if(args1 == "on") {
				if(!isDefined(player.cmdfreeze)) {
					player.cmdfreeze = spawn("script_origin", player.origin);
					player linkTo(player.cmdfreeze);
					message_player("^5INFO: ^7You are frozen by " + codam\_mm_mmm::namefix(self.name) + "^7.", player);
				}
			} else {
				if(isDefined(player.cmdfreeze)) {
					player unlink();
					player.cmdfreeze delete();
					player.cmdfreeze = undefined;
					message_player("^5INFO: ^7You are unfrozen by " + codam\_mm_mmm::namefix(self.name) + "^7.", player);
				}
			}
		}

		if(args1 == "on")
			message_player("^5INFO: ^7You froze all the players, except yourself.");
		else
			message_player("^5INFO: ^7You unfroze all the frozen players.");
	}
}
