import discord
from discord.ext import commands

intents = discord.Intents.default()
intents.message_content = True

bot = commands.Bot(command_prefix='/', intents=intents)

@bot.event
async def on_ready():
    print(f'Bot đã đăng nhập với tên: {bot.user}')

@bot.command()
async def script(ctx):
    code = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/Dex-Bear/VxezeHubHopBoss/refs/heads/main/SkidConCacBaM"))()'
    await ctx.send(f"```lua\n{code}\n```")

bot.run("YOUR_DISCORD_BOT_TOKEN")
