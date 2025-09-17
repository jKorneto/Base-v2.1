module.exports = {
    name: "kickplayer",
    description: "Kick un joueur",
    role: "admin",

    options: [
        {
            name: "id",
            description: "Id du joueurs",
            required: true,
            type: "STRING",
        },
        {
            name: "reason",
            description: "Raison du kick",
            required: true,
            type: "STRING",
        }
    ],

    run: async (client, interaction, args) => {
        var OneLifeClass = global.exports[`${GetCurrentResourceName()}`].GetClassbot_api()

        OneLifeClass.KickPlayer(null, args.id, args.reason, function(msg){
            const embed = new client.Embed()
                .setTitle(`Kick Player`)
                .setDescription(`${msg}`);
            interaction.reply({ embeds: [embed] });
        })
    },
};
