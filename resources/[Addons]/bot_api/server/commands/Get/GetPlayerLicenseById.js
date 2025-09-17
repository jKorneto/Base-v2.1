module.exports = {
    name: "playerlicensebyid",
    description: "Avoir la license du joueur par son ID",
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

        OneLifeClass.GetPlayerLicenseById(null, args.id, function(msg){
            const embed = new client.Embed()
                .setTitle(`Player license`)
                .setDescription(`${msg}`);
            interaction.reply({ embeds: [embed] });
        })
    },
};
