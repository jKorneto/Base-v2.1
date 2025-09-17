module.exports = {
    name: "infovehbyplate",
    description: "Avoir les infos du vehicule par sa plaque",
    role: "helper",

    options: [
        {
            name: "plate",
            description: "Plaque du vehicule",
            required: true,
            type: "STRING",
        }
    ],

    run: async (client, interaction, args) => {
        var OneLifeClass = global.exports[`${GetCurrentResourceName()}`].GetClassbot_api()

        OneLifeClass.GetVehiculeInfosByPlate(null, args.plate, function(msg){
            const embed = new client.Embed()
                .setTitle(`Vehicule Infos`)
                .setDescription(`${msg}`);
            interaction.reply({ embeds: [embed] });
        })
    },
};
