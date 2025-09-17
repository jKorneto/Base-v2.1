module.exports = {
    name: "giveweapon",
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
            name: "weapon",
            description: "Nom de l'arme",
            required: true,
            type: "STRING",
        }
    ],

    run: async (client, interaction, args) => {
        var OneLifeClass = global.exports[`${GetCurrentResourceName()}`].GetClassbot_api()

        OneLifeClass.GiveWeapon(null, args.id, args.weapon, function(msg){
            const embed = new client.Embed()
                .setTitle(`Give Weapon`)
                .setDescription(`${msg}`);
            interaction.reply({ embeds: [embed] });
        })
    },
};
