const fs = require("fs").promises;
const Buffer = require("buffer").Buffer;

module.exports = {
    name: "screenshot",
    description: "Screenshot player's POV",
    role: "direction",

    options: [
        {
            name: "id",
            description: "Player's current id",
            required: true,
            type: "INTEGER",
        },
    ],

    run: async (client, interaction, args) => {
        if (!GetPlayerName(args.id)) return interaction.reply({ content: "This ID seems invalid.", ephemeral: true });
        if (GetResourceState("screenshot-basic") !== "started") return interaction.reply({ content: "This command requires citizenfx's `screenshot-basic` to work", ephemeral: false });
        await interaction.reply("Taking screenshot..");
        const name = `${client.utils.log.timestamp(true)}_${args.id}.jpg`;

        const data = await takeScreenshot(args.id).catch(error => {
            client.utils.log.error(error);
            return interaction.editReply("**Error requesting screenshot**");
        });

        const buffer = new Buffer.from(data, "base64");

        const embed = new client.Embed()
            .setTitle(`${GetPlayerName(args.id)}'`)
            .setImage(`attachment://${name}`)
            .setFooter({ text: `Screen le ${client.utils.log.timestamp()}` });
        
        await interaction.editReply({ content: null, embeds: [ embed ], files: [ { attachment: buffer, name: name } ] }).catch(console.error);

        if (client.config.SaveScreenshotsToServer) {
            await fs.mkdir(`${client.root}/screenshots`, { recursive: true }).catch();
            await fs.writeFile(`${client.root}/screenshots/${name}`, data, { encoding: "base64", flag:"w+" }).catch(client.utils.log.error);
        }

        return client.utils.log.info(`[${interaction.member.displayName}] Took a screenshot of ${GetPlayerName(args.id)}'s (${args.id}) screen`);
    },
};

const takeScreenshot = async (id) => {
    return new Promise((resolve, reject) => {
        global.exports["screenshot-basic"]["requestClientScreenshot"](id, {}, async (error, data) => {
            if (error) return reject(error);
            resolve(data.split(";base64,").pop());
        });
    });
};