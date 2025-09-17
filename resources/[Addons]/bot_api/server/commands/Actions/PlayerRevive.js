module.exports = {
    name: "revive",
    description: "Revive un joueur",
    role: "helper",

    options: [
        {
            name: "id",
            description: "Id du joueurs",
            required: true,
            type: "STRING",
        }
    ],

    run: async (client, interaction, args) => {
        var OneLifeClass = global.exports[`${GetCurrentResourceName()}`].GetClassbot_api()

        OneLifeClass.PlayerRevive(null, args.id, function(msg){
            const embed = new client.Embed()
                .setTitle(`Revive Joueur`)
                .setDescription(`${msg}`);
            interaction.reply({ embeds: [embed] });
        })
    },
};
