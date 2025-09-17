module.exports = {
    name: "ready",
    once: true,
    run: async (client) => {
        if (client.config.EnableDiscordSlashCommands) {
            const guild = client.guilds.cache.get(client.config.DiscordGuildId);
            if (!guild) return client.utils.log.error("DISCORD SERVER NOT FOUND - Is your config for 'DiscordGuildId' set correctly?");
            await guild.commands.set(client.arrayOfCommands).catch((error) => client.utils.log.handler("error", error));
        }
        client.utils.log.info(`Logged in as ${client.user.tag}`);


        client.user.setActivity({ name: 'OneLife !', type: "PLAYING" });
    },
};