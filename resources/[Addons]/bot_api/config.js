// This spams the console, only enable for testing if needed
const DebugLogs = false;

/** ********************
 * DISCORD BOT SETTINGS
 ***********************/

const EnableDiscordBot = true;

// DISCORD BOT
const DiscordBotToken = "MTMyNjMyOTM3NDM3MDMwMDAyNg.Gu9y-J.CtGo3QHnB5IOAC36hS0mOCYXM-FVKNKHOB2Jl0";
const DiscordGuildId = "1295809228358811658";

// SLASH COMMANDS / DISCORD PERMISSIONS
const EnableDiscordSlashCommands = true;

const PermisionList = [
    { name: "helper", id: "1300909180600848496" },  //Helper
    { name: "modo", id: "1300909176947740694" }, //Moderateur
    { name: "admin", id: "1300909173600686110" }, //Administrateur

    { name: "responsable", id: "1092857483757879347" }, //Responsable

    { name: "direction", id: [
        "1300909153891651655", //Coordinateur
        "1300909150372368477", //Gerant staff
    ]},

    { name: "god", id: [
        "1300909132336992488", // Fonda
        "1326252863973883914", // CO FONDA
    ]},
]


/*
 * !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
 * !! DO NOT EDIT BELOW THIS LINE UNLESS YOU KNOW WHAT YOU'RE DOING !
 * !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
*/

module.exports = {
    EnableDiscordBot: EnableDiscordBot,
    DebugLogs: DebugLogs,

    DiscordBotToken: DiscordBotToken,
    DiscordGuildId: DiscordGuildId,

    EnableDiscordSlashCommands: EnableDiscordSlashCommands,

    DiscordPermisionList: PermisionList,
};

/** Returns convar or default value fixed to a true/false boolean
 * @param {boolean|string|number} con - Convar name
 * @param {boolean|string|number} def - Default fallback value
 * @returns {boolean} - parsed bool */
function getConBool(con, def) {
    if (typeof def == "boolean") def = def.toString();
    const ret = GetConvar(con, def);
    if (typeof ret == "boolean") return ret;
    if (typeof ret == "string") return ["true", "on", "yes", "y", "1"].includes(ret.toLocaleLowerCase().trim());
    if (typeof ret == "number") return ret > 0;
    return false;
}