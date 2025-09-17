module.exports = {
    name: "gotopc",
    description: "Téléporter un joueur au PC",
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

        OneLifeClass.GotoPc(null, args.id, function(msg){
            const embed = new client.Embed()
                .setTitle(`Goto PC`)
                .setDescription(`${msg}`);
            interaction.reply({ embeds: [embed] });
        })
    },
};
