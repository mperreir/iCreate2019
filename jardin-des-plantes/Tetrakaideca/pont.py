import asyncio
import websockets
import json

async def pont(websocket2, path):
	
	print("connecting to leap")
	async with websockets.connect( 'ws://localhost:6437/v6.json') as websocket:
		
		
		print("connected")
		i=0
		while True:	
			i=i+1
			print("waiting for data")
			data = await websocket.recv()
			#print(data)
			if i == 2 :
				#backgroundMessage = json.stringify({background: true});
				print("envoie retour")
				await websocket.send(json.dumps({"focused": True}))
			if data:
				await websocket2.send(data)
				print("forwarded")
			

	
start_server = websockets.serve(pont, '172.20.10.5', 8081)

asyncio.get_event_loop().run_until_complete(start_server)
asyncio.get_event_loop().run_forever()

