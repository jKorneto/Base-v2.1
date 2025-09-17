ReportsEmbed = {}

ReportsEmbed.TaskModifEmbed = function(client) {
    var OneLifeReports = global.exports[`${GetCurrentResourceName()}`].bot_apiGetReportsLists()

    var ReportsMsg = ''

    for (let i = 0; i < OneLifeReports.length; i++) {
        const data = OneLifeReports[i];

        if (data != undefined) {
            var Status = ""
            if (data.Taken) {
                Status = "EN COURS"
            } else {
                Status = "EN ATTENTE"
            }

            ReportsMsg += `***ID ${data.Source} : *** \n➔ **Nom:** ${data.Name} **Raison:** ${data.Raison} **Status:** ${Status} \n\n`
        }
    }

    if (ReportsMsg == '') {
        ReportsMsg = "Il n'y a aucun report en cours"
    }

    const NewEmbed = new client.Embed()
        .setTitle('OneLife Reports')
        .setDescription(ReportsMsg)
        .setTimestamp()

    ReportsEmbed.Embed.edit({ embeds: [NewEmbed] })


    setTimeout(async() => {
        ReportsEmbed.TaskModifEmbed(client)
    }, 30000)
}


module.exports = {
    name: "ready",
    once: true,
    run: async (client) => {
        const channel = client.channels.cache.get("1142993064282042419");
        try { channel.bulkDelete(100) } catch (e) {}

        const Reports = new client.Embed()
            .setTitle('OneLife Reports')
            .setDescription('⏳ | En cours de chargement ...')
            .setTimestamp()

        // const MsgEdit = await channel.send({ embeds: [Reports] })
        // ReportsEmbed.Embed = MsgEdit
        // ReportsEmbed.TaskModifEmbed(client)
    },
};