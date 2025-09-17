module.exports = {
    name: "topbank",
    description: "Get list of top bank",
    role: "god",

    options: [
        {
            name: "nombre",
            description: "Nombre de joueurs",
            required: true,
            type: "STRING",
        },
    ],

    run: async (client, interaction, args) => {
        var Tonno = global.exports[`${GetCurrentResourceName()}`].GetFunctionTonnoBot()

        Tonno.GetTopBank(args.nombre, function(msg){
            const embed = new client.Embed()
                .setTitle(`Joueurs top banque`)
                .setDescription(`${msg}`);
            interaction.reply({ embeds: [embed] });
        })
    },
};