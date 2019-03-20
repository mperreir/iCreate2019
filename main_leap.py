import websockets
import asyncio

async def hello():
    async with websockets.connect('ws://127.0.0.1:6437') as websocket:
        data = await websocket.recv()
        print("data:" ,data)

asyncio.get_event_loop().run_until_complete(hello())