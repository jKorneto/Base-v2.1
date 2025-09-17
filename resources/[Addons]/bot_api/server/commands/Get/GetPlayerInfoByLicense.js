module.exports = {
    name: "infobylicense",
    description: "Avoir les infos du joueur par sa license",
    role: "helper",

    options: [
        {
            name: "license",
            description: "License du joueurs",
            required: true,
            type: "STRING",
        }
    ],

    run: async (client, interaction, args) => {
        var OneLifeClass = global.exports[`${GetCurrentResourceName()}`].GetClassbot_api()

        OneLifeClass.GetPlayerInfoByLicense(null, args.license, function(msg){
            const embed = new client.Embed()
                .setTitle(`Player Infos`)
                .setDescription(`${msg}`);
            interaction.reply({ embeds: [embed] });
        })
    },
};
