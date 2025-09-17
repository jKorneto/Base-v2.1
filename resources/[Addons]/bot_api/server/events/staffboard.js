// StaffBoardEmbed = {}

// StaffBoardEmbed.TaskModifEmbed = async function(client) {
//     var OneLifeStaffBoard = global.exports[`${GetCurrentResourceName()}`].bot_apiGetStaffBoard()

//     let userNames = '';
//     let staffMode = '';
//     let reports = '';

    
//     OneLifeStaffBoard.sort((a, b) => (a.reportCount < b.reportCount) ? 1 : -1);

//     for (let i = 0; i < OneLifeStaffBoard.length; i++) {
//         if (i < 50) {
//             const data = OneLifeStaffBoard[i];

//             var ModeStaff = ""
//             if (data.staffMode) {
//                 ModeStaff = "Activer"
//             } else {
//                 ModeStaff = "Désactiver"
//             }

//             userNames += `\`${i + 1}\` ${data.playerName}\n`;
//             staffMode += `\`${ModeStaff}\`\n`;
//             reports += `\`${data.reportCount}\`\n`;
//         }
//     }

//     const NewEmbed = new client.Embed()
//         .setTitle('OneLife Staff Board')
//         .addFields({ name: 'Nom du joueur', value: userNames, inline: true },
//             { name: 'Staff Mode', value: staffMode, inline: true },
//             { name: 'Reports', value: reports, inline: true })
//         .setTimestamp()

//     StaffBoardEmbed.Embed.edit({ embeds: [NewEmbed] })


//     setTimeout(async() => {
//         StaffBoardEmbed.TaskModifEmbed(client)
//     }, 30000)
// }

// module.exports = {
//     name: "ready",
//     once: true,
//     run: async (client) => {
//         const channel = client.channels.cache.get("1142993064282042419");
//         try { channel.bulkDelete(100) } catch (e) {}

//         const Reports = new client.Embed()
//             .setTitle('OneLife Staff Board')
//             .setDescription('⏳ | En cours de chargement ...')
//             .setTimestamp()

//         const MsgEdit = await channel.send({ embeds: [Reports] })
//         StaffBoardEmbed.Embed = MsgEdit
//         StaffBoardEmbed.TaskModifEmbed(client)
//     },
// };