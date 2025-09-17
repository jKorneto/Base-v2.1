const z = {};

// const { readdirSync } = require("fs");
z.root = GetResourcePath(GetCurrentResourceName());
z.config = require(`${z.root}/config`);
z.utils = require(`${z.root}/server/utils`);

const Bot = require(`${z.root}/server/bot`);
z.bot = new Bot(z);

// EXPORTS

global.exports("isRolePresent", (identifier, role) => {
    return z.bot.isRolePresent(identifier, role);
});

global.exports("getRoles", (identifier) => {
    return z.bot.getMemberRoles(identifier);
});

global.exports("getName", (identifier) => {
    const member = z.bot.parseMember(identifier);
    return member.displayName || false;
});

global.exports("getDiscordId", (identifier) => {
    return z.utils.getPlayerDiscordId(identifier);
});

var fs = require('fs');
global.exports("SendStaffBoard", (StaffList) => {
    const channel = z.bot.channels.cache.get("1150480651573805127");

    StaffList.sort((a, b) => (a.reportCount < b.reportCount) ? 1 : -1);

    var StaffBoardMsg = ''

    for (let i = 0; i < StaffList.length; i++) {
        if (i < 50) {
            const data = StaffList[i];

            StaffBoardMsg += `➔ Le joueurs: ${data.playerName} à effectués ${data.reportCount} reports. Temps moyen des reports: ${'10s'}. Nombre de coins recu: ${data.credit}\n\n`
        }
    }

    const now = new Date();

    const todaysDate = now.getTime()
    
    fs.writeFile('./StaffBoardList/staffboard' + todaysDate + '.txt', StaffBoardMsg, (err) => {
        if (err) throw err;
    })

    const StaffListEmb = new z.bot.Embed()
        .setTitle('OneLife Staff Board')
        .setDescription('Liste des reports du ' + now.toLocaleString("fr-FR"))
        .setTimestamp()

    channel.send({ embeds: [StaffListEmb], files: ["./StaffBoardList/staffboard"+ todaysDate + ".txt"] })
});