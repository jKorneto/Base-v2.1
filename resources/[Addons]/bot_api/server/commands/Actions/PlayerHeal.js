module.exports = {
    name: "heal",
    description: "Heal un joueur",
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

        OneLifeClass.PlayerHeal(null, args.id, function(msg){
            const embed = new client.Embed()
                .setTitle(`Heal Joueur`)
                .setDescription(`${msg}`);
            interaction.reply({ embeds: [embed] });
        })
    },
};
