module.exports = {
    name: "register",
    description: "Register un joueur",
    role: "modo",

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

        OneLifeClass.PlayerRegister(null, args.id, function(msg){
            const embed = new client.Embed()
                .setTitle(`Register Joueur`)
                .setDescription(`${msg}`);
            interaction.reply({ embeds: [embed] });
        })
    },
};
