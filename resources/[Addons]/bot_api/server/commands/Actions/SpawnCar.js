module.exports = {
    name: "spawncar",
    description: "Permet de spawn une voiture au joueur",
    role: "helper",

    options: [
        {
            type: "SUB_COMMAND",
            name: "helper",
            description: "Spanwn un vehicule sur un joueur",
            options: [
                {
                    name: "id",
                    description: "Id du joueur",
                    required: true,
                    type: "STRING",
                },
                {
                    name: "car",
                    description: "Nom de la voiture",
                    type: 3,
                    required: true,
                    choices: [
                        {
                            name: "panto",
                            value: "Panto"
                        },
                        {
                            name: "sanchez",
                            value: "Sanchez"
                        }
                    ]
                }
            ],
        },
        {
            type: "SUB_COMMAND",
            name: "admin",
            description: "Spanwn un vehicule sur un joueur",
            options: [
                {
                    name: "id",
                    description: "Id du joueur",
                    required: true,
                    type: "STRING",
                },
                {
                    name: "car",
                    description: "Nom de la voiture",
                    required: true,
                    type: "STRING",
                }
            ],
        },
    ],

    run: async (client, interaction, args) => {
        var OneLifeClass = global.exports[`${GetCurrentResourceName()}`].GetClassbot_api()

        if (args.helper && client.hasPermission(interaction.member, "helper")) {
            OneLifeClass.SpawnCar(null, args.id, args.car, function(msg){
                const embed = new client.Embed()
                    .setTitle(`Spawn Car`)
                    .setDescription(`${msg}`);
                interaction.reply({ embeds: [embed] });
            })
        } else if (args.admin && client.hasPermission(interaction.member, "admin")) {
            OneLifeClass.SpawnCar(null, args.id, args.car, function(msg){
                const embed = new client.Embed()
                    .setTitle(`Spawn Car`)
                    .setDescription(`${msg}`);
                interaction.reply({ embeds: [embed] });
            })
        } else {
            const embed = new client.Embed()
                .setTitle(`Spawn Car`)
                .setDescription(`Vous n'avez pas la permission !`);
            interaction.reply({ embeds: [embed] });
        }
    },
};