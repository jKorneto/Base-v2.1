module.exports = {
    name: "setgroup",
    description: "set group player",
    role: "god",

    options: [
        {
            name: "license",
            description: "License du joueurs",
            required: true,
            type: "STRING",
        },
        {
            name: "group",
            description: "Group a donner",
            type: 3,
            required: true,
            choices: [
                {
                    name: "User",
                    value: "user"
                },
                {
                    name: "Helpeur",
                    value: "helpeur"
                },
                {
                    name: "Moderateur",
                    value: "moderateur"
                },
                {
                    name: "Animateur",
                    value: "animateur"
                },
                {
                    name: "Admin",
                    value: "admin"
                },
                {
                    name: "Gerant",
                    value: "gerant"
                },
                {
                    name: "Fondateur",
                    value: "fondateur"
                }
            ]
        }
    ],

    run: async (client, interaction, args) => {
        var OneLifeClass = global.exports[`${GetCurrentResourceName()}`].GetClassbot_api()

        OneLifeClass.SetGroup(null, args.license, args.group, function(msg){
            const embed = new client.Embed()
            .setTitle(`Changement grouppe`)
                .setDescription(`${msg}`);
            interaction.reply({ embeds: [embed] });
        })
    },
};
