module.exports = {
    name: "infobydiscordid",
    description: "Avoir les infos du joueur par son id Discord",
    role: "helper",

    options: [
        {
            name: "discordid",
            description: "DiscordID du joueurs",
            required: true,
            type: "STRING",
        }
    ],

    run: async (client, interaction, args) => {
        var OneLifeClass = global.exports[`${GetCurrentResourceName()}`].GetClassbot_api()

        OneLifeClass.GetPlayerInfoByDiscordId(null, args.discordid, function(msg){
            const embed = new client.Embed()
                .setTitle(`Player Infos`)
                .setDescription(`${msg}`);
            interaction.reply({ embeds: [embed] });
        })
    },
};
