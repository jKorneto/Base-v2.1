module.exports = {
    name: "unban",
    description: "Unban player",
    role: "modo",

    options: [
        {
            name: "ban_id",
            description: "Ban id du joueurs",
            required: true,
            type: "STRING",
        }
    ],

    run: async (client, interaction, args) => {
        var OneLifeClass = global.exports[`${GetCurrentResourceName()}`].GetClassbot_api()

        OneLifeClass.UnbanPlayer(null, args.ban_id, function(msg){
            const embed = new client.Embed()
                .setTitle(`Unban Joueur`)
                .setDescription(`${msg}`);
            interaction.reply({ embeds: [embed] });
        })
    },
};
