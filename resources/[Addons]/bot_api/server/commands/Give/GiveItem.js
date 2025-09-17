module.exports = {
    name: "giveitem",
    description: "GiveItem au joueur",
    role: "admin",

    options: [
        {
            name: "id",
            description: "Id du joueurs",
            required: true,
            type: "STRING",
        },
        {
            name: "item",
            description: "Nom de l'item",
            required: true,
            type: "STRING",
        },
        {
            name: "count",
            description: "Montant a donner",
            required: true,
            type: "STRING",
        },
    ],

    run: async (client, interaction, args) => {
        var OneLifeClass = global.exports[`${GetCurrentResourceName()}`].GetClassbot_api()

        OneLifeClass.GiveItem(null, args.id, args.item, args.count, function(msg){
            const embed = new client.Embed()
                .setTitle(`Give Item`)
                .setDescription(`${msg}`);
            interaction.reply({ embeds: [embed] });
        })
    },
};
