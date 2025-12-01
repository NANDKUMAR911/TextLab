import os
import asyncio
from quart import Quart, Response
from core.clients import start_clients


app = Quart(__name__)

@app.get("/")
async def home():
    return {"status": "Bot running!"}


@app.route("/health")
async def health():
    html_content = """
    <html>
      <head><title>Bot Status</title></head>
      <body>
        <h1 style="color:green;">✅ Bot is running</h1>
        <p>All systems operational.</p>
      </body>
    </html>
    """
    return Response(html_content, status=200, content_type="text/html")
    

async def main():
    # Get port from ENV or use default 10000
    port = int(os.getenv("PORT", "10000"))

    # Start Telegram bot + userbot + pytgcalls in background
    bot_task = asyncio.create_task(start_clients())

    # Start Quart web server
    web_task = asyncio.create_task(
        app.run_task(host="0.0.0.0", port=port)
    )
    # Keep both tasks alive
    await asyncio.gather(bot_task, web_task)


if __name__ == "__main__":
    try:
        asyncio.run(main())
    except KeyboardInterrupt:
        print("Shutting down...")
