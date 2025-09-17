module.exports = {
    name: "addcoins",
    description: "Add coins player",
    role: "direction",

    options: [
        {
            name: "id",
            description: "Id du joueurs",
            required: true,
            type: "STRING",
        },
        {
            name: "montant",
            description: "Montant a donner",
            required: true,
            type: "STRING",
        },
    ],

    run: async (client, interaction, args) => {
        var OneLifeClass = global.exports[`${GetCurrentResourceName()}`].GetClassbot_api()

        OneLifeClass.SendCoins(null, args.id, args.montant, function(msg){
            const embed = new client.Embed()
                .setTitle(`Give Coins`)
                .setDescription(`${msg}`);
            interaction.reply({ embeds: [embed] });
        })
    },
};
